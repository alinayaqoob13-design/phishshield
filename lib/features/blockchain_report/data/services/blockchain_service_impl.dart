import 'package:web3dart/web3dart.dart';
import 'package:http/http.dart';
import '../models/blockchain_report_request.dart';
import '../models/blockchain_report_response.dart';
import 'blockchain_service.dart';
import 'blockchain_config.dart'; // import your config

class BlockchainServiceImpl implements BlockchainService {
  late Web3Client _client;
  late Credentials _credentials;
  late EthereumAddress _ownAddress;

  BlockchainServiceImpl() {
    _client = Web3Client(rpcUrl, Client());
    _credentials = EthPrivateKey.fromHex(privateKey);
    _ownAddress = _credentials.address;
  }

  @override
  Future<BlockchainReportResponse> submitReport(BlockchainReportRequest report) async {
    try {
      final data = report.reportData;

      final contract = DeployedContract(
          ContractAbi.fromJson(urlScannerAbi, "UrlScanner"),
          EthereumAddress.fromHex(contractAddress));

      final submitFunction = contract.function("submitUrl");

      final txHash = await _client.sendTransaction(
        _credentials,
        Transaction.callContract(
          contract: contract,
          function: submitFunction,
          parameters: [data],
          maxGas: 200000,
        ),
        chainId: chainId,
      );

      return BlockchainReportResponse(
        success: true,
        message: "Report submitted successfully",
        transactionHash: txHash,
      );
    } catch (e) {
      return BlockchainReportResponse(
        success: false,
        message: e.toString(),
        transactionHash: null,
      );
    }
  }
}
