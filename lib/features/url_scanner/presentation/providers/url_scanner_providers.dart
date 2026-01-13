import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:sqflite/sqflite.dart';

import '../../data/data_sources/url_scanner_local_data_source.dart';
import '../../data/data_sources/url_scanner_remote_data_source.dart';
import '../../data/repositories/url_scanner_repository_impl.dart';
import '../../domain/repositories/url_scanner_repository.dart';
import '../../domain/entities/scan_result.dart';
import '../../../history/presentation/providers/history_provider.dart';
import 'package:phishshield/core/database/database_provider.dart';

/// HTTP CLIENT
final httpClientProvider = Provider<http.Client>((ref) {
  return http.Client();
});

/// REMOTE DATA SOURCE
final remoteDataSourceProvider = Provider<UrlScannerRemoteDataSource>((ref) {
  return UrlScannerRemoteDataSource(client: http.Client()); // remove this
});


/// LOCAL DATA SOURCE
final localDataSourceProvider = Provider<UrlScannerLocalDataSource>((ref) {
  final db = ref.watch(databaseProvider);
  return UrlScannerLocalDataSource(database: db);
});

/// REPOSITORY
final urlScannerRepositoryProvider = Provider<UrlScannerRepository>((ref) {
  return UrlScannerRepositoryImpl(
    remoteDataSource: ref.watch(remoteDataSourceProvider),
    localDataSource: ref.watch(localDataSourceProvider),
  );
});

/// STATE
class UrlScanState {
  final bool isLoading;
  final ScanResult? result;
  final String? error;

  const UrlScanState({
    this.isLoading = false,
    this.result,
    this.error,
  });

  UrlScanState copyWith({
    bool? isLoading,
    ScanResult? result,
    String? error,
    bool clearError = false,
  }) {
    return UrlScanState(
      isLoading: isLoading ?? this.isLoading,
      result: result ?? this.result,
      error: clearError ? null : (error ?? this.error),
    );
  }
}

/// NOTIFIER
class UrlScanNotifier extends Notifier<UrlScanState> {
  @override
  UrlScanState build() => const UrlScanState();

  Future<void> checkUrl(String url) async {
    state = state.copyWith(isLoading: true, clearError: true);

    try {
      final repo = ref.read(urlScannerRepositoryProvider);
      final result = await repo.checkUrl(url);

      state = state.copyWith(
        isLoading: false,
        result: result,
        clearError: true,
      );

      // refresh history
      try {
        await ref.read(historyProvider.notifier).refreshHistory();
      } catch (_) {}

    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  void clearResult() {
    state = const UrlScanState();
  }
}

final urlScanProvider =
NotifierProvider<UrlScanNotifier, UrlScanState>(() => UrlScanNotifier());
