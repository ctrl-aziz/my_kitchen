import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:my_kitchen/extensions/constants.dart';
import 'package:my_kitchen/extensions/data.dart';
import 'package:my_kitchen/localizations/app_localizations.dart';
import 'package:my_kitchen/models/foods.dart';
import 'package:my_kitchen/models/user.dart';
import 'package:my_kitchen/services/auth.dart';
import 'package:my_kitchen/services/database/foods_database.dart';
import 'package:my_kitchen/services/database/user_database.dart';
import 'package:provider/provider.dart';

import 'add_food.dart';
import 'components/upload_image_helper.dart';


class MyKitchenScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MyKitchenScreenH();
  }
}

class MyKitchenScreenH extends StatefulWidget {

  @override
  _MyKitchenScreenStateH createState() => _MyKitchenScreenStateH();
}

class _MyKitchenScreenStateH extends State<MyKitchenScreenH> {

  @override
  Widget build(BuildContext context) {
    final _user = Provider.of<AppUser>(context);
    AppLocalizations translate = AppLocalizations.of(context);

    if (_user == null)
      return Scaffold(
          appBar: AppBar(
            title: Align(
              alignment: Alignment.center,
              child: Text("${translate.translate("My Kitchen")}", style: TextStyle(
                  fontFamily: "Cairo", fontWeight: FontWeight.bold),),
            ),
          ),
          body: Stack(
              children: [
                ListView.builder(
                    itemCount: 6,
                    itemBuilder: (context, index) {
                      return Card(
                        elevation: 4.0,
                        margin: EdgeInsets.symmetric(
                            horizontal: mDefaultPadding*1.5, vertical: mDefaultPadding*0.25),
                        child: Container(
                          height: 80.0,
                          child: Row(
                            children: [
                              Stack(
                                children: [
                                  Container(
                                    width: 80.0,
                                    height: 80.0,
                                    decoration: BoxDecoration(
                                      color: mPrimaryColor.withOpacity(0.5),
                                    ),
                                    child: Icon(Icons.image),
                                  ),
                                  Container(
                                    color: mPrimaryColor.withOpacity(0.2),
                                  )
                                ],
                              ),
                              SizedBox(width: 20,),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment
                                    .spaceEvenly,
                                children: [
                                  Text("اسم الطعام", style: Theme
                                      .of(context)
                                      .textTheme
                                      .headline6
                                      .copyWith(),),
                                  Text("المطابخ: السوري, العراقي",
                                    style: TextStyle(fontSize: 11.0),),
                                  Text("لقد حصل على 5 اعجاب",
                                    style: TextStyle(fontSize: 11.0),),
                                ],
                              )
                            ],
                          ),
                        ),
                      );
                    }
                ),
                BackdropFilter(
                  filter: ImageFilter.blur(
                      sigmaX: 5,
                      sigmaY: 5
                  ),
                  child: Container(
                    decoration: BoxDecoration(
                      color: mTextColor.withOpacity(0.5),
                    ),
                  ),
                ),
                Positioned(
                  top: MediaQuery.of(context)
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
                          .copyWith(color: mWhiteColor),),
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
        title: Align(
          alignment: Alignment.center,
          child: Text("${translate.translate("My Kitchen")}", style: TextStyle(fontFamily: "Cairo", fontWeight: FontWeight.bold),),
        )
      ),
      body: StreamBuilder<UserData>(
          stream: UserDatabaseService(uid: _user.uid).userData,
          builder: (context, snapshot) {
            if (!snapshot.hasData) return Align(alignment: Alignment.center, child: CircularProgressIndicator());
            return Stack(
              children: [
                Positioned(
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: mDefaultPadding*3, top: mDefaultPadding*2),
                    child: ListView.builder(
                        scrollDirection: Axis.vertical,
                        physics: BouncingScrollPhysics(),
                        itemCount: snapshot.data.foods.length,
                        itemBuilder: (context, index) {
                          return StreamBuilder<FoodsData>(
                              stream: FoodDatabaseService(fid: snapshot.data.foods[index]).foodData,
                              builder: (context, foodSnapshot) {
                                if (!foodSnapshot.hasData) return Align(alignment: Alignment.center, child:  CircularProgressIndicator(),);
                                String currentKitchens = "";
                                for (var country in foodSnapshot.data.country) {
                                  if (currentKitchens
                                      .split(" ")
                                      .length <= 2) {
                                    currentKitchens += translate.translate("${countries[country]}").toString() + ", ";
                                  } else {
                                    currentKitchens += ".";
                                  }
                                }
                                return GestureDetector(
                                    child: ListTile(
                                      leading: Container(
                                          width: 80.0,
                                          height: 80.0,
                                          decoration: BoxDecoration(
                                              color: mPrimaryColor.withOpacity(0.5),
                                              image: DecorationImage(
                                                  image: NetworkImage(foodSnapshot.data.image),
                                                  fit: BoxFit.cover
                                              )
                                          ),
                                          child: Container(
                                            color: mPrimaryColor.withOpacity(0.2),
                                          )
                                      ),
                                      title: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                        children: [
                                          Text(foodSnapshot.data.name ?? "", style: TextStyle(
                                              fontSize: 17.0, fontWeight: FontWeight.bold),),
                                          Text("${translate.translate("Kitchens")}: $currentKitchens",
                                            style: TextStyle(fontSize: 11.0),),
                                          Text("${translate.translate("It has")} ${foodSnapshot.data.like.length} ${translate.translate("Likes")}",
                                            style: TextStyle(fontSize: 11.0),),
                                        ],
                                      ),
                                      trailing: IconButton(
                                        icon: Icon(Icons.clear),
                                        onPressed: () async{
                                          _showMyDialog(uid: snapshot.data.uid, fid: foodSnapshot.data.infid, imagePath: foodSnapshot.data.image);
                                        },
                                      ),
                                    ),
                                    onLongPress: (){
                                  setState(() {

                                  });
                                },
                                onTap: () {
                                Navigator.push(context, MaterialPageRoute(builder: (context) => AddFood(position: foodSnapshot.data.fid,)));
                                print(index);
                                },
                                );
                              }
                          );
                        }
                    ),
                  ),
                ),
                Positioned(
                    child: InkWell(
                      child: Padding(
                        padding: const EdgeInsets.all(mDefaultPadding*0.4),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text("${translate.translate("Add new food")}", style: Theme
                                .of(context)
                                .textTheme
                                .subtitle1,),
                            Icon(Icons.add, color: mTextColor,),
                          ],
                        ),
                      ),
                      onTap: () {
                        Navigator.push(context, MaterialPageRoute(
                            builder: (context) => AddFood()
                        )
                        );
                        print("pressed");
                      },
                    )
                ),
              ],
            );
          }
      ),
    );
  }

  Future<void> _showMyDialog({@required String uid,@required String fid, @required String imagePath}) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('تأكيد الحذف'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('هل أنت متأكد انك تريد حذف الطعام'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('لا'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('نعم'),
              onPressed: () {
                FoodDatabaseService(fid: fid).deleteFoodData(fid);
                UploadImageHelper().deleteFile(imagePath);
                UserDatabaseService(uid: uid).deleteFoodData(target: "favorites", value: fid);
                UserDatabaseService(uid: uid).deleteFoodData(target: "likes", value: fid);
                UserDatabaseService(uid: uid).deleteFoodData(target: "foods", value: fid);
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

}