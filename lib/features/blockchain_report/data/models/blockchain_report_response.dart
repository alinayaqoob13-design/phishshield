// Blockchain se response ka model
class BlockchainReportResponse {
  final bool success;             // Success ya failure
  final String message;           // Response message
  final String? transactionHash;  // Optional: Blockchain transaction ID

  BlockchainReportResponse({
    required this.success,
    required this.message,
    this.transactionHash,
  });

  // Convert JSON map to object
  factory BlockchainReportResponse.fromJson(Map<String, dynamic> json) {
    return BlockchainReportResponse(
      success: json['success'],
      message: json['message'],
      transactionHash: json['transactionHash'],
    );
  }
}
