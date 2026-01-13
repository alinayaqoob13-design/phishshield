import '../entities/scan_result.dart';

abstract class UrlScannerRepository {
  /// Checks the provided URL for phishing threats
  Future<ScanResult> checkUrl(String url);

  /// Gets the scan history from local storage
  Future<List<ScanResult>> getHistory();

  /// Saves a scan result to history
  Future<void> saveToHistory(ScanResult result);

  /// Clears all scan history
  Future<void> clearHistory();
}
