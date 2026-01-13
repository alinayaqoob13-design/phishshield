import '../../domain/entities/scan_result.dart';

class ScanResultModel extends ScanResult {
  const ScanResultModel({
    super.id,
    required super.url,
    required super.prediction,
    super.confidence,
    super.maliciousProbability,
    super.safeProbability,
    required super.timestamp,
  });

  // ========== API JSON METHODS ==========

  /// Create model from API response JSON
  factory ScanResultModel.fromJson(Map<String, dynamic> json, String url) {
    return ScanResultModel(
      url: url,
      prediction: json['prediction'] ?? 'Unknown',
      confidence: json['confidence']?.toString(),
      maliciousProbability: json['malicious_probability']?.toString(),
      safeProbability: json['safe_probability']?.toString(),
      timestamp: DateTime.now(),
    );
  }

  /// Convert model to JSON (for local storage)
  Map<String, dynamic> toJson() {
    return {
      'url': url,
      'prediction': prediction,
      'confidence': confidence,
      'malicious_probability': maliciousProbability,
      'safe_probability': safeProbability,
      'timestamp': timestamp.toIso8601String(),
    };
  }

  /// Create model from stored JSON
  factory ScanResultModel.fromStorageJson(Map<String, dynamic> json) {
    return ScanResultModel(
      url: json['url'] ?? '',
      prediction: json['prediction'] ?? 'Unknown',
      confidence: json['confidence']?.toString(),
      maliciousProbability: json['malicious_probability']?.toString(),
      safeProbability: json['safe_probability']?.toString(),
      timestamp: DateTime.parse(json['timestamp']),
    );
  }

  // ========== SQLITE MAP METHODS ==========

  /// Convert model to Map for SQLite
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'url': url,
      'prediction': prediction,
      'confidence': confidence,
      'malicious_probability': maliciousProbability,
      'safe_probability': safeProbability,
      'timestamp': timestamp.toIso8601String(),
    };
  }

  /// Create model from SQLite Map
  factory ScanResultModel.fromMap(Map<String, dynamic> map) {
    return ScanResultModel(
      id: map['id'] as int?,
      url: map['url'] as String,
      prediction: map['prediction'] as String,
      confidence: map['confidence'] as String?,
      maliciousProbability: map['malicious_probability'] as String?,
      safeProbability: map['safe_probability'] as String?,
      timestamp: DateTime.parse(map['timestamp'] as String),
    );
  }

  // ========== ENTITY CONVERSION ==========

  /// Convert model to entity
  ScanResult toEntity() {
    return ScanResult(
      id: id,
      url: url,
      prediction: prediction,
      confidence: confidence,
      maliciousProbability: maliciousProbability,
      safeProbability: safeProbability,
      timestamp: timestamp,
    );
  }

  /// Create model from entity
  factory ScanResultModel.fromEntity(ScanResult entity) {
    return ScanResultModel(
      id: entity.id,
      url: entity.url,
      prediction: entity.prediction,
      confidence: entity.confidence,
      maliciousProbability: entity.maliciousProbability,
      safeProbability: entity.safeProbability,
      timestamp: entity.timestamp,
    );
  }
}
