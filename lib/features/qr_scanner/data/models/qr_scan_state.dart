import '../../../url_scanner/domain/entities/scan_result.dart';

class QrScanState {
  final bool isScanning;
  final bool isProcessing;
  final String? scannedUrl;
  final ScanResult? result;
  final String? error;

  const QrScanState({
    this.isScanning = true,
    this.isProcessing = false,
    this.scannedUrl,
    this.result,
    this.error,
  });

  QrScanState copyWith({
    bool? isScanning,
    bool? isProcessing,
    String? scannedUrl,
    ScanResult? result,
    String? error,
  }) {
    return QrScanState(
      isScanning: isScanning ?? this.isScanning,
      isProcessing: isProcessing ?? this.isProcessing,
      scannedUrl: scannedUrl ?? this.scannedUrl,
      result: result ?? this.result,
      error: error ?? this.error,
    );
  }
}
