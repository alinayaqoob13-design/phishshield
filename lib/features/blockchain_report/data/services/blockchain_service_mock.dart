import '../../domain/use_cases/submit_report_to_blockchain_use_case.dart';
import '../models/blockchain_report_request.dart';
import '../models/blockchain_report_response.dart';
import 'blockchain_service.dart';

/// Mock implementation of BlockchainService
class BlockchainServiceMock implements BlockchainService {
  @override
  Future<BlockchainReportResponse> submitReport(BlockchainReportRequest report) async {
    // Simulate network delay
    await Future.delayed(const Duration(seconds: 1));

    // Return a fake successful response
    return BlockchainReportResponse(
      success: true,
      message: 'Mock report submitted',
      transactionHash: '0xMOCKHASH123456',
    );
  }
}
