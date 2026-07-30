import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'core/theme/app_theme.dart';
import 'features/home/home_screen.dart';
import 'features/onboarding/onboarding_screen.dart';
import 'services/storage_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Set system bar styling
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
    ),
  );

  final storage = await StorageService.getInstance();
  final profile = storage.getProfile();
  final bool hasProfile = profile.name.isNotEmpty && profile.name != 'Super Star';

  runApp(AIKidsAcademyApp(hasProfile: hasProfile));
}

class AIKidsAcademyApp extends StatefulWidget {
  final bool hasProfile;
  const AIKidsAcademyApp({super.key, required this.hasProfile});

  @override
  State<AIKidsAcademyApp> createState() => _AIKidsAcademyAppState();
}

class _AIKidsAcademyAppState extends State<AIKidsAcademyApp> {
  late bool _showHome;

  @override
  void initState() {
    super.initState();
    _showHome = widget.hasProfile;
  }

  void _onOnboardingFinished() {
    setState(() {
      _showHome = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'AI Kids Academy',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      home: _showHome
          ? const HomeScreen()
          : OnboardingScreen(onOnboardingComplete: _onOnboardingFinished),
    );
  }
}
