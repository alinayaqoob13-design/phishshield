import 'package:equatable/equatable.dart';

class ScanResult extends Equatable {
  final int? id; // SQLite primary key
  final String url;
  final String prediction;
  final String? confidence;
  final String? maliciousProbability;
  final String? safeProbability;
  final DateTime timestamp;

  const ScanResult({
    this.id,
    required this.url,
    required this.prediction,
    this.confidence,
    this.maliciousProbability,
    this.safeProbability,
    required this.timestamp,
  });

  @override
  List<Object?> get props => [
    id,
    url,
    prediction,
    confidence,
    maliciousProbability,
    safeProbability,
    timestamp,
  ];

  // Helper method to check if URL is safe
  bool get isSafe => prediction.toLowerCase() == 'safe';

  // Helper method to check if URL is malicious
  bool get isMalicious => prediction.toLowerCase() == 'malicious';
}
