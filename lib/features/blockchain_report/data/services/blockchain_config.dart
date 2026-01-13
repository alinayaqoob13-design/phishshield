
const String rpcUrl = "http://192.168.100.50:8545/"; // your node RPC
const String privateKey = "0xdf57089febbacf7ba0bc227dafbffa9fc08a93fdc68e1e42411a14efcf23656e"; // your wallet
const String contractAddress = "0x5fbdb2315678afecb367f032d93f642f64180aa3"; // deployed contract
const int chainId = 31337; // Hardhat local network

const String urlScannerAbi = '''
[
  {
    "anonymous": false,
    "inputs": [
      { "indexed": false, "internalType": "string", "name": "url", "type": "string" }
    ],
    "name": "UrlSubmitted",
    "type": "event"
  },
  {
    "inputs": [
      { "internalType": "string", "name": "url", "type": "string" }
    ],
    "name": "submitUrl",
    "outputs": [],
    "stateMutability": "nonpayable",
    "type": "function"
  }
]
''';
