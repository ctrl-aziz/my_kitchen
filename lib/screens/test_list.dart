import 'package:flutter/material.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_admob/firebase_admob.dart';
import 'package:my_kitchen/extensions/constants.dart';

// class StorageExampleApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Container(),
//     );
//   }
// }
// Copyright 2017 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

// ignore_for_file: public_member_api_docs



// You can also test with your own ad unit IDs by registering your device as a
// test device. Check the logs for your device's ID value.
const String testDevice = 'YOUR_DEVICE_ID';

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  static const MobileAdTargetingInfo targetingInfo = MobileAdTargetingInfo(
    testDevices: testDevice != null ? <String>[testDevice] : null,
    keywords: <String>['foo', 'bar'],
    contentUrl: 'http://foo.com/bar.html',
    childDirected: true,
    nonPersonalizedAds: true,
  );


  InterstitialAd _interstitialAd;

  InterstitialAd createInterstitialAd() {
    return InterstitialAd(
      adUnitId: InterstitialAd.testAdUnitId,
      targetingInfo: targetingInfo,
      listener: (MobileAdEvent event) {
        print("InterstitialAd event $event");
      },
    );
  }

  @override
  void initState() {
    WidgetsFlutterBinding.ensureInitialized();
    Firebase.initializeApp().whenComplete(() => print("complite ads"));

    super.initState();
    FirebaseAdMob.instance.initialize(appId: FirebaseAdMob.testAppId);
    _interstitialAd = createInterstitialAd()..load();
  }

  @override
  void dispose() {
    _interstitialAd?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: InkWell(
        child: Container(
          width: 100.0,
          height: 100.0,
          alignment: Alignment.center,
          margin: EdgeInsets.all(10.0),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(200.0),
              image: DecorationImage(
                  image: NetworkImage("https://upload.wikimedia.org/wikipedia/commons/0/07/ADS-Logo_RGB.png"),
                  fit: BoxFit.cover
              )
          ),
          child: Container(
              width: 100,
              height: 100,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: Color.fromRGBO(255, 100, 100, 0.3),
                borderRadius: BorderRadius.circular(200.0),
              ),
              child: Text("أعلان", style: Theme.of(context).textTheme.subtitle2.copyWith(color: mWhiteColor, fontWeight: FontWeight.bold), textAlign: TextAlign.center,)
          ),
        ),
        onTap: (){
          _interstitialAd = createInterstitialAd()..load();
          _interstitialAd.show();
        },
      ),
    );
  }
}


