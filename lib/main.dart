import 'package:demo_spotify_app/res/theme_data.dart';
import 'package:demo_spotify_app/view_models/artist_view_model.dart';
import 'package:demo_spotify_app/view_models/layout_screen_view_model.dart';
import 'package:demo_spotify_app/view_models/provider/dark_theme_provider.dart';
import 'package:demo_spotify_app/view_models/home_view_model.dart';
import 'package:demo_spotify_app/view_models/multi_control_player_view_model.dart';
import 'package:demo_spotify_app/view_models/search_view_model.dart';
import 'package:demo_spotify_app/view_models/track_play_view_model.dart';
import 'package:demo_spotify_app/views/layout_screen.dart';
import 'package:demo_spotify_app/views/login/login_screen.dart';
import 'package:demo_spotify_app/views/onboarding/onboarding_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:provider/provider.dart';

import 'utils/routes/route_name.dart';

Future<void> main() async {
  await JustAudioBackground.init(
    androidNotificationChannelId: 'com.ryanheise.bg_demo.channel.audio',
    androidNotificationChannelName: 'Audio playback',
    androidNotificationOngoing: true,
  );

  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  DarkThemeProvider themeChangeProvider = DarkThemeProvider();

  void getCurrentAppTheme() async {
    themeChangeProvider.darkTheme =
        await themeChangeProvider.darkThemePreferences.getTheme();
  }

  @override
  void initState() {
    super.initState();
    getCurrentAppTheme();
    setIsLoading();
  }

  bool isLoading = true;

  Future<void> setIsLoading() async {
    await Future.delayed(const Duration(seconds: 2));
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => themeChangeProvider),
        ChangeNotifierProvider(create: (_) => HomeViewModel()),
        ChangeNotifierProvider(create: (_) => TrackPlayViewModel()),
        ChangeNotifierProvider(create: (_) => ArtistViewModel()),
        ChangeNotifierProvider(create: (_) => MultiPlayerViewModel()),
        ChangeNotifierProvider(create: (_) => SearchViewModel()),
        //Sub provider
        ChangeNotifierProvider(create: (_) => LayoutScreenViewModel()),
      ],
      child: isLoading
          ? Center(
              child: SvgPicture.asset('assets/images/logo_spotify_label.svg'))
          : Consumer<DarkThemeProvider>(
              builder: (context, themeData, child) {
                return MaterialApp(
                  debugShowCheckedModeBanner: false,
                  title: 'Flutter Demo Spotify App',
                  theme:
                      Styles.themeData(themeChangeProvider.darkTheme, context),
                  initialRoute: RoutesName.main,
                  routes: {
                    RoutesName.main: (context) =>
                        const LayoutScreen(index: 0, screen: Placeholder()),
                    '/login': (context) => const LoginScreen(),
                    '/onboarding': (context) => const OnboardingScreen(),
                  },
                );
              },
            ),
    );
  }
}