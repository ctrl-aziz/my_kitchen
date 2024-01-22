import 'package:flutter/material.dart';
import 'package:my_kitchen/extensions/constants.dart';
import 'package:my_kitchen/localizations/app_localizations.dart';
import 'package:my_kitchen/models/foods.dart';
import 'package:my_kitchen/models/user.dart';
import 'package:my_kitchen/services/database/foods_database.dart';
import 'package:my_kitchen/services/database/user_database.dart';
import 'package:provider/provider.dart';
import 'package:percent_indicator/percent_indicator.dart';

// ignore: must_be_immutable
class PhotoWithName extends StatelessWidget {
  List<Color> levelColors = [
    Colors.white,
    Colors.red,
    Colors.blue,
    Colors.green,
    Colors.orangeAccent,
    Colors.purpleAccent,
    Colors.pink,
    Colors.amber,
    Colors.grey,
    Colors.deepPurpleAccent,
  ];

  PhotoWithName({super.key});

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<AppUser>(context);
    AppLocalizations translate = AppLocalizations.of(context)!;

    return StreamBuilder<UserData>(
        stream: UserDatabaseService(uid: user.uid).userData,
        builder: (context, userSnapshot) {
          if (userSnapshot.hasData) {
            return StreamBuilder<List<FoodsData>>(
                stream: FoodDatabaseService().allFoods,
                builder: (context, AsyncSnapshot<List<FoodsData>> snapshot) {
                  if (!snapshot.hasData) {
                    return const Align(
                      alignment: Alignment.center,
                      child: CircularProgressIndicator(),
                    );
                  }
                  int likeCount = 0;
                  double progressLevel = 0.0;
                  int level = 0;
                  for (var element in snapshot.data!) {
                    debugPrint(element.infid);
                    if (userSnapshot.data!.foods!.contains(element.infid)) {
                      debugPrint(element.like.toString());
                      likeCount += element.like!.length;
                    }
                  }
                  if (likeCount <= 50) {
                    progressLevel = likeCount.toDouble() / 50;
                    level = 1;
                  } else if (likeCount <= 100) {
                    progressLevel = likeCount.toDouble() / 100;
                    level = 2;
                  } else if (likeCount <= 500) {
                    progressLevel = likeCount.toDouble() / 500;
                    level = 3;
                  } else if (likeCount <= 1000) {
                    progressLevel = likeCount.toDouble() / 1000;
                    level = 4;
                  } else if (likeCount <= 5000) {
                    progressLevel = likeCount.toDouble() / 5000;
                    level = 5;
                  } else if (likeCount <= 10000) {
                    progressLevel = likeCount.toDouble() / 10000;
                    level = 6;
                  } else if (likeCount <= 50000) {
                    progressLevel = likeCount.toDouble() / 50000;
                    level = 7;
                  } else if (likeCount <= 100000) {
                    progressLevel = likeCount.toDouble() / 100000;
                    level = 8;
                  } else if (likeCount <= 500000) {
                    progressLevel = likeCount.toDouble() / 500000;
                    level = 9;
                  } else {
                    progressLevel = likeCount / likeCount;
                  }
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("${translate.translate("Level")}: $level"),
                      Container(
                        width: 110,
                        height: 110,
                        decoration: BoxDecoration(
                          color: mPrimaryColor,
                          shape: BoxShape.circle,
                          image: DecorationImage(
                              image: NetworkImage(userSnapshot.data!.image!), fit: BoxFit.cover),
                        ),
                        child: CircularPercentIndicator(
                          radius: 55.0,
                          lineWidth: 5.0,
                          percent: progressLevel,
                          center: const Text(
                            "",
                            style: TextStyle(color: Colors.white),
                          ),
                          progressColor: levelColors[level],
                        ),
                      ),
                      Text(
                        userSnapshot.data!.name!,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text("${translate.translate("Likes count")}: "),
                          Text(
                            "$likeCount",
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          )
                        ],
                      ),
                    ],
                  );
                });
          } else {
            return const Align(
              alignment: Alignment.center,
              child: CircularProgressIndicator(),
            );
          }
        });
  }
}
