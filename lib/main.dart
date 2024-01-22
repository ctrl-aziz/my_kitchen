import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:provider/provider.dart';
import 'package:showcaseview/showcaseview.dart';


import 'extensions/constants.dart';
import 'extensions/main_bottom_bar.dart';
import 'firebase_options.dart';
import 'localizations/app_localizations.dart';
import 'models/user.dart';
import 'services/auth.dart';


void main() async {
  debugPrint("startup");
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  MobileAds.instance.initialize();
  FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterError;
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: false,
        scaffoldBackgroundColor: mBackgroundColor,
        primaryColor: mPrimaryColor,
        textTheme: Theme.of(context).textTheme.apply(bodyColor: mTextColor, fontFamily: "Cairo"),
        visualDensity: VisualDensity.adaptivePlatformDensity,
        canvasColor: Colors.transparent,
      ),
      supportedLocales: const [
        Locale('ar', ''),
        Locale('en', ''),
      ],
      localizationsDelegates: const [
        // ... app-specific localization delegate[s] here
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      localeResolutionCallback: (locale, supportedLocales){
        // print(locale.languageCode);
        // print(supportedLocales);
        for(var supportedLocale in supportedLocales){
          // TODO Activate this when app complete
          // If you want to country code you can add this condition && supportedLocale.countryCode == locale.countryCode
          if(supportedLocale.languageCode == locale?.languageCode && supportedLocale.countryCode == locale?.countryCode) {
            //print(supportedLocale);
            return supportedLocale;
          }
        }
        debugPrint(supportedLocales.toString());
        return supportedLocales.first;
      },
      home: StreamProvider<AppUser?>.value(
        initialData: GoogleSignInProvider().appUser,
        value: GoogleSignInProvider().user,
        child: ShowCaseWidget(
          builder: Builder(builder: (_) => const CustomizedBottomBar()),
      ),
      )
    );
  }
}

