// Blockchain operations ke interface (abstract class)
import '../models/blockchain_report_request.dart';
import '../models/blockchain_report_response.dart';

abstract class BlockchainService {
  Future<BlockchainReportResponse> submitReport(BlockchainReportRequest report);
}
