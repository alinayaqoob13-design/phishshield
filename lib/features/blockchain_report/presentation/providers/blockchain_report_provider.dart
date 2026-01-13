// blockchain_report_provider.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:web3dart/web3dart.dart';
import 'package:http/http.dart';

// Import the dynamic config
import '../../data/services/blockchain_config.dart';

/// Blockchain service class to interact with smart contract
class BlockchainService {
  late final Web3Client _client;
  late final DeployedContract _contract;
  late final Credentials _credentials;
  late final EthereumAddress _contractEthereumAddress;

  BlockchainService() {
    _client = Web3Client(rpcUrl, Client());
    _credentials = EthPrivateKey.fromHex(privateKey);
    _contractEthereumAddress = EthereumAddress.fromHex(contractAddress);
    _contract = DeployedContract(
      ContractAbi.fromJson(urlScannerAbi, "UrlScanner"),
      _contractEthereumAddress,
    );
  }

  /// Submit URL to the smart contract
  Future<String> submitUrl(String url) async {
    final submitFunction = _contract.function('submitUrl');

    final txHash = await _client.sendTransaction(
      _credentials,
      Transaction.callContract(
        contract: _contract,
        function: submitFunction,
        parameters: [url],
        maxGas: 100000,
      ),
      chainId: chainId,
    );

    return txHash;
  }
}

/// Response model for blockchain submission
class BlockchainReportResponse {
  final bool success;
  final String message;
  final String? transactionHash;

  BlockchainReportResponse({
    required this.success,
    required this.message,
    this.transactionHash,
  });
}

/// Provider for BlockchainService
final blockchainServiceProvider = Provider<BlockchainService>((ref) {
  return BlockchainService();
});

/// ChangeNotifierProvider for submitting URLs
final blockchainReportProvider =
ChangeNotifierProvider<BlockchainReportProvider>((ref) {
  final service = ref.watch(blockchainServiceProvider);
  return BlockchainReportProvider(service: service);
});

class BlockchainReportProvider extends ChangeNotifier {
  final BlockchainService service;

  bool isLoading = false;
  BlockchainReportResponse? response;

  BlockchainReportProvider({required this.service});

  /// Submit URL to blockchain
  Future<void> submitReport(String url) async {
    isLoading = true;
    notifyListeners();

    try {
      final txHash = await service.submitUrl(url);

      response = BlockchainReportResponse(
        success: true,
        message: "Submitted Successfully",
        transactionHash: txHash,
      );
    } catch (e) {
      response = BlockchainReportResponse(
        success: false,
        message: e.toString(),
        transactionHash: null,
      );
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
