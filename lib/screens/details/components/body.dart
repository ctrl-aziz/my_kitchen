import 'package:flutter/material.dart';
import 'package:my_kitchen/extensions/constants.dart';
import 'package:my_kitchen/localizations/app_localizations.dart';
import 'package:my_kitchen/models/foods.dart';
import 'package:my_kitchen/services/database/foods_database.dart';

class Body extends StatefulWidget {
  final position;

  Body({Key key, this.position}) : super(key: key);

  @override
  _BodyState createState() => _BodyState(position);
}

class _BodyState extends State<Body> {
  final position;
  List<bool> _selected = List.generate(2, (_) => false);

  _BodyState(this.position);

  @override
  void initState() {
    _selected[0] = true;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    AppLocalizations translate = AppLocalizations.of(context);

    return StreamBuilder<FoodsData>(
      stream: FoodDatabaseService(fid: widget.position).foodData,
      builder: (context, snapshot) {
        if(!snapshot.hasData) return Container();
        return Column(
          children: [
            Center(
              child: ToggleButtons(
                children: [
                  Text("${translate.translate("Content")}", style: TextStyle(fontFamily: "Cairo"),),
                  Text(
                    "${translate.translate("How To Do")}", style: TextStyle(fontFamily: "Cairo"),),
                ],
                isSelected: _selected,
                borderRadius: BorderRadius.circular(9.0),
                constraints: BoxConstraints(
                    minWidth: 150.0,
                    minHeight: 35.0,
                    maxHeight: 65.0,
                    maxWidth: 200.0
                ),
                onPressed: (value) {
                  if (value == 0) {
                    setState(() {
                      _selected[0] = true;
                      _selected[1] = false;
                    });
                  } else if (value == 1) {
                    setState(() {
                      _selected[0] = false;
                      _selected[1] = true;
                    });
                  }
                  // print(_selected);
                },
              ),
            ),
            SizedBox(height: 3.0,),
            Container(
                width: MediaQuery.of(context).size.width,
                height: 320,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(9.0)),
                  color: mWhiteColor,
                ),
                child: (_selected[0] && !_selected[1]) ? content(snapshot.data.content) : howToDo(snapshot.data.howToDo)
            ),
          ],
        );
      }
    );
  }


  Container content(List<String> content){
    return Container(
        height: 250.0,
        child: ListView(
          children: List.generate(content.length, (index) {
            return Card(
              child: ListTile(
                key: UniqueKey(),
                leading: Text("${index + 1}. "),
                title: Container(child: Text(content[index]),),
              ),
            );
          }),
        )
    );
  }

  Container howToDo(List<String> howToDo){
    return Container(
        height: 250.0,
        child: ListView(
          children: List.generate(howToDo.length, (index) {
            return Card(
              child: ListTile(
                key: UniqueKey(),
                leading: Text("${index + 1}. "),
                title: Container(child: Text(howToDo[index]),),
              ),
            );
          }),
        )
    );
  }
}
