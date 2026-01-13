import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../url_scanner/presentation/providers/url_scanner_providers.dart';
import '../../data/models/qr_scan_state.dart';
import '../../../history/presentation/providers/history_provider.dart';
import '../../../blockchain_report/presentation/providers/blockchain_report_provider.dart';

class QrScanNotifier extends Notifier<QrScanState> {
  @override
  QrScanState build() {
    return const QrScanState();
  }

  /// Process the scanned URL for threat analysis
  Future<void> processScannedUrl(String url) async {
    state = state.copyWith(
      isScanning: false,
      isProcessing: true,
      scannedUrl: url,
      error: null,
    );

    try {
      final repository = ref.read(urlScannerRepositoryProvider);
      final result = await repository.checkUrl(url);

      state = state.copyWith(
        isProcessing: false,
        result: result,
        error: null,
      );

      // Refresh history
      try {
        await ref.read(historyProvider.notifier).refreshHistory();
      } catch (_) {}
    } catch (e) {
      state = state.copyWith(
        isProcessing: false,
        error: e.toString(),
      );
    }
  }

  /// Submit the scanned URL to blockchain
  Future<void> submitToBlockchain() async {
    if (state.scannedUrl == null) return;

    state = state.copyWith(isProcessing: true, error: null);

    try {
      final blockchainProvider = ref.read(blockchainReportProvider);
      await blockchainProvider.submitReport(state.scannedUrl!);

      final response = blockchainProvider.response;

      if (response != null && response.success) {
        // Submission successful, stop processing
        state = state.copyWith(isProcessing: false);
      } else {
        state = state.copyWith(
          isProcessing: false,
          error: response?.message ?? "Failed to submit to blockchain",
        );
      }
    } catch (e) {
      state = state.copyWith(
        isProcessing: false,
        error: e.toString(),
      );
    }
  }

  /// Reset scanner state
  void resetScanner() {
    state = const QrScanState();
  }

  /// Resume scanning after pause
  void resumeScanning() {
    state = state.copyWith(
      isScanning: true,
      scannedUrl: null,
      result: null,
      error: null,
    );
  }
}

final qrScanProvider = NotifierProvider<QrScanNotifier, QrScanState>(
  QrScanNotifier.new,
);
