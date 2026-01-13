import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../url_scanner/presentation/providers/url_scanner_providers.dart';
import '../../data/models/history_state.dart';

class HistoryNotifier extends Notifier<HistoryState> {
  bool _initialized = false;

  @override
  HistoryState build() {
    // Initialize history on first build
    _initializeHistory();
    return const HistoryState();
  }

  Future<void> _initializeHistory() async {
    if (_initialized) return;
    _initialized = true;

    // Add small delay to ensure database is ready
    await Future.delayed(Duration(milliseconds: 500));

    try {
      final repository = ref.read(urlScannerRepositoryProvider);
      final history = await repository.getHistory();

      state = state.copyWith(
        isLoading: false,
        history: history,
        clearError: true,
      );
      print('✅ History initialized with ${history.length} items');
    } catch (e) {
      print('❌ Failed to initialize history: $e');
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  Future<void> loadHistory() async {
    state = state.copyWith(isLoading: true, clearError: true);

    try {
      final repository = ref.read(urlScannerRepositoryProvider);
      final history = await repository.getHistory();
      state = state.copyWith(
        isLoading: false,
        history: history,
        clearError: true,
      );
      print('✅ History loaded with ${history.length} items');
    } catch (e) {
      print('❌ Failed to load history: $e');
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  Future<void> clearHistory() async {
    try {
      final repository = ref.read(urlScannerRepositoryProvider);
      await repository.clearHistory();
      state = state.copyWith(history: [], clearError: true);
      print('✅ History cleared');
    } catch (e) {
      print('❌ Failed to clear history: $e');
      state = state.copyWith(error: e.toString());
    }
  }

  // Add method to manually refresh history
  Future<void> refreshHistory() async {
    await loadHistory();
  }
}

final historyProvider = NotifierProvider<HistoryNotifier, HistoryState>(
  () => HistoryNotifier(),
);
