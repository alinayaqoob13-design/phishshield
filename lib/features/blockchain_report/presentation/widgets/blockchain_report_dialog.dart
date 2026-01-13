import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/blockchain_report_provider.dart';

class BlockchainReportDialog extends StatelessWidget {
  final String reportId;
  final String userId;
  final String reportData;

  const BlockchainReportDialog({
    super.key,
    required this.reportId,
    required this.userId,
    required this.reportData,
  });

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<BlockchainReportProvider>(context, listen: true);

    return AlertDialog(
      title: const Text('Submit Report to Blockchain'),
      content: provider.isLoading
          ? const SizedBox(
        height: 100,
        child: Center(child: CircularProgressIndicator()),
      )
          : Text(provider.response?.message ?? 'Do you want to submit the report?'),
      actions: [
        TextButton(
          onPressed: () async {
            if (!provider.isLoading) {
              await provider.submitReport(
               reportData
              );
            }
          },
          child: const Text('Submit'),
        ),
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Close'),
        ),
      ],
    );
  }
}
