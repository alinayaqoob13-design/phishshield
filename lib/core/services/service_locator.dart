// service_locator.dart

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import '../../features/blockchain_report/presentation/providers/blockchain_report_provider.dart';

/// Provider for BlockchainService
final blockchainServiceProvider = Provider<BlockchainService>((ref) {
  return BlockchainService(); // Uses dynamic config from blockchain_config.dart
});

/// ChangeNotifierProvider for BlockchainReportProvider
final blockchainReportProvider =
ChangeNotifierProvider<BlockchainReportProvider>((ref) {
  final service = ref.watch(blockchainServiceProvider);
  return BlockchainReportProvider(service: service);
});
