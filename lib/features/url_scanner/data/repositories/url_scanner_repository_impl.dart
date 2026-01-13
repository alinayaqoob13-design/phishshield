import '../../domain/entities/scan_result.dart';
import '../../domain/repositories/url_scanner_repository.dart';
import '../data_sources/url_scanner_local_data_source.dart';
import '../data_sources/url_scanner_remote_data_source.dart';
import '../models/scan_result_model.dart';

class UrlScannerRepositoryImpl implements UrlScannerRepository {
  final UrlScannerRemoteDataSource remoteDataSource;
  final UrlScannerLocalDataSource localDataSource;

  UrlScannerRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
  });

  @override
  Future<ScanResult> checkUrl(String url) async {
    try {
      // Get result from remote API
      final result = await remoteDataSource.checkUrl(url);

      // Save to history automatically using SQLite
      try {
        await localDataSource.saveToHistory(result);
      } catch (e) {
        // Don't throw error, just log it
      }

      return result.toEntity();
    } on ServerException catch (e) {
      throw Exception('Server Error: ${e.message}');
    } on NetworkException catch (e) {
      throw Exception('Network Error: ${e.message}');
    } catch (e) {
      throw Exception('Unexpected Error: $e');
    }
  }

  @override
  Future<List<ScanResult>> getHistory() async {
    try {
      final models = await localDataSource.getHistory();
      return models.map((model) => model.toEntity()).toList();
    } on CacheException catch (e) {
      throw Exception('Cache Error: ${e.message}');
    } catch (e) {
      throw Exception('Unexpected Error: $e');
    }
  }

  @override
  Future<void> saveToHistory(ScanResult result) async {
    try {
      final model = ScanResultModel.fromEntity(result);
      await localDataSource.saveToHistory(model);
    } on CacheException catch (e) {
      throw Exception('Cache Error: ${e.message}');
    } catch (e) {
      throw Exception('Unexpected Error: $e');
    }
  }

  @override
  Future<void> clearHistory() async {
    try {
      await localDataSource.clearHistory();
    } on CacheException catch (e) {
      throw Exception('Cache Error: ${e.message}');
    } catch (e) {
      throw Exception('Unexpected Error: $e');
    }
  }
}

// Custom Exceptions (Add these if not already defined)
class ServerException implements Exception {
  final String message;
  ServerException(this.message);
}

class NetworkException implements Exception {
  final String message;
  NetworkException(this.message);
}

class CacheException implements Exception {
  final String message;
  CacheException(this.message);
}
