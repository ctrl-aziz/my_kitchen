import 'package:flutter/material.dart';
import 'package:my_kitchen/extensions/constants.dart';
import 'package:my_kitchen/localizations/app_localizations.dart';
import 'package:my_kitchen/models/foods.dart';
import 'package:my_kitchen/models/user.dart';
import 'package:my_kitchen/services/database/foods_database.dart';
import 'package:my_kitchen/services/database/user_database.dart';
import 'package:provider/provider.dart';

class PhotoWithName extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<AppUser>(context);
    AppLocalizations translate = AppLocalizations.of(context);

    return StreamBuilder<UserData>(
        stream: UserDatabaseService(uid: user.uid).userData,
        builder: (context, userSnapshot) {
          if(userSnapshot.hasData){
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Hero(
                  child: Container(
                    width: 110,
                    height: 110,
                    decoration: BoxDecoration(
                        color: mPrimaryColor,
                        borderRadius: BorderRadius.circular(550.0),
                        image: DecorationImage(
                            image: NetworkImage(userSnapshot.data.image),
                            fit: BoxFit.cover
                        )
                    ),
                  ),
                  tag: "userImage",
                ),
                Text(userSnapshot.data.name,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("${translate.translate("Likes count")}: "),
                    StreamBuilder<List<FoodsData>>(
                        stream: FoodDatabaseService().allFoods,
                        builder: (context, snapshot) {
                          if(!snapshot.hasData) return Align(alignment: Alignment.center, child: CircularProgressIndicator(),);
                          int likeCount = 0;
                          snapshot.data.forEach((element) {
                            print(element.infid);
                            if(userSnapshot.data.foods.contains(element.infid)){
                              print(element.like);
                              likeCount += element.like.length;
                            }
                          });
                          print(likeCount);
                          return Text("$likeCount", style: TextStyle(fontWeight: FontWeight.bold),);
                        }
                    )
                  ],
                ),
              ],
            );
          }else{
            return Align(alignment: Alignment.center, child: CircularProgressIndicator(),);
          }

        }
    );


  }
}