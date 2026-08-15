import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:device_preview/device_preview.dart';
import 'l10n/app_localizations.dart';
import 'screens/splash_screen.dart';
import 'screens/home_screen.dart';
import 'screens/history_screen.dart';
import 'screens/settings_screen.dart';
import 'screens/onboarding/onboarding_flow.dart';
import 'models/ad_service.dart';

const _onboardingCompleteKey = 'onboarding_complete';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  // Không await: khởi tạo AdMob chạy song song trong lúc splash hiện lên,
  // không trì hoãn khung hình đầu tiên của app.
  AdService.initialize();
  runApp(
    DevicePreview(
      enabled: false,
      builder: (context) => const MortgageApp(),
    ),
  );
}

class MortgageApp extends StatefulWidget {
  const MortgageApp({super.key});

  static MortgageAppState? of(BuildContext context) =>
      context.findAncestorStateOfType<MortgageAppState>();

  @override
  State<MortgageApp> createState() => MortgageAppState();
}

class MortgageAppState extends State<MortgageApp> {
  Locale _locale = const Locale('vi');

  @override
  void initState() {
    super.initState();
    _loadLocale();
  }

  Future<void> _loadLocale() async {
    final prefs = await SharedPreferences.getInstance();
    final code = prefs.getString('locale') ?? 'vi';
    setState(() => _locale = Locale(code));
  }

  Future<void> setLocale(Locale locale) async {
    setState(() => _locale = locale);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('locale', locale.languageCode);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'LoanBuddy',
      debugShowCheckedModeBanner: false,
      locale: _locale,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('vi'),
        Locale('en'),
      ],
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFFE8A020),
          brightness: Brightness.light,
        ),
        scaffoldBackgroundColor: const Color(0xFFF5F0E8),
        useMaterial3: true,
      ),
      home: const AppRoot(),
    );
  }
}

/// Quyết định hiện Onboarding (lần đầu mở app) hay vào luồng bình thường
/// (SplashScreen -> MainScreen) nếu user đã xem onboarding rồi.
class AppRoot extends StatefulWidget {
  const AppRoot({super.key});

  @override
  State<AppRoot> createState() => _AppRootState();
}

class _AppRootState extends State<AppRoot> {
  bool? _onboardingComplete;

  @override
  void initState() {
    super.initState();
    _checkOnboardingStatus();
  }

  Future<void> _checkOnboardingStatus() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _onboardingComplete = prefs.getBool(_onboardingCompleteKey) ?? false;
    });
  }

  Future<void> _completeOnboarding() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_onboardingCompleteKey, true);
    // Xin quyền App Tracking Transparency ngay sau khi user hoàn tất
    // Onboarding (chỉ có tác dụng trên iOS, Android tự bỏ qua).
    await AdService.requestTrackingAuthorization();
    if (!mounted) return;
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => const SplashScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_onboardingComplete == null) {
      return const Scaffold(body: SizedBox.shrink());
    }
    if (_onboardingComplete == false) {
      return OnboardingFlow(onFinished: _completeOnboarding);
    }
    return const SplashScreen();
  }
}

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});
  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  static const _gold = Color(0xFFE8A020);
  static const _darkGreen = Color(0xFF1B4332);

  int _currentIndex = 0;

  final List<Widget> _screens = [
    const HomeScreen(),
    HistoryScreen(key: HistoryScreen.globalKey),
    const SettingsScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _screens,
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: _darkGreen,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.15),
              blurRadius: 12,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: SafeArea(
          top: false,
          child: SizedBox(
            height: 64,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _navItem(0, Icons.home_outlined, Icons.home_rounded, l.navHome),
                _navItem(1, Icons.history_outlined, Icons.history_rounded, l.navHistory),
                _navItem(2, Icons.settings_outlined, Icons.settings_rounded, l.navSettings),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _navItem(int index, IconData icon, IconData activeIcon, String label) {
    final isSelected = _currentIndex == index;
    final color = isSelected ? _gold : Colors.white.withOpacity(0.65);
    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() => _currentIndex = index);
          if (index == 1) {
            HistoryScreen.globalKey.currentState?.refresh();
          }
        },
        behavior: HitTestBehavior.opaque,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(isSelected ? activeIcon : icon, color: color, size: 22),
            const SizedBox(height: 3),
            Text(
              label,
              style: TextStyle(
                fontSize: 10,
                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
