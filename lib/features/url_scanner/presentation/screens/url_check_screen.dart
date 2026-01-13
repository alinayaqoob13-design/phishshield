import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../blockchain_report/data/models/blockchain_report_request.dart';
import '../../../blockchain_report/presentation/providers/blockchain_report_provider.dart';
import '../../../../core/blockchain/blockchain_service.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/utils/validators.dart';
import '../../../../core/widgets/custom_button.dart';
import '../../../../core/widgets/custom_text_field.dart';
import '../providers/url_scanner_providers.dart';
import '../widgets/result_card.dart';
import '../widgets/security_tips_card.dart';

class UrlCheckScreen extends ConsumerStatefulWidget {
  const UrlCheckScreen({super.key});

  @override
  ConsumerState<UrlCheckScreen> createState() => _UrlCheckScreenState();
}

class _UrlCheckScreenState extends ConsumerState<UrlCheckScreen>
    with TickerProviderStateMixin {
  final TextEditingController _urlController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  late AnimationController _graphController;
  String? _lastCheckedUrl;

  @override
  void initState() {
    super.initState();
    _graphController = AnimationController(
      duration: Duration(milliseconds: 1500),
      vsync: this,
    );
  }

  @override
  void dispose() {
    _urlController.dispose();
    _graphController.dispose();
    super.dispose();
  }

  void _handleScan() {
    if (_formKey.currentState?.validate() ?? false) {
      // Store the URL for reporting
      _lastCheckedUrl = _urlController.text.trim();

      // Reset animation controller
      _graphController.reset();

      // Clear previous result and trigger new scan
      ref.read(urlScanProvider.notifier).checkUrl(_lastCheckedUrl!);

      // Start graph animation after scan completes
      Future.delayed(Duration(milliseconds: 500), () {
        if (mounted) {
          _graphController.forward(from: 0);
        }
      });
    }
  }

  void _showReportDialog() {
    if (_lastCheckedUrl == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              Icon(Icons.info_outline, color: Colors.white),
              SizedBox(width: 12),
              Expanded(child: Text('Check a URL first to report')),
            ],
          ),
          backgroundColor: AppColors.warning,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          margin: EdgeInsets.all(16),
        ),
      );
      return;
    }

    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header
            Container(
              padding: EdgeInsets.all(28),
              decoration: BoxDecoration(
                gradient: AppColors.dangerGradient.scale(0.2),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(28),
                  topRight: Radius.circular(28),
                ),
              ),
              child: Column(
                children: [
                  Container(
                    padding: EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      gradient: AppColors.dangerGradient,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.danger.withOpacity(0.4),
                          blurRadius: 20,
                          offset: Offset(0, 8),
                        ),
                      ],
                    ),
                    child: Icon(
                      Icons.flag_rounded,
                      size: 40,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 16),
                  Text(
                    'Report Malicious URL',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w800,
                      color: AppColors.danger,
                    ),
                  ),
                ],
              ),
            ),

            // Content
            Padding(
              padding: EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppColors.surfaceVariant,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: AppColors.border),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.link_rounded,
                              size: 20,
                              color: AppColors.danger,
                            ),
                            SizedBox(width: 8),
                            Text(
                              'URL to Report',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w700,
                                color: AppColors.textSecondary,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 8),
                        Text(
                          _lastCheckedUrl!,
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: AppColors.textPrimary,
                          ),
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 16),
                  Text(
                    'This will help protect other users from potential threats. The URL will be recorded for future blockchain integration.',
                    style: TextStyle(
                      fontSize: 13,
                      color: AppColors.textSecondary,
                      height: 1.5,
                    ),
                  ),
                ],
              ),
            ),

            // Actions
            Padding(
              padding: EdgeInsets.fromLTRB(24, 0, 24, 24),
              child: Row(
                children: [
                  Expanded(
                    child: TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: Text('Cancel'),
                    ),
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.danger,
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                        // TODO: Implement blockchain reporting in future
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Row(
                              children: [
                                Icon(Icons.check_circle, color: Colors.white),
                                SizedBox(width: 12),
                                Expanded(
                                  child: Text('URL reported successfully'),
                                ),
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
                      child: Text('Report'),
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

  @override
  Widget build(BuildContext context) {
    final scanState = ref.watch(urlScanProvider);

    ref.listen(urlScanProvider, (previous, next) {
      if (next.error != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                Icon(Icons.error_outline, color: Colors.white),
                SizedBox(width: 12),
                Expanded(child: Text(next.error!)),
              ],
            ),
            backgroundColor: AppColors.danger,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            margin: EdgeInsets.all(16),
          ),
        );
      }
    });

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // Professional App Bar with Background Image and Report Button
          SliverAppBar(
            expandedHeight: 160,
            floating: false,
            pinned: true,
            stretch: true,
            backgroundColor: AppColors.surface,
            elevation: 0,
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
                      Icons.security_rounded,
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
                        AppStrings.appName,
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
                        'Real-time URL Protection',
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
              Padding(
                padding: EdgeInsets.only(right: 16),
                child: Tooltip(
                  message: 'Report URL',
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          AppColors.danger.withOpacity(0.25),
                          AppColors.danger.withOpacity(0.15),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: IconButton(
                      icon: Icon(Icons.flag_rounded, color: Colors.white),
                      onPressed: _showReportDialog,
                      padding: EdgeInsets.all(10),
                      constraints: BoxConstraints(minWidth: 48, minHeight: 48),
                    ),
                  ),
                ),
              ),
            ],
          ),

          // Content
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Main Scan Card with Background
                    _buildScanCard(scanState)
                        .animate()
                        .fadeIn(delay: 100.ms)
                        .slideY(begin: 0.2, end: 0),

                    SizedBox(height: 24),

                    // Result Display with Dynamic Graph
                    if (scanState.result != null) ...[
                      ResultCard(result: scanState.result!)
                          .animate()
                          .fadeIn(delay: 200.ms)
                          .scale(begin: Offset(0.95, 0.95)),
                      SizedBox(height: 24),

                      // Dynamic Graph based on result
                      _buildDynamicGraph(scanState.result!)
                          .animate()
                          .fadeIn(delay: 400.ms)
                          .slideY(begin: 0.2, end: 0),
                      SizedBox(height: 24),
                    ],

                    // Loading State - Always show when scanning
                    if (scanState.isLoading) _buildLoadingCard(),

                    // Security Tips (only show when no result)
                    if (!scanState.isLoading && scanState.result == null)
                      SecurityTipsCard()
                          .animate()
                          .fadeIn(delay: 500.ms)
                          .slideY(begin: 0.2, end: 0),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildScanCard(scanState) {
    return Container(
      padding: EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.primary.withOpacity(0.08),
            AppColors.secondary.withOpacity(0.08),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: AppColors.primary.withOpacity(0.2),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadowPrimary.withOpacity(0.1),
            blurRadius: 20,
            offset: Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Icon and Title
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(14),
                decoration: BoxDecoration(
                  gradient: AppColors.primaryGradient,
                  borderRadius: BorderRadius.circular(14),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primary.withOpacity(0.3),
                      blurRadius: 12,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
                child: Icon(
                  Icons.security_rounded,
                  size: 28,
                  color: Colors.white,
                ),
              ),
              SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      AppStrings.protectYourself,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimary,
                        letterSpacing: -0.3,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      AppStrings.scanDescription,
                      style: TextStyle(
                        fontSize: 13,
                        color: AppColors.textSecondary,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          SizedBox(height: 24),

          // URL Input
          CustomTextField(
            controller: _urlController,
            labelText: AppStrings.enterUrl,
            hintText: AppStrings.urlHint,
            prefixIcon: Icons.link_rounded,
            suffixIcon: _urlController.text.isNotEmpty
                ? Icons.clear_rounded
                : null,
            onSuffixIconTap: () {
              _urlController.clear();
              setState(() {});
            },
            validator: Validators.validateUrl,
            onSubmitted: (_) => _handleScan(),
            onChanged: (_) => setState(() {}),
            keyboardType: TextInputType.url,
          ),

          SizedBox(height: 16),

          // Scan Button
          CustomButton(
            text: AppStrings.scanUrl,
            icon: Icons.search_rounded,
            onPressed: _handleScan,
            isLoading: scanState.isLoading,
          ),
          SizedBox(height: 12),

          if (_lastCheckedUrl != null && scanState.result != null)
            CustomButton(
              text: "Submit to Blockchain",
              icon: Icons.upload_rounded,
              onPressed: () async {
                final blockchainProviderInstance = ref.read(blockchainReportProvider);

                if (!blockchainProviderInstance.isLoading) {
                  // Submit the URL directly to blockchain provider
                  await blockchainProviderInstance.submitReport(_lastCheckedUrl!);

                  final response = blockchainProviderInstance.response;

                  if (response != null && response.success) {
                    showDialog(
                      context: context,
                      builder: (_) => AlertDialog(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18),
                        ),
                        title: Text(
                          "Submitted Successfully",
                          style: TextStyle(fontWeight: FontWeight.w800),
                        ),
                        content: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.check_circle, color: AppColors.success, size: 40),
                            SizedBox(height: 12),
                            Text(
                              "Transaction Hash:",
                              style: TextStyle(fontWeight: FontWeight.w700),
                            ),
                            SizedBox(height: 6),
                            SelectableText(
                              response.transactionHash ?? "N/A",
                              style: TextStyle(
                                fontSize: 13,
                                color: AppColors.textSecondary,
                              ),
                            ),
                          ],
                        ),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: Text("OK"),
                          )
                        ],
                      ),
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Row(
                          children: [
                            Icon(Icons.error_outline, color: Colors.white),
                            SizedBox(width: 12),
                            Expanded(child: Text(response?.message ?? "Unknown error")),
                          ],
                        ),
                        backgroundColor: AppColors.danger,
                        behavior: SnackBarBehavior.floating,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        margin: EdgeInsets.all(16),
                      ),
                    );
                  }
                }
              },
            ),        ],
      ),
    );
  }

  Widget _buildDynamicGraph(result) {
    // Parse probabilities
    final maliciousProb =
        double.tryParse(
          result.maliciousProbability?.replaceAll('%', '') ?? '0',
        ) ??
        0.0;
    final safeProb =
        double.tryParse(result.safeProbability?.replaceAll('%', '') ?? '0') ??
        0.0;

    final isMalicious = result.isMalicious;
    final Color primaryColor = isMalicious
        ? AppColors.danger
        : result.isSafe
        ? AppColors.success
        : AppColors.warning;

    return Container(
      padding: EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: primaryColor.withOpacity(0.3), width: 1.5),
        boxShadow: [
          BoxShadow(
            color: primaryColor.withOpacity(0.1),
            blurRadius: 20,
            offset: Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [primaryColor, primaryColor.withOpacity(0.7)],
                  ),
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: primaryColor.withOpacity(0.3),
                      blurRadius: 8,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                child: Icon(
                  Icons.analytics_rounded,
                  color: Colors.white,
                  size: 24,
                ),
              ),
              SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Threat Analysis',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    Text(
                      'Probability Distribution',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          SizedBox(height: 32),

          // Animated Bar Chart
          SizedBox(
            height: 220,
            child: AnimatedBuilder(
              animation: _graphController,
              builder: (context, child) {
                return BarChart(
                  BarChartData(
                    alignment: BarChartAlignment.spaceAround,
                    maxY: 100,
                    barTouchData: BarTouchData(enabled: false),
                    titlesData: FlTitlesData(
                      show: true,
                      bottomTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          getTitlesWidget: (value, meta) {
                            const titles = ['Safe', 'Malicious'];
                            final title = value.toInt() < titles.length
                                ? titles[value.toInt()]
                                : '';
                            return Padding(
                              padding: EdgeInsets.only(top: 8),
                              child: Text(
                                title,
                                style: TextStyle(
                                  color: AppColors.textSecondary,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 13,
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                      leftTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          reservedSize: 40,
                          getTitlesWidget: (value, meta) {
                            return Text(
                              '${value.toInt()}%',
                              style: TextStyle(
                                color: AppColors.textSecondary,
                                fontWeight: FontWeight.w500,
                                fontSize: 11,
                              ),
                            );
                          },
                        ),
                      ),
                      topTitles: AxisTitles(
                        sideTitles: SideTitles(showTitles: false),
                      ),
                      rightTitles: AxisTitles(
                        sideTitles: SideTitles(showTitles: false),
                      ),
                    ),
                    gridData: FlGridData(
                      show: true,
                      drawVerticalLine: false,
                      horizontalInterval: 25,
                      getDrawingHorizontalLine: (value) {
                        return FlLine(
                          color: AppColors.border.withOpacity(0.5),
                          strokeWidth: 1,
                          dashArray: [5, 5],
                        );
                      },
                    ),
                    borderData: FlBorderData(show: false),
                    barGroups: [
                      BarChartGroupData(
                        x: 0,
                        barRods: [
                          BarChartRodData(
                            toY: safeProb * _graphController.value,
                            gradient: LinearGradient(
                              colors: [
                                AppColors.success,
                                AppColors.success.withOpacity(0.7),
                              ],
                              begin: Alignment.bottomCenter,
                              end: Alignment.topCenter,
                            ),
                            width: 40,
                            borderRadius: BorderRadius.vertical(
                              top: Radius.circular(8),
                            ),
                            backDrawRodData: BackgroundBarChartRodData(
                              show: true,
                              toY: 100,
                              color: AppColors.success.withOpacity(0.1),
                            ),
                          ),
                        ],
                      ),
                      BarChartGroupData(
                        x: 1,
                        barRods: [
                          BarChartRodData(
                            toY: maliciousProb * _graphController.value,
                            gradient: LinearGradient(
                              colors: [
                                AppColors.danger,
                                AppColors.danger.withOpacity(0.7),
                              ],
                              begin: Alignment.bottomCenter,
                              end: Alignment.topCenter,
                            ),
                            width: 40,
                            borderRadius: BorderRadius.vertical(
                              top: Radius.circular(8),
                            ),
                            backDrawRodData: BackgroundBarChartRodData(
                              show: true,
                              toY: 100,
                              color: AppColors.danger.withOpacity(0.1),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              },
            ),
          ),

          SizedBox(height: 24),

          // Stats Summary
          Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: primaryColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: primaryColor.withOpacity(0.3)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildStatItem(
                  'Safe',
                  '${safeProb.toStringAsFixed(1)}%',
                  AppColors.success,
                  Icons.check_circle_rounded,
                ),
                Container(width: 1, height: 40, color: AppColors.border),
                _buildStatItem(
                  'Threat',
                  '${maliciousProb.toStringAsFixed(1)}%',
                  AppColors.danger,
                  Icons.warning_rounded,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(
    String label,
    String value,
    Color color,
    IconData icon,
  ) {
    return Column(
      children: [
        Icon(icon, color: color, size: 24),
        SizedBox(height: 8),
        Text(
          value,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w900,
            color: color,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: AppColors.textSecondary,
          ),
        ),
      ],
    );
  }

  Widget _buildLoadingCard() {
    return Container(
      padding: EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.border),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadowLight,
            blurRadius: 16,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Stack(
            alignment: Alignment.center,
            children: [
              SizedBox(
                    width: 80,
                    height: 80,
                    child: CircularProgressIndicator(
                      strokeWidth: 4,
                      valueColor: AlwaysStoppedAnimation<Color>(
                        AppColors.primary,
                      ),
                    ),
                  )
                  .animate(onPlay: (controller) => controller.repeat())
                  .rotate(duration: 2000.ms),
              Icon(Icons.shield_outlined, size: 36, color: AppColors.primary),
            ],
          ),
          SizedBox(height: 24),
          Text(
            AppStrings.scanning,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
            ),
          ),
          SizedBox(height: 8),
          Text(
            'Analyzing URL for threats...',
            style: TextStyle(
              fontSize: 14,
              color: AppColors.textSecondary,
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: 20),
          _buildLoadingProgress(),
        ],
      ),
    ).animate().fadeIn().scale();
  }

  Widget _buildLoadingProgress() {
    return Column(
      children: [
        _buildProgressStep('Checking SSL Certificate', true),
        SizedBox(height: 8),
        _buildProgressStep('Analyzing URL Structure', true),
        SizedBox(height: 8),
        _buildProgressStep('Scanning for Threats', false),
      ],
    );
  }

  Widget _buildProgressStep(String text, bool completed) {
    return Row(
      children: [
        Icon(
          completed ? Icons.check_circle : Icons.pending,
          size: 16,
          color: completed ? AppColors.success : AppColors.textTertiary,
        ),
        SizedBox(width: 8),
        Text(
          text,
          style: TextStyle(
            fontSize: 13,
            color: completed ? AppColors.textPrimary : AppColors.textSecondary,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    ).animate().fadeIn(delay: (completed ? 0 : 500).ms);
  }
}
