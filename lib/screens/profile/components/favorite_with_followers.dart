import 'package:flutter/material.dart';
import 'package:my_kitchen/extensions/constants.dart';
import 'package:my_kitchen/models/foods.dart';
import 'package:my_kitchen/models/user.dart';
import 'package:my_kitchen/screens/details/details_screen.dart';
import 'package:my_kitchen/services/database/foods_database.dart';
import 'package:my_kitchen/services/database/user_database.dart';
import 'package:provider/provider.dart';

class FavoriteWithFollowers extends StatefulWidget {
  const FavoriteWithFollowers({super.key});

  @override
  State<FavoriteWithFollowers> createState() => _FavoriteWithFollowersState();
}

class _FavoriteWithFollowersState extends State<FavoriteWithFollowers> {
  final List<bool> _selected = List.generate(2, (_) => false);
  bool followersDeletable = false;
  bool favoriteDeletable = false;

  @override
  void initState() {
    _selected[0] = true;
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    final user = Provider.of<AppUser?>(context);
    if(user == null) return const Align(alignment: Alignment.center, child: CircularProgressIndicator(),);
    return Container(
      height: 300,
      decoration: const BoxDecoration(
        color: mWhiteColor,
      ),
      child: StreamBuilder<UserData>(
          stream: UserDatabaseService(uid: user.uid).userData,
          builder: (context, AsyncSnapshot<UserData> snapshot) {
            if(!snapshot.hasData) return const Align(alignment: Alignment.center, child: CircularProgressIndicator(),);
            List<String> data = snapshot.data!.favorites!;
            return GridView.count(
                crossAxisCount: 3,
              children: List.generate(snapshot.data!.favorites!.length, (index) {
                return StreamBuilder<FoodsData>(
                    stream: FoodDatabaseService(fid: data[index]).foodData,
                    builder: (context, AsyncSnapshot<FoodsData> snapshot) {
                      if(snapshot.hasData && !snapshot.hasError){
                        return GestureDetector(
                          child: Container(
                          width: MediaQuery.of(context).size.width / 3,
                          height: MediaQuery.of(context).size.width / 3,
                          margin: const EdgeInsets.all(2.0),
                          decoration: BoxDecoration(
                              color: mPrimaryColor,
                              borderRadius: BorderRadius.circular(5.0),
                              image: DecorationImage(
                                  image: NetworkImage(snapshot.data!.image!),
                                  fit: BoxFit.cover
                              )
                          ),
                          child: Container(
                            color: mPrimaryColor.withOpacity(0.3),
                          )
                            ),
                          onTap: (){
                            Navigator.push(context, MaterialPageRoute(builder: (context) => DetailsScreen(position: snapshot.data!.infid!)));
                          },
                          onDoubleTap: (){
                            FoodDatabaseService(fid: snapshot.data!.infid).updateFavoriteFood(target: 'favorite', value: user.uid);
                            UserDatabaseService(uid: user.uid).updateUserDataByOne(target: 'favorites', value: snapshot.data!.infid!);
                                                    },
                        );
                      }else {
                        return const Material(
                          child: Center(child: CircularProgressIndicator(),),
                        );
                      }

                    }
                );
              }),
            );

            // if (snapshot.hasData) {
            //   if(_selected[0]){
            //     return favorite(snapshot.data.favorites);
            //   }else if(_selected[1]){
            //     return followers(snapshot.data.followers);
            //   }
            // }
          }
      ),
    );

    // return Column(
    //   children: [
    //     Center(
    //       child: ToggleButtons(
    //         children: [
    //           Text("${translate.translate("Favorites")}", style: TextStyle(fontFamily: "Cairo"),),
    //           Text(
    //             "${translate.translate("Followers")}", style: TextStyle(fontFamily: "Cairo"),),
    //         ],
    //         isSelected: _selected,
    //         borderRadius: BorderRadius.circular(9.0),
    //         constraints: BoxConstraints(
    //             minWidth: 135.0,
    //             minHeight: 35.0,
    //             maxHeight: 65.0,
    //             maxWidth: 200.0
    //         ),
    //         onPressed: (value) {
    //           if (value == 0) {
    //             setState(() {
    //               _selected[0] = true;
    //               _selected[1] = false;
    //             });
    //           } else if (value == 1) {
    //             setState(() {
    //               _selected[0] = false;
    //               _selected[1] = true;
    //             });
    //           }
    //           // print(_selected);
    //         },
    //       ),
    //     ),
    //     SizedBox(height: 3.0,),
    //
    //   ],
    // );
  }

  //
  // ListView followers(List<String> data) {
  //   AppLocalizations translate = AppLocalizations.of(context);
  //   return ListView.builder(
  //       scrollDirection: Axis.vertical,
  //       physics: BouncingScrollPhysics(),
  //       itemCount: data.length,
  //       itemBuilder: (context, index) {
  //         return StreamBuilder<DocumentSnapshot>(
  //             stream: FirebaseFirestore.instance.collection("users").doc(data[index]).snapshots(),
  //             builder: (BuildContext context,
  //                 AsyncSnapshot<DocumentSnapshot> snapshot) {
  //               if (snapshot.hasData && snapshot != null) {
  //                 print("${snapshot.data.data()['name']}");
  //                 return ListTile(
  //                   title: Text("${snapshot.data.data()['name']}", style: TextStyle(fontFamily: "Cairo"),),
  //                   subtitle: Text("${translate.translate("Foods count")} ${(List.from(snapshot.data.data()['foods'])).length}",
  //                     style: TextStyle(fontFamily: "Cairo"),),
  //                   leading: Container(
  //                     width: 60,
  //                     height: 60,
  //                     decoration: BoxDecoration(
  //                         color: mPrimaryColor,
  //                         borderRadius: BorderRadius.circular(200.0),
  //                         image: DecorationImage(
  //                             image: NetworkImage(snapshot.data.data()['image']),
  //                             fit: BoxFit.cover
  //                         )
  //                     ),
  //                   ),
  //                   trailing: followersDeletable ? IconButton(
  //                     icon: Icon(Icons.delete),
  //                     onPressed: (){
  //                       print("delete");
  //                     },
  //                   ) : null,
  //                   hoverColor: mBlueColor,
  //                   autofocus: true,
  //                   onLongPress: (){
  //                     setState(() {
  //                       followersDeletable = true;
  //                     });
  //                   },
  //                   onTap: () {
  //                     setState(() {
  //                       followersDeletable = false;
  //                     });
  //                     print(followersDeletable);
  //                     print(index);
  //                   },
  //                 );
  //               } else {
  //                 return Material(
  //                   child: Center(child: CircularProgressIndicator(),),
  //                 );
  //               }
  //             }
  //         );
  //       }
  //   );
  // }
  //
  // ListView favorite(List<String> data) {
  //   AppLocalizations translate = AppLocalizations.of(context);
  //   return ListView.builder(
  //       scrollDirection: Axis.vertical,
  //       physics: BouncingScrollPhysics(),
  //       itemCount: data.length,
  //       itemBuilder: (context, index) {
  //         return StreamBuilder<FoodsData>(
  //             stream: FoodDatabaseService(fid: data[index]).foodData,
  //             builder: (context, snapshot) {
  //               if(snapshot.hasData && snapshot != null){
  //                 return ListTile(
  //                   title: Text("${snapshot.data.name}", style: TextStyle(fontFamily: "Cairo"),),
  //                   subtitle: Text("${translate.translate("Likes count")} ${snapshot.data.like.length}", style: TextStyle(fontFamily: "Cairo"),),
  //                   leading: Container(
  //                     width: 60,
  //                     height: 75,
  //                     decoration: BoxDecoration(
  //                         color: mPrimaryColor,
  //                         borderRadius: BorderRadius.circular(50.0),
  //                         image: DecorationImage(
  //                             image: NetworkImage(snapshot.data.image),
  //                             fit: BoxFit.cover
  //                         )
  //                     ),
  //                   ),
  //                   trailing: favoriteDeletable ? IconButton(
  //                     icon: Icon(Icons.delete),
  //                     onPressed: (){
  //                       print("delete");
  //                     },
  //                   ) : null,
  //                   hoverColor: mBlueColor,
  //                   autofocus: true,
  //                   onLongPress: (){
  //                     setState(() {
  //                       favoriteDeletable = true;
  //                     });
  //                   },
  //                   onTap: () {
  //                     setState(() {
  //                       favoriteDeletable = false;
  //                     });
  //                     print(favoriteDeletable);
  //                     print(index);
  //                     Navigator.push(context, MaterialPageRoute(builder: (context) => DetailsScreen(position: data[index])));
  //                   },
  //                 );
  //               }else {
  //                 return Material(
  //                   child: Center(child: CircularProgressIndicator(),),
  //                 );
  //               }
  //
  //             }
  //         );
  //       });
  // }
}