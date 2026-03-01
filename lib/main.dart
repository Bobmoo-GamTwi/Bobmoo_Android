import 'package:bobmoo/providers/search_provider.dart';
import 'package:bobmoo/ui/theme/app_colors.dart';
import 'package:bobmoo/constants/app_constants.dart';
import 'package:bobmoo/locator.dart';
import 'package:bobmoo/models/university.dart';
import 'package:bobmoo/providers/univ_provider.dart';
import 'package:bobmoo/screens/app_gate.dart';
import 'package:bobmoo/screens/home_screen.dart';
import 'package:bobmoo/screens/onboarding_screen.dart';
import 'package:bobmoo/screens/select_school_screen.dart';
import 'package:bobmoo/screens/settings_screen.dart';
import 'package:bobmoo/services/background_service.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:provider/provider.dart';
import 'package:workmanager/workmanager.dart';

void main() async {
  // Flutter 바인딩 초기화
  WidgetsFlutterBinding.ensureInitialized();

  // Firebase 초기화
  await Firebase.initializeApp();

  // 한국어 로케일데이터 추가
  await initializeDateFormatting('ko_KR', null);

  // 앱 실행 전에 GetIt 설정 실행
  await setupLocator();

  // Workmanager 설정
  Workmanager().initialize(callbackDispatcher);

  Workmanager().registerPeriodicTask(
    uniqueTaskName, // 작업의 고유한 이름
    fetchMealDataTask, // callbackDispatcher에서 식별할 작업 이름
    frequency: const Duration(hours: 6), // 실행 주기
    // 동일한 이름의 작업이 이미 있으면 유지하도록 설정
    existingWorkPolicy: ExistingPeriodicWorkPolicy.keep,
    constraints: Constraints(
      networkType: NetworkType.connected, // 네트워크가 연결되었을 때만 실행
    ),
  );

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => UnivProvider()..init(),
        ),
        ChangeNotifierProvider(
          create: (_) => SearchProvider()..init(),
        ),
      ],
      child: const BobMooApp(),
    ),
  );
}

class BobMooApp extends StatelessWidget {
  const BobMooApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(360, 800),
      minTextAdapt: true,
      builder: (context, child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          initialRoute: "/",
          onGenerateRoute: (settings) {
            final rawRouteName = settings.name;
            final isWidgetCallbackRoute = () {
              if (rawRouteName == null || rawRouteName.isEmpty) {
                return true;
              }
              if (rawRouteName.startsWith('/CALLBACK')) {
                return true;
              }

              final uri = Uri.tryParse(rawRouteName);
              if ((uri?.path ?? '').toUpperCase().startsWith('/CALLBACK')) {
                return true;
              }

              // Glance 위젯 액션(e.g. glance-action:/CALLBACK?...) fallback
              return rawRouteName.toUpperCase().contains(':/CALLBACK');
            }();
            final normalizedRouteName =
                isWidgetCallbackRoute ? "/" : rawRouteName;

            if (kDebugMode) {
              debugPrint(
                '[Router] onGenerateRoute raw=$rawRouteName, normalized=$normalizedRouteName, arguments=${settings.arguments}',
              );
            }
            switch (normalizedRouteName) {
              // 앱 시작점
              case "/":
                return MaterialPageRoute(
                  settings: settings,
                  builder: (_) => const AppGate(),
                );

              // 온보딩 화면 라우트
              case "/onboarding":
                return MaterialPageRoute(
                  settings: settings,
                  builder: (_) => const OnboardingScreen(),
                );

              // 학교 선택 화면 라우트
              case "/select_school":
                // 여기만 “반환 타입”을 명시
                final bool allowBack = settings.arguments as bool;
                return MaterialPageRoute<University?>(
                  settings: settings,
                  builder: (_) => SelectSchoolScreen(allowBack: allowBack),
                );

              // 홈화면 라우트
              case "/home":
                return MaterialPageRoute(
                  settings: settings,
                  builder: (_) => const HomeScreen(),
                );

              // 설정화면 라우트
              case "/settings":
                return MaterialPageRoute(
                  settings: settings,
                  builder: (_) => const SettingsScreen(),
                );

              // 잘못된 라우트 이름
              default:
                if (kDebugMode) {
                  debugPrint(
                    '[Router] Unknown route requested: $normalizedRouteName (raw: $rawRouteName)',
                  );
                }
                return MaterialPageRoute(
                  settings: settings,
                  builder: (_) => const Scaffold(
                    body: Center(child: Text("Unknown route")),
                  ),
                );
            }
          },
          title: '밥묵자',
          theme: _getThemeData(),
          locale: const Locale('ko', 'KR'), // 앱의 기본 언어를 한국어로 설정
          localizationsDelegates: const [
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: const [
            Locale('ko', 'KR'),
          ],
        );
      },
    );
  }

  // 테마 생성 로직
  ThemeData _getThemeData() {
    return ThemeData(
      fontFamily: 'Pretendard',

      // 배경색 설정
      scaffoldBackgroundColor: AppColors.colorGray4,

      colorScheme: ColorScheme.fromSeed(
        // [기본 설정]
        seedColor: AppColors.primaryNeutral,
        brightness: Brightness.light,

        // [표면/컴포넌트 컬러]
        // surface: 카드, 바텀시트, 다이얼로그의 기본 배경색
        surface: AppColors.colorWhite,
        onSurface: AppColors.colorBlack,

        // 색상 생성 알고리즘을 왜곡없이 그대로 사용
        dynamicSchemeVariant: DynamicSchemeVariant.fidelity,
      ),
      cardTheme: CardThemeData(
        color: Colors.white,
        surfaceTintColor: Colors.transparent,
        elevation: 2,
        shadowColor: Colors.black.withValues(alpha: 0.1),
      ),
      useMaterial3: true,
    );
  }
}
