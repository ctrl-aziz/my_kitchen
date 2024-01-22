import 'package:flutter/material.dart';
import 'package:my_kitchen/extensions/constants.dart';
import 'package:my_kitchen/localizations/app_localizations.dart';
import 'package:my_kitchen/models/foods.dart';
import 'package:my_kitchen/models/user.dart';
import 'package:my_kitchen/services/database/foods_database.dart';
import 'package:my_kitchen/services/database/user_database.dart';
import 'package:provider/provider.dart';

class FoodNameWithTitle extends StatefulWidget {
  final String position;

  const FoodNameWithTitle({Key? key, required this.position}) : super(key: key);

  @override
  State<FoodNameWithTitle> createState() => _FoodNameWithTitleState();
}

class _FoodNameWithTitleState extends State<FoodNameWithTitle> {
  bool likeIcon = false;
  bool favoriteIcon = false;

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<AppUser?>(context);
    AppLocalizations translate = AppLocalizations.of(context)!;
    TextTheme textTheme = Theme.of(context).textTheme;
    Size size = MediaQuery.of(context).size;

    return StreamBuilder<FoodsData>(
      stream: FoodDatabaseService(fid: widget.position).foodData,
      builder: (context, snapshot) {
        if(!snapshot.hasData) return const Align(alignment: Alignment.center,child: CircularProgressIndicator(),);
        FoodsData foodsData = snapshot.data!;

        return Hero(
          tag: "foodItem${widget.position}",
          child: Material(
            color: Colors.transparent,
            child: Stack(
              children: [
                foodsData.image == null
                    ?
                const Center(heightFactor: 2.0, child: SizedBox(width: 75.0, height: 75.0,child: Icon(Icons.image),))
                    :
                Container(
                  width: size.width,
                  height: 200,
                  alignment: Alignment.center,
                  margin: const EdgeInsets.all(0.0),
                  decoration: BoxDecoration(
                      image: DecorationImage(
                          image: NetworkImage(foodsData.image!),
                          fit: BoxFit.cover
                      )
                  ),
                  child: Container(
                      width: size.width,
                      height: 200,
                      alignment: Alignment.center,
                      decoration: const BoxDecoration(
                        color: Color.fromRGBO(255, 100, 100, 0.3),
                      ),
                      child: const Text("")
                  ),
                ),
                Positioned(
                  right: size.width/7,
                  left: size.width/5,
                  top: 30.0,
                  child: Container(
                    alignment: Alignment.center,
                    width: size.width * .6,
                    padding: const EdgeInsets.only(right: mDefaultPadding/3),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Text(foodsData.name!, style: textTheme.titleLarge!.copyWith(color: mWhiteColor, fontWeight: FontWeight.bold),),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text("${translate.translate("By")} ", style: textTheme.titleSmall!.copyWith(color: mWhiteColor),),
                            Text("${foodsData.owner}", style: textTheme.titleSmall!.copyWith(color: mWhiteColor),),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                Positioned(
                  bottom: 0.0,
                  child: Container(
                    margin: const EdgeInsets.only( top: mDefaultPadding),
                    padding: const EdgeInsets.only(right: mDefaultPadding/2),
                    width: size.width,
                    color: mBackgroundColor.withOpacity(0.5),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("${translate.translate("Like")}", style: textTheme.titleMedium!.copyWith(color: mTextColor),),
                        Stack(
                          children: [
                            IconButton(
                                icon: (user != null && foodsData.like!.contains(user.uid)) ? const Icon(Icons.favorite) : const Icon(Icons.favorite_border_outlined) , color: mPrimaryColor,iconSize: 40.0,
                                onPressed: () {
                                  if(user == null) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("${translate.translate("Please login to add like")}", style: const TextStyle(color: Colors.black54), textAlign: TextAlign.center,), duration: const Duration(seconds: 1), backgroundColor: Colors.white,));
                                  if(user != null){
                                    FoodDatabaseService(fid: widget.position).updateFavoriteFood(target: 'like', value: user.uid);
                                    UserDatabaseService(uid: user.uid).updateUserDataByOne(target: 'likes', value: widget.position);
                                  }
                                }
                            ),
                            Text("${foodsData.like!.length}", style: textTheme.titleMedium!.copyWith(color: mWhiteColor),),
                          ],
                        ),
                        Text("${translate.translate("Favorite")}", style: textTheme.titleMedium!.copyWith(color: mTextColor),),
                        Stack(
                          children: [
                            IconButton(
                                icon: (user != null && foodsData.favorite!.contains(user.uid)) ? const Icon(Icons.star) : const Icon(Icons.star_border_outlined), color: mPrimaryColor,iconSize: 40.0,
                                onPressed: () {
                                  if(user == null) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("${translate.translate("Please login to add to favorite")}", style: const TextStyle(color: Colors.black54), textAlign: TextAlign.center,), backgroundColor: Colors.white , duration: const Duration(seconds: 1),));
                                  if(user != null){
                                    FoodDatabaseService(fid: widget.position).updateFavoriteFood(target: 'favorite', value: user.uid);
                                    UserDatabaseService(uid: user.uid).updateUserDataByOne(target: 'favorites', value: widget.position);
                                  }
                                }
                            ),
                            Text("${foodsData.favorite!.length}", style: textTheme.titleMedium!.copyWith(color: mWhiteColor),),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      }
    );
  }
}