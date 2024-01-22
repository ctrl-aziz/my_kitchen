import 'package:flutter/material.dart';
import 'package:my_kitchen/extensions/constants.dart';
import 'package:my_kitchen/localizations/app_localizations.dart';
import 'package:my_kitchen/models/foods.dart';
import 'package:my_kitchen/services/database/foods_database.dart';

class Body extends StatefulWidget {
  final String position;

  const Body({
    Key? key,
    required this.position,
  }) : super(key: key);

  @override
  State<Body> createState() => _BodyState();
}

class _BodyState extends State<Body> {
  final List<bool> _selected = List.generate(2, (_) => false);
  List<bool> contentCheckboxes = [];
  List<bool> howToDoCheckboxes = [];

  @override
  void initState() {
    _selected[0] = true;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    AppLocalizations translate = AppLocalizations.of(context)!;

    return StreamBuilder<FoodsData>(
        stream: FoodDatabaseService(fid: widget.position).foodData,
        builder: (context, AsyncSnapshot<FoodsData> snapshot) {
          if (!snapshot.hasData) return Container();
          return Column(
            children: [
              Center(
                child: ToggleButtons(
                  isSelected: _selected,
                  borderRadius: BorderRadius.circular(9.0),
                  constraints: const BoxConstraints(
                      minWidth: 150.0, minHeight: 35.0, maxHeight: 65.0, maxWidth: 200.0),
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
                  children: [
                    Text(
                      "${translate.translate("Content")}",
                      style: const TextStyle(fontFamily: "Cairo"),
                    ),
                    Text(
                      "${translate.translate("How To Do")}",
                      style: const TextStyle(fontFamily: "Cairo"),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 3.0,
              ),
              Container(
                  width: MediaQuery.of(context).size.width,
                  height: 320,
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(9.0)),
                    color: mWhiteColor,
                  ),
                  child: (_selected[0] && !_selected[1])
                      ? content(snapshot.data!.content!)
                      : howToDo(snapshot.data!.howToDo!)),
            ],
          );
        });
  }

  SizedBox content(List<String> content) {
    return SizedBox(
        height: 250.0,
        child: ListView(
          children: List.generate(content.length, (index) {
            if (contentCheckboxes.length < content.length) {
              contentCheckboxes.add(false);
            }
            return Card(
              child: ListTile(
                key: UniqueKey(),
                leading: Checkbox(
                  onChanged: (bool? value) {},
                  tristate: true,
                  value: contentCheckboxes[index],
                ),
                title: Text(content[index]),
                onTap: () {
                  debugPrint(contentCheckboxes[index].toString());
                  setState(() {
                    contentCheckboxes[index] = !contentCheckboxes[index];
                    debugPrint(contentCheckboxes.toString());
                  });
                },
              ),
            );
          }),
        ));
  }

  // Text("${index + 1}. ")
  SizedBox howToDo(List<String> howToDo) {
    return SizedBox(
      height: 250.0,
      child: ListView(
        children: List.generate(howToDo.length, (index) {
          if (howToDoCheckboxes.length < howToDo.length) {
            howToDoCheckboxes.add(false);
          }
          return Card(
            child: ListTile(
              key: UniqueKey(),
              leading: Checkbox(
                onChanged: (bool? value) {},
                tristate: true,
                value: howToDoCheckboxes[index],
              ),
              title: Text(howToDo[index]),
              onTap: () {
                debugPrint(howToDoCheckboxes[index].toString());
                setState(() {
                  howToDoCheckboxes[index] = !howToDoCheckboxes[index];
                  debugPrint(howToDoCheckboxes.toString());
                });
              },
            ),
          );
        }),
      ),
    );
  }
}
