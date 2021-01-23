
import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:my_kitchen/extensions/constants.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:my_kitchen/extensions/main_bottom_bar.dart';
import 'package:my_kitchen/models/user.dart';
import 'package:my_kitchen/services/auth.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:showcaseview/showcaseview.dart';


import 'localizations/app_localizations.dart';



void main() async {
  print("startup");
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterError;
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
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
        scaffoldBackgroundColor: mBackgroundColor,
        primaryColor: mPrimaryColor,
        textTheme: Theme.of(context).textTheme.apply(bodyColor: mTextColor, fontFamily: "Cairo"),
        visualDensity: VisualDensity.adaptivePlatformDensity,
        canvasColor: Colors.transparent
      ),
      supportedLocales: [
        Locale('ar', ''),
        Locale('en', ''),
      ],
      localizationsDelegates: [
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
          if(supportedLocale.languageCode == locale.languageCode && supportedLocale.countryCode == locale.countryCode) {
            //print(supportedLocale);
            return supportedLocale;
          }
        }
        print(supportedLocales);
        return supportedLocales.first;
      },
      home: StreamProvider<AppUser>.value(
        value: GoogleSignInProvider().user,
        child: ShowCaseWidget(
          builder: Builder(builder: (_) => CustomizedBottomBar()),
      ),
      )
    );
  }
}

