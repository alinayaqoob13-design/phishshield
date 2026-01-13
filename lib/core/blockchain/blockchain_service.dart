import 'package:web3dart/web3dart.dart';
import 'package:http/http.dart';
import 'dart:convert';
import 'contract_abi.dart';

class BlockchainService {
  final String rpcUrl;
  final String privateKey;
  final String contractAddress;
  final String abi;

  late Web3Client _client;
  late EthPrivateKey _credentials;
  late DeployedContract _contract;
  late ContractFunction submitUrlFunction;

  BlockchainService({
    required this.rpcUrl,
    required this.privateKey,
    required this.contractAddress,
    required this.abi,
  }) {
    _client = Web3Client(rpcUrl, Client());
    _credentials = EthPrivateKey.fromHex(privateKey);
    _contract = DeployedContract(
      ContractAbi.fromJson(abi, "UrlScanner"),
      EthereumAddress.fromHex(contractAddress),
    );

    submitUrlFunction = _contract.function("submitUrl");
  }

  Future<String> submitUrl(String url) async {
    final result = await _client.sendTransaction(
      _credentials,
      Transaction.callContract(
        contract: _contract,
        function: submitUrlFunction,
        parameters: [url],
      ),
      chainId: 31337, // Hardhat local network chain ID
    );

    return result; // This is the transaction hash
  }
}
