// User ka report request model
class BlockchainReportRequest {
  final String reportId;    // Report ka unique ID
  final String userId;      // Report submit karne wale user ka ID
  final String reportData;  // Actual report data

  BlockchainReportRequest({
    required this.reportId,
    required this.userId,
    required this.reportData,
  });

  // Convert object to JSON map
  Map<String, dynamic> toJson() {
    return {
      'reportId': reportId,
      'userId': userId,
      'reportData': reportData,
    };
  }
}
