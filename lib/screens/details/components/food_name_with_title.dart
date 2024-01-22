import 'package:flutter/material.dart';
import 'package:my_kitchen/extensions/constants.dart';
import 'package:my_kitchen/localizations/app_localizations.dart';
import 'package:my_kitchen/models/foods.dart';
import 'package:my_kitchen/models/user.dart';
import 'package:my_kitchen/services/database/foods_database.dart';
import 'package:my_kitchen/services/database/user_database.dart';
import 'package:provider/provider.dart';

class FoodNameWithTitle extends StatefulWidget {
  final position;

  FoodNameWithTitle({Key? key, this.position}) : super(key: key);

  @override
  _FoodNameWithTitleState createState() => _FoodNameWithTitleState(position: position);
}

class _FoodNameWithTitleState extends State<FoodNameWithTitle> {
  final position;
  bool likeIcon = false;
  bool favoriteIcon = false;

  _FoodNameWithTitleState({this.position});

  @override
  Widget build(BuildContext context) {
    final _user = Provider.of<AppUser?>(context);
    AppLocalizations translate = AppLocalizations.of(context)!;
    TextTheme textTheme = Theme.of(context).textTheme;
    Size size = MediaQuery.of(context).size;

    return StreamBuilder<FoodsData>(
      stream: FoodDatabaseService(fid: widget.position).foodData,
      builder: (context, snapshot) {
        if(!snapshot.hasData) return Align(alignment: Alignment.center,child: CircularProgressIndicator(),);
        FoodsData _foodsData = snapshot.data!;

        return Hero(
          tag: "foodItem${widget.position}",
          child: Material(
            color: Colors.transparent,
            child: Container(
              child: Stack(
                children: [
                  _foodsData.image == null
                      ?
                  Center(heightFactor: 2.0, child: Container(child: Icon(Icons.image), width: 75.0, height: 75.0,))
                      :
                  Container(
                    width: size.width,
                    height: 200,
                    alignment: Alignment.center,
                    margin: EdgeInsets.all(0.0),
                    decoration: BoxDecoration(
                        image: DecorationImage(
                            image: NetworkImage(_foodsData.image!),
                            fit: BoxFit.cover
                        )
                    ),
                    child: Container(
                        width: size.width,
                        height: 200,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: Color.fromRGBO(255, 100, 100, 0.3),
                        ),
                        child: Text("")
                    ),
                  ),
                  Positioned(
                    right: size.width/7,
                    left: size.width/5,
                    top: 30.0,
                    child: Container(
                      alignment: Alignment.center,
                      width: size.width * .6,
                      padding: EdgeInsets.only(right: mDefaultPadding/3),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Text(_foodsData.name!, style: textTheme.titleLarge!.copyWith(color: mWhiteColor, fontWeight: FontWeight.bold),),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text("${translate.translate("By")} ", style: textTheme.titleSmall!.copyWith(color: mWhiteColor),),
                              Text("${_foodsData.owner}", style: textTheme.titleSmall!.copyWith(color: mWhiteColor),),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 0.0,
                    child: Container(
                      margin: EdgeInsets.only( top: mDefaultPadding),
                      padding: EdgeInsets.only(right: mDefaultPadding/2),
                      width: size.width,
                      color: mBackgroundColor.withOpacity(0.5),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text("${translate.translate("Like")}", style: textTheme.titleMedium!.copyWith(color: mTextColor),),
                          Stack(
                            children: [
                              IconButton(
                                  icon: (_user != null && _foodsData.like!.contains(_user.uid)) ? Icon(Icons.favorite) : Icon(Icons.favorite_border_outlined) , color: mPrimaryColor,iconSize: 40.0,
                                  onPressed: () {
                                    if(_user == null) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("${translate.translate("Please login to add like")}", style: TextStyle(color: Colors.black54), textAlign: TextAlign.center,), duration: Duration(seconds: 1), backgroundColor: Colors.white,));
                                    if(_user != null){
                                      FoodDatabaseService(fid: position).updateFavoriteFood(target: 'like', value: _user.uid);
                                      UserDatabaseService(uid: _user.uid).updateUserDataByOne(target: 'likes', value: position);
                                    }
                                  }
                              ),
                              Text("${_foodsData.like!.length}", style: textTheme.titleMedium!.copyWith(color: mWhiteColor),),
                            ],
                          ),
                          Text("${translate.translate("Favorite")}", style: textTheme.titleMedium!.copyWith(color: mTextColor),),
                          Stack(
                            children: [
                              IconButton(
                                  icon: (_user != null && _foodsData.favorite!.contains(_user.uid)) ? Icon(Icons.star) : Icon(Icons.star_border_outlined), color: mPrimaryColor,iconSize: 40.0,
                                  onPressed: () {
                                    if(_user == null) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("${translate.translate("Please login to add to favorite")}", style: TextStyle(color: Colors.black54), textAlign: TextAlign.center,), backgroundColor: Colors.white , duration: Duration(seconds: 1),));
                                    if(_user != null){
                                      FoodDatabaseService(fid: position).updateFavoriteFood(target: 'favorite', value: _user.uid);
                                      UserDatabaseService(uid: _user.uid).updateUserDataByOne(target: 'favorites', value: position);
                                    }
                                  }
                              ),
                              Text("${_foodsData.favorite!.length}", style: textTheme.titleMedium!.copyWith(color: mWhiteColor),),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      }
    );
  }
}