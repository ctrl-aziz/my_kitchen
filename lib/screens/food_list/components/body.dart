import 'package:flutter/material.dart';
import 'package:my_kitchen/extensions/constants.dart';
import 'package:my_kitchen/models/foods.dart';
import 'package:my_kitchen/screens/details/details_screen.dart';
import 'package:my_kitchen/services/database/foods_database.dart';

class Body extends StatefulWidget {
  final position;
  Body({this.position});

  @override
  _BodyState createState() => _BodyState(position: position);
}

class _BodyState extends State<Body> {
  final position;
  List<String> countryCode = [
    "eg", "sa", "sy", "lb",
    "jo", "iq", "dz", "ma", "tn",
  ];

  _BodyState({this.position});

  @override
  Widget build(BuildContext context) {
    print(position);

    return StreamBuilder<List<FoodsData>>(
      stream: FoodDatabaseService().allFoods,
      builder: (context, AsyncSnapshot<List<FoodsData>> snapshot) {
        if(snapshot.hasData){
          List<FoodsData> readyList = [];
          for(var foodList in snapshot.data!){
            for(var countries in foodList.country!){
              if(countryCode[position] == countries){
                readyList.add(foodList);
              }
            }

          }
          return GridView.count(
            scrollDirection: Axis.vertical,
            physics: BouncingScrollPhysics(),
            shrinkWrap: true,
            crossAxisCount: 3,
            children: List.generate(readyList.length, (index) {
              return Hero(
                tag: "foodItem${readyList[index].infid}",
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    child: Container(
                      width: 100.0,
                      height: 100.0,
                      alignment: Alignment.center,
                      margin: EdgeInsets.all(10.0),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(200.0),
                        image: DecorationImage(
                            image: NetworkImage(readyList[index].image!),
                            fit: BoxFit.cover
                        )
                      ),
                      child: Container(
                          width: 100,
                          height: 100,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: Color.fromRGBO(255, 100, 100, 0.3),
                            borderRadius: BorderRadius.circular(200.0),
                          ),
                          child: Text(readyList[index].name!, style: Theme.of(context).textTheme.titleSmall!.copyWith(color: mWhiteColor, fontWeight: FontWeight.bold), textAlign: TextAlign.center,)
                      ),
                    ),
                    onTap: (){
                      Navigator.of(context).push(MaterialPageRoute(builder: (context) => DetailsScreen(position: readyList[index].infid)));
                    },
                  ),
                ),
              );
            }),

          );
        }
        else{
          return Container();
        }
      }
    );
  }
}
