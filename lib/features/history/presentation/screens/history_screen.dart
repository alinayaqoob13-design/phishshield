import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/constants/app_strings.dart';
import '../../../../../core/utils/validators.dart';
import '../../../../features/url_scanner/domain/entities/scan_result.dart';
import '../providers/history_provider.dart';
import '../../../url_scanner/presentation/providers/url_scanner_providers.dart';

class HistoryScreen extends ConsumerWidget {
  const HistoryScreen({super.key});

  void _showClearConfirmation(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        title: Row(
          children: [
            Container(
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppColors.dangerContainer,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(Icons.delete_sweep_rounded, color: AppColors.danger),
            ),
            SizedBox(width: 12),
            Text('Clear History?'),
          ],
        ),
        content: Text(
          'This will permanently delete all scan history. This action cannot be undone.',
          style: TextStyle(
            fontSize: 14,
            color: AppColors.textSecondary,
            height: 1.5,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              ref.read(historyProvider.notifier).clearHistory();
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Row(
                    children: [
                      Icon(Icons.check_circle, color: Colors.white),
                      SizedBox(width: 12),
                      Text(AppStrings.historyCleared),
                    ],
                  ),
                  backgroundColor: AppColors.success,
                  behavior: SnackBarBehavior.floating,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  margin: EdgeInsets.all(16),
                ),
              );
            },
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.danger),
            child: Text('Clear All'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final historyState = ref.watch(historyProvider);
    // Listen for URL scan changes and refresh history
    ref.listen(urlScanProvider, (previous, next) {
      if (next.result != null && previous?.result != next.result) {
        print('📱 URL scan detected, refreshing history...');
        Future.microtask(() {
          ref.read(historyProvider.notifier).refreshHistory();
        });
      }
    });
    return Scaffold(
      body: historyState.isLoading
          ? _buildLoadingState()
          : historyState.history.isEmpty
          ? _buildEmptyState()
          : CustomScrollView(
              slivers: [
                // Premium App Bar with Background Image
                SliverAppBar(
                  expandedHeight: 160,
                  floating: false,
                  pinned: true,
                  backgroundColor: AppColors.surface,
                  flexibleSpace: FlexibleSpaceBar(
                    centerTitle: false,
                    titlePadding: EdgeInsets.only(left: 20, bottom: 16),
                    title: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          padding: EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            gradient: AppColors.primaryGradient,
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [
                              BoxShadow(
                                color: AppColors.primary.withOpacity(0.4),
                                blurRadius: 12,
                                offset: Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Icon(
                            Icons.history_rounded,
                            color: Colors.white,
                            size: 22,
                          ),
                        ),
                        SizedBox(width: 12),
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              AppStrings.scanHistory,
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w800,
                                color: Colors.white,
                                letterSpacing: -0.5,
                                shadows: [
                                  Shadow(
                                    offset: Offset(0, 2),
                                    blurRadius: 4,
                                    color: Colors.black.withOpacity(0.3),
                                  ),
                                ],
                              ),
                            ),
                            Text(
                              'Your Security Timeline',
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                                color: Colors.white.withOpacity(0.9),
                                letterSpacing: 0.3,
                                shadows: [
                                  Shadow(
                                    offset: Offset(0, 1),
                                    blurRadius: 2,
                                    color: Colors.black.withOpacity(0.2),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    background: Stack(
                      children: [
                        // Background Image
                        Container(
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: AssetImage('assets/images/bg.png'),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),

                        // Overlay gradient for readability
                        Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                Colors.black.withOpacity(0.4),
                                Colors.black.withOpacity(0.3),
                              ],
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                            ),
                          ),
                        ),

                        // Additional top dark overlay for title safety
                        Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                Colors.black.withOpacity(0.5),
                                Colors.transparent,
                              ],
                              begin: Alignment.topCenter,
                              end: Alignment.center,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  actions: [
                    if (historyState.history.isNotEmpty)
                      Padding(
                        padding: EdgeInsets.only(right: 16),
                        child: IconButton(
                          icon: Icon(
                            Icons.delete_sweep_rounded,
                            color: Colors.white,
                          ),
                          onPressed: () => _showClearConfirmation(context, ref),
                          tooltip: AppStrings.clearHistory,
                        ),
                      ),
                  ],
                ),

                // Analytics Section
                SliverToBoxAdapter(
                  child: Padding(
                    padding: EdgeInsets.all(20),
                    child: Column(
                      children: [
                        _buildAnalyticsCards(historyState.history),
                        SizedBox(height: 20),
                        _buildThreatChart(historyState.history),
                        SizedBox(height: 20),
                      ],
                    ),
                  ),
                ),

                // History List
                SliverPadding(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  sliver: SliverList(
                    delegate: SliverChildBuilderDelegate((context, index) {
                      final item = historyState.history[index];
                      return _HistoryItemCard(result: item, index: index)
                          .animate()
                          .fadeIn(delay: (50 * index).ms)
                          .slideX(begin: 0.2, end: 0);
                    }, childCount: historyState.history.length),
                  ),
                ),

                SliverToBoxAdapter(child: SizedBox(height: 20)),
              ],
            ),
    );
  }

  Widget _buildLoadingState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            width: 60,
            height: 60,
            child: CircularProgressIndicator(
              strokeWidth: 4,
              valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
            ),
          ).animate(onPlay: (controller) => controller.repeat()).rotate(),
          SizedBox(height: 24),
          Text(
            'Loading history...',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(40),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: EdgeInsets.all(40),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    AppColors.primary.withOpacity(0.1),
                    AppColors.secondary.withOpacity(0.1),
                  ],
                ),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.history_rounded,
                size: 80,
                color: AppColors.primary,
              ),
            ).animate().fadeIn(duration: 600.ms).scale(begin: Offset(0.8, 0.8)),
            SizedBox(height: 32),
            Text(
              AppStrings.noHistoryYet,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary,
              ),
            ).animate().fadeIn(delay: 200.ms),
            SizedBox(height: 12),
            Text(
              'Start scanning URLs to build your history\nand view detailed analytics',
              style: TextStyle(
                fontSize: 15,
                color: AppColors.textSecondary,
                height: 1.5,
              ),
              textAlign: TextAlign.center,
            ).animate().fadeIn(delay: 300.ms),
          ],
        ),
      ),
    );
  }

  Widget _buildAnalyticsCards(List<ScanResult> history) {
    final safeCount = history.where((r) => r.isSafe).length;
    final maliciousCount = history.where((r) => r.isMalicious).length;
    final totalScans = history.length;

    return Row(
      children: [
        Expanded(
          child: _buildStatCard(
            icon: Icons.shield_outlined,
            label: 'Total Scans',
            value: totalScans.toString(),
            color: AppColors.primary,
            gradient: AppColors.primaryGradient,
          ),
        ),
        SizedBox(width: 12),
        Expanded(
          child: _buildStatCard(
            icon: Icons.check_circle_outline,
            label: 'Safe URLs',
            value: safeCount.toString(),
            color: AppColors.success,
            gradient: AppColors.successGradient,
          ),
        ),
        SizedBox(width: 12),
        Expanded(
          child: _buildStatCard(
            icon: Icons.warning_amber_rounded,
            label: 'Threats',
            value: maliciousCount.toString(),
            color: AppColors.danger,
            gradient: AppColors.dangerGradient,
          ),
        ),
      ],
    );
  }

  Widget _buildStatCard({
    required IconData icon,
    required String label,
    required String value,
    required Color color,
    required Gradient gradient,
  }) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withOpacity(0.2), width: 1.5),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.1),
            blurRadius: 12,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
              gradient: gradient,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: color.withOpacity(0.3),
                  blurRadius: 8,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: Icon(icon, color: Colors.white, size: 24),
          ),
          SizedBox(height: 12),
          Text(
            value,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w800,
              color: color,
            ),
          ),
          SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: AppColors.textSecondary,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildThreatChart(List<ScanResult> history) {
    final safeCount = history.where((r) => r.isSafe).length;
    final maliciousCount = history.where((r) => r.isMalicious).length;
    final total = history.length;

    if (total == 0) return SizedBox.shrink();

    return Container(
      padding: EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.border, width: 1.5),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadowLight,
            blurRadius: 16,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Security Overview',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary,
              ),
            ),
            SizedBox(height: 20),
            ConstrainedBox(
              constraints: BoxConstraints(minHeight: 220),
              child: Row(
                children: [
                  // Pie Chart - Constrained width
                  SizedBox(
                    width: 140,
                    height: 220,
                    child: AspectRatio(
                      aspectRatio: 1,
                      child: PieChart(
                        PieChartData(
                          sectionsSpace: 2,
                          centerSpaceRadius: 35,
                          sections: [
                            PieChartSectionData(
                              value: safeCount.toDouble(),
                              title:
                                  '${((safeCount / total) * 100).toStringAsFixed(0)}%',
                              color: AppColors.success,
                              radius: 45,
                              titleStyle: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w700,
                                color: Colors.white,
                              ),
                            ),
                            PieChartSectionData(
                              value: maliciousCount.toDouble(),
                              title:
                                  '${((maliciousCount / total) * 100).toStringAsFixed(0)}%',
                              color: AppColors.danger,
                              radius: 45,
                              titleStyle: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w700,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 20),
                  // Legend Data
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _buildLegendItem(
                          'Safe URLs',
                          safeCount,
                          total,
                          AppColors.success,
                        ),
                        SizedBox(height: 20),
                        _buildLegendItem(
                          'Threats Detected',
                          maliciousCount,
                          total,
                          AppColors.danger,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLegendItem(String label, int count, int total, Color color) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              width: 12,
              height: 12,
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(3),
              ),
            ),
            SizedBox(width: 8),
            Expanded(
              child: Text(
                label,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textSecondary,
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 8),
        Text(
          '$count URLs',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: color,
          ),
        ),
        SizedBox(height: 6),
        Container(
          height: 6,
          decoration: BoxDecoration(
            color: color.withOpacity(0.2),
            borderRadius: BorderRadius.circular(3),
          ),
          child: FractionallySizedBox(
            alignment: Alignment.centerLeft,
            widthFactor: count / total,
            child: Container(
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(3),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _HistoryItemCard extends StatelessWidget {
  final ScanResult result;
  final int index;

  const _HistoryItemCard({required this.result, required this.index});

  @override
  Widget build(BuildContext context) {
    final isMalicious = result.isMalicious;

    final Color statusColor = isMalicious
        ? AppColors.danger
        : AppColors.success;
    final Color bgColor = isMalicious
        ? AppColors.dangerContainer
        : AppColors.successContainer;

    final domain = Validators.extractDomain(result.url);
    final hasHttps = Validators.hasHttps(result.url);

    return Container(
      margin: EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: statusColor.withOpacity(0.2), width: 1.5),
        boxShadow: [
          BoxShadow(
            color: statusColor.withOpacity(0.1),
            blurRadius: 12,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => _showDetailsDialog(context),
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Row(
              children: [
                // Status Icon
                Container(
                  padding: EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    gradient: isMalicious
                        ? AppColors.dangerGradient
                        : AppColors.successGradient,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: statusColor.withOpacity(0.3),
                        blurRadius: 8,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Icon(
                    isMalicious
                        ? Icons.warning_rounded
                        : Icons.check_circle_rounded,
                    color: Colors.white,
                    size: 24,
                  ),
                ),

                SizedBox(width: 16),

                // URL Info
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          if (hasHttps)
                            Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 6,
                                vertical: 2,
                              ),
                              decoration: BoxDecoration(
                                color: AppColors.successContainer,
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    Icons.lock_rounded,
                                    size: 10,
                                    color: AppColors.success,
                                  ),
                                  SizedBox(width: 2),
                                  Text(
                                    'HTTPS',
                                    style: TextStyle(
                                      fontSize: 9,
                                      fontWeight: FontWeight.w700,
                                      color: AppColors.success,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          if (hasHttps) SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              domain,
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                                color: AppColors.textPrimary,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 6),
                      Row(
                        children: [
                          Icon(
                            Icons.access_time_rounded,
                            size: 12,
                            color: AppColors.textTertiary,
                          ),
                          SizedBox(width: 4),
                          Text(
                            _formatTimestamp(result.timestamp),
                            style: TextStyle(
                              fontSize: 12,
                              color: AppColors.textSecondary,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                SizedBox(width: 12),

                // Status Badge
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: bgColor,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: statusColor.withOpacity(0.3)),
                  ),
                  child: Text(
                    result.prediction,
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w800,
                      color: statusColor,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String _formatTimestamp(DateTime timestamp) {
    final now = DateTime.now();
    final difference = now.difference(timestamp);

    if (difference.inMinutes < 1) return 'Just now';
    if (difference.inHours < 1) return '${difference.inMinutes}m ago';
    if (difference.inDays < 1) return '${difference.inHours}h ago';
    if (difference.inDays < 7) return '${difference.inDays}d ago';
    return DateFormat('MMM d, y').format(timestamp);
  }

  void _showDetailsDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        child: Container(
          constraints: BoxConstraints(
            maxWidth: 400,
            maxHeight: MediaQuery.of(context).size.height * 0.85,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Header
              Container(
                padding: EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      AppColors.primary.withOpacity(0.1),
                      AppColors.secondary.withOpacity(0.1),
                    ],
                  ),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(24),
                    topRight: Radius.circular(24),
                  ),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        gradient: AppColors.primaryGradient,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(
                        Icons.info_rounded,
                        color: Colors.white,
                        size: 24,
                      ),
                    ),
                    SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'Scan Details',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                          color: AppColors.textPrimary,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // Content - Scrollable
              Expanded(
                child: SingleChildScrollView(
                  padding: EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildDetailRow('URL', result.url),
                      Divider(height: 24),
                      _buildDetailRow('Status', result.prediction),
                      if (result.confidence != null) ...[
                        Divider(height: 24),
                        _buildDetailRow('Confidence', result.confidence!),
                      ],
                      if (result.maliciousProbability != null) ...[
                        Divider(height: 24),
                        _buildDetailRow(
                          'Threat Level',
                          result.maliciousProbability!,
                        ),
                      ],
                      if (result.safeProbability != null) ...[
                        Divider(height: 24),
                        _buildDetailRow(
                          'Safety Level',
                          result.safeProbability!,
                        ),
                      ],
                      Divider(height: 24),
                      _buildDetailRow(
                        'Scanned',
                        DateFormat(
                          'MMM d, y - h:mm a',
                        ).format(result.timestamp),
                      ),
                    ],
                  ),
                ),
              ),

              // Actions
              Container(
                padding: EdgeInsets.fromLTRB(20, 12, 20, 20),
                decoration: BoxDecoration(
                  border: Border(
                    top: BorderSide(color: AppColors.border.withOpacity(0.5)),
                  ),
                ),
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text('Close'),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w700,
            color: AppColors.textSecondary,
            letterSpacing: 0.5,
          ),
        ),
        SizedBox(height: 6),
        Text(
          value,
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
      ],
    );
  }
}
