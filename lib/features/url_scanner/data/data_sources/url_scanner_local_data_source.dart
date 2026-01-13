import 'package:sqflite/sqflite.dart';
import '../models/scan_result_model.dart';

class UrlScannerLocalDataSource {
  final Database database;

  UrlScannerLocalDataSource({required this.database});

  /// Save scan result to SQLite database
  Future<void> saveToHistory(ScanResultModel result) async {
    try {
      final id = await database.insert(
        'scan_history',
        result.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
      print('✅ Saved to history with ID: $id - URL: ${result.url}');
    } catch (e) {
      print('❌ Failed to save to history: $e');
      throw CacheException('Failed to save to history: $e');
    }
  }

  /// Get scan history from SQLite database
  Future<List<ScanResultModel>> getHistory() async {
    try {
      print('📜 Loading history from database...');
      final List<Map<String, dynamic>> maps = await database.query(
        'scan_history',
        orderBy: 'timestamp DESC',
      );

      final results = maps.map((map) => ScanResultModel.fromMap(map)).toList();
      print('✅ Loaded ${results.length} items from database');
      return results;
    } catch (e) {
      print('❌ Failed to load history: $e');
      throw CacheException('Failed to load history: $e');
    }
  }

  /// Clear all scan history
  Future<void> clearHistory() async {
    try {
      await database.delete('scan_history');
      print('✅ History cleared from database');
    } catch (e) {
      print('❌ Failed to clear history: $e');
      throw CacheException('Failed to clear history: $e');
    }
  }

  /// Delete a specific scan result by ID
  Future<void> deleteHistoryItem(int id) async {
    try {
      await database.delete('scan_history', where: 'id = ?', whereArgs: [id]);
      print('✅ Deleted history item with ID: $id');
    } catch (e) {
      print('❌ Failed to delete history item: $e');
      throw CacheException('Failed to delete history item: $e');
    }
  }
}

// Custom Exception
class CacheException implements Exception {
  final String message;
  CacheException(this.message);

  @override
  String toString() => message;
}

// Network Exception
class NetworkException implements Exception {
  final String message;
  NetworkException(this.message);

  @override
  String toString() => message;
}

// Server Exception
class ServerException implements Exception {
  final String message;
  ServerException(this.message);

  @override
  String toString() => message;
}
