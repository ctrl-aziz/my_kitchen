import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:math';
// import 'package:flutter_spinning_wheel/flutter_spinning_wheel.dart';

import 'package:my_kitchen/extensions/constants.dart';
// import 'package:my_kitchen/extensions/data.dart';
import 'package:my_kitchen/localizations/app_localizations.dart';
import 'package:my_kitchen/models/foods.dart';
import 'package:my_kitchen/screens/details/details_screen.dart';
import 'package:my_kitchen/services/database/foods_database.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:showcaseview/showcaseview.dart';

class RandomFoodScreen extends StatefulWidget {
  @override
  _RandomFoodScreenState createState() => _RandomFoodScreenState();
}

class _RandomFoodScreenState extends State<RandomFoodScreen> {
  final StreamController<int> _dividerController = StreamController<int>();
  final StreamController<int> _endController = StreamController<int>();

  final _wheelNotifier = StreamController<double>();

  final keyOne = GlobalKey();
  final keyTow = GlobalKey();
  final keyThree = GlobalKey();

  final List<String> foodNames = [];
  final List<String> foodImages = [];
  final List<String> foodIds = [];
  final List<int> foodLikes = [];

  Future<Widget> _fetchEntry(int index, String fid) async {
    await Future.delayed(Duration(milliseconds: 500));
    AppLocalizations translate = AppLocalizations.of(context)!;
    TextTheme textTheme = Theme.of(context).textTheme;

    return GestureDetector(
      child: Card(
        elevation: 4.0,
        margin: EdgeInsets.symmetric(horizontal: 30.0, vertical: 5.0),
        child: Container(
          height: 80.0,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                width: 80.0,
                height: 80.0,
                decoration: BoxDecoration(
                  color: mPrimaryColor.withOpacity(0.3),
                  image: DecorationImage(
                      image: NetworkImage(foodImages.reversed.toList()[index]), fit: BoxFit.cover),
                ),
                child: Container(
                  color: mPrimaryColor.withOpacity(0.3),
                ),
              ),
              SizedBox(
                width: 10.0,
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${foodNames.reversed.toList()[index]}',
                    style:
                        textTheme.titleMedium!.copyWith(color: Colors.black54, fontWeight: FontWeight.bold),
                  ),
                  Text("${foodLikes.reversed.toList()[index]}${translate.translate("Likes")}",
                      style: textTheme.titleSmall!.copyWith(color: Colors.black45)),
                ],
              ),
            ],
          ),
        ),
      ),
      onTap: () {
        print(fid);
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => DetailsScreen(
                      position: fid,
                    )));
      },
    );
  }

  dispose() {
    super.dispose();
    _dividerController.close();
    _wheelNotifier.close();
    _endController.close();
  }

  Future checkFirstSeen() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool _seen = (prefs.getBool('rand_tut') ?? false);

    if (_seen) {
      print("Not First Time");
    } else {
      prefs.setBool('rand_tut', true);
      WidgetsBinding.instance
          .addPostFrameCallback((_) => ShowCaseWidget.of(context).startShowCase([keyOne, keyTow, keyThree]));
      print("First Time User");
    }
  }

  @override
  void initState() {
    new Timer(new Duration(milliseconds: 200), () {
      checkFirstSeen();
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    AppLocalizations translate = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        leading: CustomShowcaseWidget(
          globalKey: keyThree,
          description: "اذا لم تعجبك الاقتراحات احذفها",
          child: IconButton(
            icon: Icon(Icons.cleaning_services_rounded),
            onPressed: () {
              setState(() {
                foodNames.clear();
                foodImages.clear();
              });
            },
          ),
        ),
        title: Center(
            widthFactor: 1.7,
            child: Text("${translate.translate("Random food")}",
                style: TextStyle(fontFamily: "Cairo", fontWeight: FontWeight.bold))),
      ),
      body: StreamBuilder<List<FoodsData>>(
          stream: FoodDatabaseService().allFoods,
          builder: (context, foodSnapshot) {
            if (!foodSnapshot.hasData)
              return Align(alignment: Alignment.center, child: CircularProgressIndicator());
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CustomShowcaseWidget(
                    globalKey: keyOne,
                    description: "أذا كنت محتار شاهد اقتراح لطبختك",
                    child: Text("SpinningWheel"),
                    /*
                    child: SpinningWheel(
                      Image.asset(
                        customIcons[0],
                        color: mPrimaryColor.withOpacity(0.8),
                      ),
                      width: 1,
                      height: 1,
                      initialSpinAngle: _generateRandomAngle(),
                      spinResistance: 0.6,
                      canInteractWhileSpinning: false,
                      dividers: foodSnapshot.data!.length,
                      onUpdate: _dividerController.add,
                      onEnd: _endController.add,
                      shouldStartOrStop: _wheelNotifier.stream,
                    ),
                    */
                  ),
                  SizedBox(
                    height: 5.0,
                  ),
                  StreamBuilder(
                    stream: _dividerController.stream,
                    builder: (context, AsyncSnapshot<int> snapshot) {
                      // print("random food screen snapshot :  ${snapshot.data}");
                      if (snapshot.hasData) {
                        // print(selected);
                        return Column(
                          children: [
                            Container(
                              width: 200.0,
                              height: 200.0,
                              decoration: BoxDecoration(
                                  color: Colors.red[100],
                                  borderRadius: BorderRadius.circular(20.0),
                                  image: DecorationImage(
                                      image: NetworkImage(foodSnapshot.data![snapshot.data! - 1].image!),
                                      fit: BoxFit.cover)),
                              child: Container(
                                  decoration: BoxDecoration(
                                    color: mPrimaryColor.withOpacity(0.3),
                                    borderRadius: BorderRadius.circular(20.0),
                                  ),
                                  child: Center(
                                      child: Text(
                                    '${foodSnapshot.data![snapshot.data! - 1].name}',
                                    textAlign: TextAlign.center,
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleLarge!
                                        .copyWith(color: Colors.white, fontWeight: FontWeight.bold),
                                  ))),
                            ),
                          ],
                        );
                      } else {
                        return Container();
                      }
                    },
                  ),
                  CustomShowcaseWidget(
                    globalKey: keyTow,
                    description: 'اضغط هنا للحصول على اقتراحات لطبختك',
                    child: new ElevatedButton(
                      style: ButtonStyle(
                        backgroundColor: MaterialStatePropertyAll(Colors.white),
                        animationDuration: Duration(milliseconds: 500),
                        shape: MaterialStatePropertyAll(RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0))),
                        elevation: MaterialStatePropertyAll(4.0),
                      ),
                      child: new Text(
                        "${translate.translate("Choose your food")}",
                      ),
                      onPressed: () {
                        _wheelNotifier.sink.add(_generateRandomVelocity());
                        // print(_wheelNotifier);
                        // _dividerController.sink.add(_generateRandomAngle().toInt());
                      },
                    ),
                  ),
                  Expanded(
                    child: StreamBuilder(
                        stream: _endController.stream,
                        builder: (context, AsyncSnapshot<int> snapshot) {
                          if (snapshot.hasData) {
                            int foodPosition = snapshot.data! - 1;
                            print("data ${snapshot.data}");
                            if (!foodNames.contains(foodSnapshot.data![foodPosition].name)) {
                              foodImages.add(foodSnapshot.data![foodPosition].image!);
                              foodNames.add(foodSnapshot.data![foodPosition].name!);
                              foodIds.add(foodSnapshot.data![foodPosition].infid!);
                              foodLikes.add(foodSnapshot.data![foodPosition].like!.length);
                            }
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 60.0),
                              child: ListView.builder(
                                itemCount: foodImages.length,
                                itemBuilder: (context, index) {
                                  return FutureBuilder(
                                      future: this._fetchEntry(index, foodIds.reversed.toList()[index]),
                                      // ignore: missing_return
                                      builder: (context, AsyncSnapshot<Widget> snapshot) {
                                        switch (snapshot.connectionState) {
                                          case ConnectionState.none:
                                          case ConnectionState.waiting:
                                            return Align(
                                                alignment: Alignment.center,
                                                child: CircularProgressIndicator());
                                          case ConnectionState.done:
                                          case ConnectionState.active:
                                            if (snapshot.hasError) {
                                              return Text('Error: ${snapshot.error}');
                                            } else {
                                              Widget dataFromSnapshot = snapshot.data!;
                                              return GestureDetector(
                                                child: dataFromSnapshot,
                                                onTap: () {
                                                  print(index);
                                                },
                                              );
                                            }
                                        }
                                      });
                                },
                              ),
                            );
                          } else
                            return Container();
                        }),
                  ),
                ],
              ),
            );
          }),
    );
  }

  double _generateRandomVelocity() => (Random().nextDouble() * 6000) + 2000;

  // double _generateRandomAngle() => Random().nextDouble() * pi * 2;
}

class CustomShowcaseWidget extends StatelessWidget {
  final Widget child;
  final String description;
  final GlobalKey globalKey;

  const CustomShowcaseWidget({
    required this.description,
    required this.globalKey,
    required this.child,
  });

  @override
  Widget build(BuildContext context) => Showcase(
        key: globalKey,
        child: child,
        description: description,
      );
}
