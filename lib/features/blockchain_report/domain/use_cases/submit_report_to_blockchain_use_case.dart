// Domain layer: Use Case for submitting a blockchain report

// Relative imports based on correct folder structure
import '../../data/models/blockchain_report_request.dart';
import '../../data/models/blockchain_report_response.dart';
import '../../data/services/blockchain_service.dart';

class SubmitReportToBlockchainUseCase {
  final BlockchainService service;

  SubmitReportToBlockchainUseCase(this.service);

  Future<BlockchainReportResponse> execute(BlockchainReportRequest report) {
    return service.submitReport(report);
  }
}
