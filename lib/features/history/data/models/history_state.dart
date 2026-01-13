import '../../../url_scanner/domain/entities/scan_result.dart';

class HistoryState {
  final bool isLoading;
  final List<ScanResult> history;
  final String? error;

  const HistoryState({
    this.isLoading = false,
    this.history = const [],
    this.error,
  });

  HistoryState copyWith({
    bool? isLoading,
    List<ScanResult>? history,
    String? error,
    bool clearError = false,
  }) {
    return HistoryState(
      isLoading: isLoading ?? this.isLoading,
      history: history ?? this.history,
      error: clearError ? null : (error ?? this.error),
    );
  }
}
