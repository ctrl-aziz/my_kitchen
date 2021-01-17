import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:my_kitchen/localizations/app_localizations.dart';
import 'package:my_kitchen/screens/home/home_screen.dart';
import 'package:my_kitchen/screens/my_kitchen/my_kitchen_screen.dart';
import 'package:my_kitchen/screens/profile/profile_screen.dart';
import 'package:my_kitchen/screens/random_food/random_food_screen.dart';

import 'data.dart';

class CustomizedBottomBar extends StatefulWidget {
  @override
  _CustomizedBottomBarState createState() => _CustomizedBottomBarState();
}
bool isLeftToRight = false;
class _CustomizedBottomBarState extends State<CustomizedBottomBar> {
  final _indexNotifier = ValueNotifier<int>(0);

  // int index = 0;

  _onPressed(int index) {
    // setState(() {
    //   this.index = index;
    // });
    _indexNotifier.value = index;
  }

@override
  void initState() {
    Firebase.initializeApp().whenComplete(() => print("Completed"));
    super.initState();
  }
  @override
  void dispose() {
    _indexNotifier.dispose();
    super.dispose();
  }

  var tabScreen = [
    HomeScreen(),
    MyKitchenScreen(),
    RandomFoodScreen(),
    ProfileScreen()
  ];

  @override
  Widget build(BuildContext context) {
    print("main Bottom bar build widget");

    if (AppLocalizations.of(context).locale.languageCode == "en"){
      setState(() {
        isLeftToRight = true;
      });
    }
    final Size size = MediaQuery
        .of(context)
        .size;

    List<double> position = [
      size.width * 0.087,
      size.width * 0.31,
      size.width * 0.535,
      size.width * 0.76
    ];


    return Scaffold(
      body: Stack(
        children: [
          ValueListenableBuilder(
              valueListenable: _indexNotifier,
              builder: (_, value, __) => tabScreen[value]),
          // tabScreen[index],
          Positioned(
              bottom: 0,
              left: 0,
              child: Container(
                width: size.width,
                height: 80,
                child: Stack(
                  children: [
                    ValueListenableBuilder(
                    valueListenable: _indexNotifier,
                    builder: (_, value, __) => CustomPaint(
                        size: Size(size.width, 80),
                        painter: MyCustomPainter(value),
                      ),
                    ),
                    // CustomPaint(
                    //   size: Size(size.width, 80),
                    //   painter: MyCustomPainter(index),
                    // ),
                    ValueListenableBuilder(
                      valueListenable: _indexNotifier,
                      builder: (_, value, __) =>
                          AnimatedPositioned(
                            duration: Duration(milliseconds: 300),
                            right: isLeftToRight ? position.reversed.toList()[value] : position[value],
                            // TODO Make Bottom bar buttons jumping after 1.5 version update
                            child: Center(
                              heightFactor: 1.4,
                              child: FloatingActionButton(
                                backgroundColor: Color(0xFF424240),
                                // child: Icon(Icons.home_outlined),
                                elevation: 0.1,
                                onPressed: (){},
                              ),
                            ),
                          ),
                    ),
                    Container(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          IconButton(icon: Image.asset(customIcons[1],color: Colors.red,height: 25.0,), onPressed: () => _onPressed(0)),
                          IconButton(icon: Image.asset(customIcons[2],color: Colors.red,height: 25.0,), onPressed: () => _onPressed(1)),
                          IconButton(icon: Image.asset(customIcons[3],color: Colors.red,height: 25.0,), onPressed: () => _onPressed(2)),
                          IconButton(icon: Icon(Icons.person_outline,color: Colors.red,), onPressed: () => _onPressed(3)),
                        ],
                      ),
                    ),


                  ],
                ),
              )
          )
        ],
      ),
    );
  }
}

class MyCustomPainter extends CustomPainter{
  final int index;



  MyCustomPainter(this.index);

  @override
  void paint(Canvas canvas, Size size) {

    List<double> clickPosition = [
      size.width*0.3334,
      size.width*0.1112,
      -size.width*0.1112,
      -size.width*0.3334
    ];

    double pos = (size.width * 0.20);
    double pos2 = isLeftToRight ? clickPosition.reversed.toList()[index] : clickPosition[index];
    double pos3 = size.width * 0.35;
    double pos4 = size.width * 0.40;
    double pos5 = size.width * 0.65;

    //print("main Bottom bar $pos2");


    Paint paint = Paint()..color = Colors.white..style = PaintingStyle.fill;
    Path path = Path()..moveTo(0, 35);

    path.quadraticBezierTo((pos*1)+pos2, 20, pos3+pos2, 20);
    path.quadraticBezierTo((pos*2)+pos2, 20, pos4+pos2, 40);
    path.arcToPoint(Offset((pos*3)+pos2, 40), radius: Radius.circular(10.0), clockwise: false);
    path.quadraticBezierTo((pos*3)+pos2, 20, pos5+pos2, 20);
    path.quadraticBezierTo((pos*4)+pos2, 20, size.width, 35);

    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);

    path.close();
    canvas.drawShadow(path, Colors.black, 5, true);

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;



}
