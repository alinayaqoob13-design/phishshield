import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:permission_handler/permission_handler.dart';

// Your app core files
import '../../../../../../core/constants/app_colors.dart';
import '../../../../../../core/constants/app_strings.dart';
import '../../../../../../core/widgets/custom_button.dart';

// QR scanner files
import '../providers/qr_scanner_providers.dart';
import '../../data/models/qr_scan_state.dart';

// IMPORTANT — Correct blockchain imports
import 'package:phishshield/features/blockchain_report/presentation/providers/blockchain_report_provider.dart';
import 'package:phishshield/features/blockchain_report/data/models/blockchain_report_request.dart';


class QrScannerScreen extends ConsumerStatefulWidget {
  const QrScannerScreen({super.key});

  @override
  ConsumerState<QrScannerScreen> createState() => _QrScannerScreenState();
}

class _QrScannerScreenState extends ConsumerState<QrScannerScreen>
    with SingleTickerProviderStateMixin {
  MobileScannerController? _cameraController;
  bool _permissionGranted = false;
  late AnimationController _scanLineController;
  String? _lastScannedUrl;

  @override
  void initState() {
    super.initState();
    _scanLineController = AnimationController(
      vsync: this,
      duration: Duration(seconds: 2),
    )..repeat(reverse: true);
    _requestCameraPermission();
  }

  Future<void> _requestCameraPermission() async {
    final status = await Permission.camera.request();
    setState(() {
      _permissionGranted = status.isGranted;
    });

    if (_permissionGranted) {
      _cameraController = MobileScannerController(
        formats: [BarcodeFormat.qrCode],
        detectionSpeed: DetectionSpeed.noDuplicates,
      );
    }
  }

  @override
  void dispose() {
    _cameraController?.dispose();
    _scanLineController.dispose();
    super.dispose();
  }

  void _onDetect(BarcodeCapture capture) {
    final scanState = ref.read(qrScanProvider);
    if (!scanState.isScanning) return;

    final List<Barcode> barcodes = capture.barcodes;
    for (final barcode in barcodes) {
      if (barcode.rawValue != null) {
        _lastScannedUrl = barcode.rawValue!;
        ref.read(qrScanProvider.notifier).processScannedUrl(barcode.rawValue!);
        break;
      }
    }
  }

  void _showReportDialog() {
    if (_lastScannedUrl == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              Icon(Icons.info_outline, color: Colors.white),
              SizedBox(width: 12),
              Expanded(child: Text('Scan a QR code first to report')),
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
            // Header & Content same as before
            // ...

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
                    child: Consumer(
                      builder: (context, ref, _) {
                        final scanState = ref.watch(qrScanProvider);
                        return ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.danger,
                          ),
                          onPressed: scanState.isProcessing
                              ? null
                              : () async {
                            try {
                              await ref
                                  .read(qrScanProvider.notifier)
                                  .submitToBlockchain();

                              Navigator.pop(context);
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Row(
                                    children: [
                                      Icon(Icons.check_circle,
                                          color: Colors.white),
                                      SizedBox(width: 12),
                                      Expanded(
                                        child: Text(
                                            'URL reported to blockchain successfully'),
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
                            } catch (e) {
                              Navigator.pop(context);
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Row(
                                    children: [
                                      Icon(Icons.error_outline,
                                          color: Colors.white),
                                      SizedBox(width: 12),
                                      Expanded(
                                        child: Text(
                                            'Failed to report URL: $e'),
                                      ),
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
                          },
                          child: scanState.isProcessing
                              ? SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                              : Text('Report'),
                        );
                      },
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



  void _showResultDialog() {
    final scanState = ref.read(qrScanProvider);
    if (scanState.result == null) return;

    final result = scanState.result!;
    final isMalicious = result.isMalicious;
    final statusColor = isMalicious ? AppColors.danger : AppColors.success;
    final gradient = isMalicious
        ? AppColors.dangerGradient
        : AppColors.successGradient;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header with gradient
            Container(
              padding: EdgeInsets.all(28),
              decoration: BoxDecoration(
                gradient: gradient.scale(0.2),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(28),
                  topRight: Radius.circular(28),
                ),
              ),
              child: Column(
                children: [
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      Container(
                            width: 100,
                            height: 100,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: statusColor.withOpacity(0.2),
                            ),
                          )
                          .animate(onPlay: (c) => c.repeat())
                          .scale(
                            duration: 2000.ms,
                            begin: Offset(0.8, 0.8),
                            end: Offset(1.2, 1.2),
                          )
                          .fade(begin: 0.5, end: 0),
                      Container(
                        width: 90,
                        height: 90,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: gradient,
                          boxShadow: [
                            BoxShadow(
                              color: statusColor.withOpacity(0.4),
                              blurRadius: 20,
                              offset: Offset(0, 8),
                            ),
                          ],
                        ),
                        child: Icon(
                          isMalicious
                              ? Icons.warning_rounded
                              : Icons.verified_user_rounded,
                          size: 48,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  Text(
                    isMalicious ? AppStrings.warning : AppStrings.safe,
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.w800,
                      color: statusColor,
                      letterSpacing: -0.5,
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
                  _buildInfoRow(Icons.link_rounded, 'URL', result.url),
                  SizedBox(height: 16),
                  _buildInfoRow(
                    Icons.analytics_rounded,
                    'Status',
                    result.prediction,
                    valueColor: statusColor,
                  ),
                  if (result.confidence != null) ...[
                    SizedBox(height: 16),
                    _buildInfoRow(
                      Icons.insights_rounded,
                      'Confidence',
                      result.confidence!,
                      valueColor: statusColor,
                    ),
                  ],
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
                      onPressed: () {
                        Navigator.pop(context);
                        ref.read(qrScanProvider.notifier).resumeScanning();
                      },
                      child: Text(AppStrings.scanAgain),
                    ),
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                        ref.read(qrScanProvider.notifier).resetScanner();
                      },
                      child: Text(AppStrings.close),
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

  Widget _buildInfoRow(
    IconData icon,
    String label,
    String value, {
    Color? valueColor,
  }) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surfaceVariant,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: (valueColor ?? AppColors.primary).withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, size: 20, color: valueColor ?? AppColors.primary),
          ),
          SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textSecondary,
                    letterSpacing: 0.5,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: valueColor ?? AppColors.textPrimary,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final scanState = ref.watch(qrScanProvider);

    ref.listen<QrScanState>(qrScanProvider, (previous, next) {
      if (next.result != null && previous?.result != next.result) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          _showResultDialog();
        });
      }

      if (next.error != null && next.error!.isNotEmpty) {
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

    if (!_permissionGranted) {
      return Scaffold(
        body: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                AppColors.primary.withOpacity(0.05),
                AppColors.secondary.withOpacity(0.05),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: SafeArea(
            child: Padding(
              padding: EdgeInsets.all(32),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: EdgeInsets.all(40),
                    decoration: BoxDecoration(
                      gradient: AppColors.primaryGradient,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.primary.withOpacity(0.3),
                          blurRadius: 24,
                          offset: Offset(0, 8),
                        ),
                      ],
                    ),
                    child: Icon(
                      Icons.camera_alt_outlined,
                      size: 80,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 32),
                  Text(
                    AppStrings.cameraPermissionRequired,
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 16),
                  Text(
                    'Please grant camera permission to scan QR codes and protect yourself from phishing attacks',
                    style: TextStyle(
                      fontSize: 15,
                      color: AppColors.textSecondary,
                      height: 1.5,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 40),
                  CustomButton(
                    text: 'Grant Permission',
                    icon: Icons.camera_alt_rounded,
                    onPressed: _requestCameraPermission,
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // Camera
          if (_cameraController != null)
            MobileScanner(controller: _cameraController!, onDetect: _onDetect),

          // Top Bar - Clean Professional Design
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.black, Colors.black.withOpacity(0.7)],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
              child: SafeArea(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    // Report Button
                    _buildTopButton(
                      Icons.flag_rounded,
                      _showReportDialog,
                      tooltip: 'Report',
                    ),
                    // Camera Switch
                    _buildTopButton(
                      Icons.flip_camera_ios_rounded,
                      () => _cameraController?.switchCamera(),
                      tooltip: 'Switch',
                    ),
                    // Flash Toggle
                    _buildTopButton(
                      scanState.isScanning
                          ? Icons.flash_on_rounded
                          : Icons.flash_off_rounded,
                      () => _cameraController?.toggleTorch(),
                      tooltip: 'Flash',
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Scanning Overlay
          Center(
            child: Stack(
              alignment: Alignment.center,
              children: [
                Container(
                  width: 280,
                  height: 280,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(
                      color: scanState.isScanning
                          ? AppColors.primary
                          : Colors.white.withOpacity(0.5),
                      width: 3,
                    ),
                  ),
                  child: CustomPaint(
                    painter: CornersPainter(
                      color: scanState.isScanning
                          ? AppColors.primary
                          : Colors.white.withOpacity(0.5),
                    ),
                  ),
                ),
                // Animated scan line
                if (scanState.isScanning)
                  SizedBox(
                    width: 260,
                    height: 260,
                    child: AnimatedBuilder(
                      animation: _scanLineController,
                      builder: (context, child) {
                        return CustomPaint(
                          painter: ScanLinePainter(
                            animation: _scanLineController.value,
                          ),
                        );
                      },
                    ),
                  ),
              ],
            ),
          ),

          // Processing Overlay
          if (scanState.isProcessing)
            Container(
              color: Colors.black.withOpacity(0.8),
              child: Center(
                child: Container(
                  padding: EdgeInsets.all(32),
                  margin: EdgeInsets.all(40),
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(24),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(
                            width: 60,
                            height: 60,
                            child: CircularProgressIndicator(
                              strokeWidth: 4,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                AppColors.primary,
                              ),
                            ),
                          )
                          .animate(onPlay: (c) => c.repeat())
                          .rotate(duration: 2000.ms),
                      SizedBox(height: 24),
                      Text(
                        AppStrings.processing,
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        'Analyzing QR code for threats...',
                        style: TextStyle(
                          fontSize: 14,
                          color: AppColors.textSecondary,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),
            ),

          // Bottom Instructions - Reduced Height
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.black.withOpacity(0.7), Colors.black],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
              child: SafeArea(
                child: Container(
                  padding: EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          gradient: AppColors.primaryGradient,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Icon(
                          Icons.qr_code_scanner_rounded,
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
                              scanState.isScanning
                                  ? AppStrings.positionQr
                                  : AppStrings.processing,
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w700,
                                color: Colors.white,
                              ),
                            ),
                            SizedBox(height: 2),
                            Text(
                              AppStrings.scanningForThreats,
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.white.withOpacity(0.6),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTopButton(
    IconData icon,
    VoidCallback onPressed, {
    String? tooltip,
  }) {
    return Tooltip(
      message: tooltip ?? '',
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              AppColors.primary.withOpacity(0.25),
              AppColors.primary.withOpacity(0.15),
            ],
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        child: IconButton(
          icon: Icon(icon, color: Colors.white, size: 22),
          onPressed: onPressed,
          padding: EdgeInsets.all(10),
          constraints: BoxConstraints(minWidth: 48, minHeight: 48),
        ),
      ),
    );
  }
}

// Custom painter for corner brackets
class CornersPainter extends CustomPainter {
  final Color color;

  CornersPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 6
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    const cornerLength = 35.0;

    // Top-left
    canvas.drawLine(Offset(0, cornerLength), Offset(0, 0), paint);
    canvas.drawLine(Offset(0, 0), Offset(cornerLength, 0), paint);

    // Top-right
    canvas.drawLine(
      Offset(size.width - cornerLength, 0),
      Offset(size.width, 0),
      paint,
    );
    canvas.drawLine(
      Offset(size.width, 0),
      Offset(size.width, cornerLength),
      paint,
    );

    // Bottom-left
    canvas.drawLine(
      Offset(0, size.height - cornerLength),
      Offset(0, size.height),
      paint,
    );
    canvas.drawLine(
      Offset(0, size.height),
      Offset(cornerLength, size.height),
      paint,
    );

    // Bottom-right
    canvas.drawLine(
      Offset(size.width - cornerLength, size.height),
      Offset(size.width, size.height),
      paint,
    );
    canvas.drawLine(
      Offset(size.width, size.height - cornerLength),
      Offset(size.width, size.height),
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// Custom painter for scan line
class ScanLinePainter extends CustomPainter {
  final double animation;

  ScanLinePainter({required this.animation});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..shader = LinearGradient(
        colors: [Colors.transparent, AppColors.primary, Colors.transparent],
      ).createShader(Rect.fromLTWH(0, 0, size.width, 3))
      ..strokeWidth = 3;

    final y = size.height * animation;
    canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
