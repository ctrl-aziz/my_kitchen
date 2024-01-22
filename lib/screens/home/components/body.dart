
import 'package:flutter/material.dart';
import 'package:my_kitchen/extensions/constants.dart';
import 'package:my_kitchen/extensions/data.dart';
import 'package:my_kitchen/localizations/app_localizations.dart';
import 'package:my_kitchen/screens/food_list/food_list_screen.dart';

class Body extends StatelessWidget {
  const Body({super.key});


  @override
  Widget build(BuildContext context) {
    for (var element in images) {precacheImage(AssetImage(element), context);}
    Size deviceSize = MediaQuery.of(context).size;
    TextTheme textTheme = Theme.of(context).textTheme;
    AppLocalizations translate = AppLocalizations.of(context)!;

    return ListView.builder(
      physics: const ScrollPhysics(),
      scrollDirection: Axis.vertical,
      itemCount: images.length,
      padding: const EdgeInsets.all(mDefaultPadding - 4.0),
      itemBuilder: (context, index) {
        return GestureDetector(
          child: Card(
            margin: const EdgeInsets.symmetric(vertical: mDefaultPadding/2),
            elevation: 4.0,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.0)),
            clipBehavior: Clip.antiAlias,
            child: Stack(
              children: <Widget>[
                Positioned(
                    child: Hero(
                        tag: "mainImage$index",
                        child: Container(
                          height: 150,
                          width: deviceSize.width,
                          decoration: BoxDecoration(
                              image: DecorationImage(
                                  image: AssetImage(images[index]),
                                  fit: BoxFit.cover
                              )
                          ),child: Container(color: const Color.fromRGBO(255, 100, 100, 0.7),),
                        )
                    )
                ),
                Positioned(
                    top: deviceSize.height*0.05,
                    left: -15.0,
                    width: deviceSize.width,
                    child: Material(color: Colors.transparent,
                        child: Text('${translate.translate("Kitchen of")} ${translate.translate(title[index])}',
                            style: textTheme.headlineSmall!.apply(color: mWhiteColor),
                          textAlign: TextAlign.center,
                        )
                    )
                ),
              ],
            ),
          ),
          onTap: () {
            Navigator.of(context).push(PageRouteBuilder(
              settings: const RouteSettings(name: '/foodList'),
              fullscreenDialog: true,
              transitionDuration: const Duration(milliseconds: 1000),
              pageBuilder: (BuildContext context,
                  Animation<double> animation,
                  Animation<double> secondaryAnimation) {
                return FoodListScreen(position: index,);
              },
              transitionsBuilder: (BuildContext context,
                  Animation<double> animation,
                  Animation<double> secondaryAnimation, Widget child) {
                return FadeTransition(opacity: animation, child: child,);
              },),);
          },
        );
      },
    );
  }
}



// return Align(alignment: Alignment.center,child: CircularProgressIndicator());