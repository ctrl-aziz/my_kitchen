
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:my_kitchen/extensions/constants.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:my_kitchen/extensions/main_bottom_bar.dart';
import 'package:my_kitchen/models/user.dart';
import 'package:my_kitchen/services/auth.dart';
import 'package:provider/provider.dart';


import 'localizations/app_localizations.dart';



void main() {

  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool loading = true;

  @override
  void initState() {
    Firebase.initializeApp().whenComplete(() {
      setState(() {
        loading = false;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
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
      home: loading ? Scaffold(body: Center(child: Container(child: Text("أهلا بكم في مطبخي"),))) : StreamProvider<AppUser>.value(
        value: GoogleSignInProvider().user,
        child: CustomizedBottomBar(),
      ),
    );
  }
}

