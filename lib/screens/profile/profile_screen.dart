import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:my_kitchen/extensions/constants.dart';
import 'package:my_kitchen/localizations/app_localizations.dart';
import 'package:my_kitchen/models/user.dart';
import 'package:my_kitchen/services/auth.dart';
import 'package:provider/provider.dart';

import 'components/favorite_with_followers.dart';
import 'components/photo_with_name.dart';

class ProfileScreen extends StatefulWidget {

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    AppLocalizations translate = AppLocalizations.of(context);
    final _user = Provider.of<AppUser>(context);
    if (_user == null)
      return Scaffold(
          appBar: AppBar(
            title: Center(widthFactor: 2.2,
                child: Text("${translate.translate("Profile")}", style: TextStyle(
                    fontFamily: "Cairo", fontWeight: FontWeight.bold))),
          ),
          body: Stack(
              children: [
                Column(
                  children: [
                    SizedBox(height: MediaQuery
                        .of(context)
                        .size
                        .height * 0.02,),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Hero(
                          child: Container(
                            width: 110,
                            height: 110,
                            decoration: BoxDecoration(
                              color: mPrimaryColor,
                              borderRadius: BorderRadius.circular(50.0),
                            ),
                          ),
                          tag: "userImage",
                        ),
                        Text("الأسم",),
                      ],
                    ),
                    Column(
                      children: [
                        Center(
                          child: ToggleButtons(
                            children: [
                              Text("المفضلة",
                                style: TextStyle(fontFamily: "Cairo"),),
                              Text(
                                "المتابعين",
                                style: TextStyle(fontFamily: "Cairo"),),
                            ],
                            isSelected: [true, false],
                            borderRadius: BorderRadius.circular(9.0),
                            constraints: BoxConstraints(
                                minWidth: 135.0,
                                minHeight: 35.0,
                                maxHeight: 65.0,
                                maxWidth: 200.0
                            ),
                            onPressed: (value) {},
                          ),
                        ),
                        SizedBox(height: 3.0,),
                        Container(
                            width: 274,
                            height: 320,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.all(
                                  Radius.circular(9.0)),
                              color: Colors.white,
                            ),
                            child: ListView.builder(
                              itemCount: 5,
                                itemBuilder: (context, index) {
                                  return ListTile(
                                    title: Text(
                                      "الاسم",
                                      style: TextStyle(fontFamily: "Cairo"),),
                                    subtitle: Text("عدد الوصفات 5",
                                      style: TextStyle(fontFamily: "Cairo"),),
                                    leading: Container(
                                      width: 60,
                                      height: 60,
                                      decoration: BoxDecoration(
                                          color: mPrimaryColor,
                                          borderRadius: BorderRadius.circular(
                                              200.0),
                                      ),
                                      child: Icon(Icons.image),
                                    ),
                                    hoverColor: Colors.blue,
                                    autofocus: true,
                                  );
                                })
                        ),
                      ],
                    ),
                  ],
                ),
                BackdropFilter(
                  filter: ImageFilter.blur(
                      sigmaX: 5,
                      sigmaY: 5
                  ),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.5),
                    ),
                  ),
                ),
                Positioned(
                  top: MediaQuery
                      .of(context)
                      .size
                      .height / 3,
                  right: MediaQuery
                      .of(context)
                      .size
                      .width / 4.4,
                  child: Column(
                    children: [
                      Text("${translate.translate("Please login to show content")}", style: Theme
                          .of(context)
                          .textTheme
                          .subtitle2
                          .copyWith(color: Colors.white),),
                      RaisedButton(
                        child: Text("${translate.translate("Login Now")}"),
                        onPressed: () {
                          GoogleSignInProvider().login();
                        },
                      )
                    ],
                  ),
                ),

              ]
          )
      );

    return Scaffold(
      appBar: AppBar(
        title: Center(widthFactor: 2.2,
            child: Text("${translate.translate("Profile")}", style: TextStyle(
                fontFamily: "Cairo", fontWeight: FontWeight.bold))),
        actions: [
          IconButton(icon: Icon(Icons.power_settings_new), onPressed: (){
            GoogleSignInProvider().logout();
          },)
        ],
      ),
      body: Column(
        children: [
          SizedBox(height: 21.0,),
          PhotoWithName(),
          //UserTrafficData(),
          SizedBox(height: 10.0,),
          Container(
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(topRight: Radius.circular(20.0), topLeft: Radius.circular(20.0))
              ),
              child: Text("${translate.translate("Favorites")}", textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.bold),)),
          FavoriteWithFollowers(),
        ],
      ),
    );
  }
}

