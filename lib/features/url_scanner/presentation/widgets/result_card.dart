import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../../../../core/constants/app_colors.dart';
import '../../../../../../core/constants/app_strings.dart';
import '../../domain/entities/scan_result.dart';

class ResultCard extends StatelessWidget {
  final ScanResult result;

  const ResultCard({super.key, required this.result});

  @override
  Widget build(BuildContext context) {
    final isMalicious = result.isMalicious;
    final isSafe = result.isSafe;

    final Color primaryColor = isMalicious
        ? AppColors.danger
        : isSafe
        ? AppColors.success
        : AppColors.warning;

    // Dark theme compatible background colors
    final Color bgColor = isMalicious
        ? AppColors.danger.withOpacity(0.15)
        : isSafe
        ? AppColors.success.withOpacity(0.15)
        : AppColors.warning.withOpacity(0.15);

    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: BorderSide(color: primaryColor.withOpacity(0.3), width: 2),
      ),
      color: bgColor,
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            // Icon with animation
            Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: primaryColor.withOpacity(0.2),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    isMalicious
                        ? Icons.warning_amber_rounded
                        : isSafe
                        ? Icons.check_circle_rounded
                        : Icons.info_rounded,
                    size: 56,
                    color: primaryColor,
                  ),
                )
                .animate()
                .scale(duration: 500.ms, curve: Curves.elasticOut)
                .fadeIn(),

            const SizedBox(height: 20),

            // Status Text
            Text(
              result.prediction,
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.w700,
                color: primaryColor,
                letterSpacing: -0.5,
              ),
            ).animate().fadeIn(delay: 100.ms).slideY(begin: 0.3, end: 0),

            const SizedBox(height: 12),

            // Confidence Badge
            if (result.confidence != null) ...[
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: primaryColor.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: primaryColor.withOpacity(0.3)),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.analytics_rounded,
                      size: 18,
                      color: primaryColor,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      '${AppStrings.confidence}: ${result.confidence}',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: primaryColor,
                      ),
                    ),
                  ],
                ),
              ).animate().fadeIn(delay: 200.ms).scale(),
              const SizedBox(height: 20),
            ],

            // Divider
            Divider(color: primaryColor.withOpacity(0.3), thickness: 1),
            const SizedBox(height: 20),

            // Probabilities
            if (result.maliciousProbability != null &&
                result.safeProbability != null) ...[
              _buildProbabilityRow(
                AppStrings.maliciousProbability,
                result.maliciousProbability!,
                AppColors.danger,
              ).animate().fadeIn(delay: 300.ms).slideX(begin: -0.3, end: 0),
              const SizedBox(height: 12),
              _buildProbabilityRow(
                AppStrings.safeProbability,
                result.safeProbability!,
                AppColors.success,
              ).animate().fadeIn(delay: 400.ms).slideX(begin: -0.3, end: 0),
              const SizedBox(height: 20),
            ],

            // Warning/Safe Message
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: primaryColor.withOpacity(0.15),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: primaryColor.withOpacity(0.3)),
              ),
              child: Row(
                children: [
                  Icon(
                    isMalicious
                        ? Icons.shield_rounded
                        : isSafe
                        ? Icons.verified_user_rounded
                        : Icons.help_outline_rounded,
                    color: primaryColor,
                    size: 24,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      isMalicious
                          ? AppStrings.doNotVisit
                          : isSafe
                          ? AppStrings.urlAppearsSafe
                          : AppStrings.suspiciousUrl,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary,
                        height: 1.5,
                      ),
                    ),
                  ),
                ],
              ),
            ).animate().fadeIn(delay: 500.ms).slideY(begin: 0.3, end: 0),
          ],
        ),
      ),
    );
  }

  Widget _buildProbabilityRow(String label, String value, Color color) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Container(
              width: 8,
              height: 8,
              decoration: BoxDecoration(color: color, shape: BoxShape.circle),
            ),
            const SizedBox(width: 8),
            Text(
              label,
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w500,
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
          decoration: BoxDecoration(
            color: color.withOpacity(0.2),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: color.withOpacity(0.4)),
          ),
          child: Text(
            value,
            style: TextStyle(
              fontWeight: FontWeight.w700,
              fontSize: 15,
              color: color,
            ),
          ),
        ),
      ],
    );
  }
}
