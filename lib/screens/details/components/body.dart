import 'package:flutter/material.dart';
import 'package:my_kitchen/extensions/constants.dart';
import 'package:my_kitchen/localizations/app_localizations.dart';
import 'package:my_kitchen/models/foods.dart';
import 'package:my_kitchen/services/database/foods_database.dart';

class Body extends StatefulWidget {
  final String position;
  final PageController pageController;

  const Body({
    Key? key,
    required this.position,
    required this.pageController,
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
  void dispose() {
    widget.pageController.dispose();
    super.dispose();
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
                constraints:
                    const BoxConstraints(minWidth: 150.0, minHeight: 35.0, maxHeight: 65.0, maxWidth: 200.0),
                onPressed: (value) {
                  if (value == 0) {
                    setState(() {
                      _selected[0] = true;
                      _selected[1] = false;
                      widget.pageController.animateToPage(0, duration: const Duration(milliseconds: 300), curve: Curves.easeIn);
                    });
                  } else if (value == 1) {
                    setState(() {
                      _selected[0] = false;
                      _selected[1] = true;
                      widget.pageController.animateToPage(1, duration: const Duration(milliseconds: 300), curve: Curves.easeIn);
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
            Expanded(
              child: Container(
                width: MediaQuery.of(context).size.width,
                // height: 320,
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(9.0)),
                  color: mWhiteColor,
                ),
                child: PageView(
                  controller: widget.pageController,
                  children: [
                    content(snapshot.data!.content!),
                    howToDo(snapshot.data!.howToDo!),
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget content(List<String> content) {
    return Expanded(
      child: ListView.builder(
        itemCount: content.length,
        itemBuilder: (context, index){
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
        },
      ),
    );
  }

  // Text("${index + 1}. ")
  Widget howToDo(List<String> howToDo) {
    return Expanded(
      child: ListView.builder(
        itemCount: howToDo.length,
        itemBuilder: (context, index){
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
        },
      ),
    );
  }
}
