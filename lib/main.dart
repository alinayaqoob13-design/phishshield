import 'package:device_preview/device_preview.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:provider/provider.dart'; // For ChangeNotifier if needed
import 'package:flutter_riverpod/flutter_riverpod.dart' as rp;
import 'core/constants/app_colors.dart';
import 'core/constants/app_strings.dart';
import 'package:phishshield/core/database/database_provider.dart';
import 'core/constants/app_theme.dart';
import 'core/services/service_locator.dart';
import 'features/url_scanner/presentation/providers/url_scanner_providers.dart';
import 'features/url_scanner/presentation/screens/url_check_screen.dart';
import 'features/qr_scanner/presentation/screens/qr_scanner_screen.dart';
import 'features/history/presentation/screens/history_screen.dart';
import 'features/splash/presentation/splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize SQLite Database
  final database = await openDatabase(
    join(await getDatabasesPath(), 'url_scanner.db'),
    onCreate: (db, version) async {
      await db.execute('''
        CREATE TABLE scan_history(
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          url TEXT NOT NULL,
          prediction TEXT NOT NULL,
          confidence TEXT,
          malicious_probability TEXT,
          safe_probability TEXT,
          timestamp TEXT NOT NULL
        )
      ''');
    },
    version: 1,
  );

  // Set system UI overlay style
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
      systemNavigationBarColor: AppColors.primary,
      systemNavigationBarIconBrightness: Brightness.light,
    ),
  );

  // Set preferred orientations
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  runApp(
    ProviderScope(
      overrides: [
        databaseProvider.overrideWithValue(database), // ← now unambiguous
      ],
      child: DevicePreview(
        enabled: false,
        builder: (context) => const PhishShieldApp(),
      ),
    ),
  );
}

class PhishShieldApp extends StatelessWidget {
  const PhishShieldApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: AppStrings.appName,
      debugShowCheckedModeBanner: false,
      theme: AppTheme.darkTheme,
      home: const SplashWrapper(),
    );
  }
}

class SplashWrapper extends StatefulWidget {
  const SplashWrapper({super.key});

  @override
  State<SplashWrapper> createState() => _SplashWrapperState();
}

class _SplashWrapperState extends State<SplashWrapper> {
  bool _showSplash = true;

  void _onSplashComplete() {
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
        systemNavigationBarColor: AppColors.surface,
        systemNavigationBarIconBrightness: Brightness.dark,
      ),
    );

    setState(() {
      _showSplash = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_showSplash) {
      return SplashScreen(onAnimationComplete: _onSplashComplete);
    }
    return const HomeScreen();
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  int _currentIndex = 0;
  late AnimationController _fabController;

  final List<Widget> _screens = const [
    UrlCheckScreen(),
    QrScannerScreen(),
    HistoryScreen(),
  ];

  final List<NavigationItem> _navigationItems = const [
    NavigationItem(
      icon: Icons.link_rounded,
      label: AppStrings.urlCheck,
      activeIcon: Icons.link_rounded,
    ),
    NavigationItem(
      icon: Icons.qr_code_scanner_rounded,
      label: AppStrings.qrScanner,
      activeIcon: Icons.qr_code_scanner,
    ),
    NavigationItem(
      icon: Icons.history_rounded,
      label: AppStrings.history,
      activeIcon: Icons.history,
    ),
  ];

  @override
  void initState() {
    super.initState();
    _fabController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _fabController.forward();
  }

  @override
  void dispose() {
    _fabController.dispose();
    super.dispose();
  }

  void _onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
    _fabController.reset();
    _fabController.forward();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(index: _currentIndex, children: _screens),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: AppColors.shadowMedium,
              blurRadius: 20,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(24),
            topRight: Radius.circular(24),
          ),
          child: BottomNavigationBar(
            currentIndex: _currentIndex,
            onTap: _onTabTapped,
            backgroundColor: AppColors.surface,
            selectedItemColor: AppColors.primary,
            unselectedItemColor: AppColors.textTertiary,
            selectedLabelStyle: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.1,
            ),
            unselectedLabelStyle: const TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
            ),
            type: BottomNavigationBarType.fixed,
            elevation: 0,
            items: _navigationItems.asMap().entries.map((entry) {
              final index = entry.key;
              final item = entry.value;
              final isSelected = _currentIndex == index;

              return BottomNavigationBarItem(
                icon: AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  padding: EdgeInsets.all(isSelected ? 8 : 4),
                  margin: const EdgeInsets.only(bottom: 4),
                  decoration: BoxDecoration(
                    gradient: isSelected ? AppColors.primaryGradient : null,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: isSelected
                        ? [
                      BoxShadow(
                        color: AppColors.primary.withOpacity(0.3),
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      ),
                    ]
                        : null,
                  ),
                  child: Icon(
                    isSelected ? item.activeIcon : item.icon,
                    color: isSelected ? Colors.white : AppColors.textTertiary,
                    size: isSelected ? 26 : 24,
                  ),
                ),
                label: item.label,
              );
            }).toList(),
          ),
        ),
      ),
    );
  }
}

class NavigationItem {
  final IconData icon;
  final IconData activeIcon;
  final String label;

  const NavigationItem({
    required this.icon,
    required this.label,
    IconData? activeIcon,
  }) : activeIcon = activeIcon ?? icon;
}
