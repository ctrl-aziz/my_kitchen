import 'dart:math';

import 'package:flutter/material.dart';
import 'package:my_kitchen/extensions/constants.dart';
import 'package:my_kitchen/extensions/data.dart';
import 'package:my_kitchen/localizations/app_localizations.dart';

import 'components/body.dart';

class FoodListScreen extends StatefulWidget {
  final int position;

  const FoodListScreen({Key? key, required this.position}) : super(key: key);

  @override
  State<FoodListScreen> createState() => _FoodListScreenState();
}

int toggle = 0;

class _FoodListScreenState extends State<FoodListScreen> with SingleTickerProviderStateMixin{
  late AnimationController _con;
  late TextEditingController _textEditingController;


  @override
  void initState() {
    super.initState();
    _textEditingController = TextEditingController();
    _con = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 375),
    );
  }

  @override
  void dispose() {
    _textEditingController.dispose();
    _con.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: foodLisAppBar(),
      body: Column(
        children: [
          Hero(
              tag: "mainImage${widget.position}",
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 250),
                height: 150.0,
                width: MediaQuery
                    .of(context)
                    .size
                    .width,
                decoration: BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage(images[widget.position]),
                        fit: BoxFit.cover
                    )
                ),
                child: Container(color: const Color.fromRGBO(255, 100, 100, 0.5),),
              )),
          Expanded(child: Body(position: widget.position,)),
        ],
      ),
    );
  }

  void searchAction() {
    // TODO add search action
  }

  AppBar foodLisAppBar(){
    return AppBar(
      title: Center(
        child: Container(
          height: 100.0,
          width: 250.0,
          alignment: const Alignment(-1.0, 0.0),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 375),
            height: 48.0,
            width: (toggle == 0) ? 48.0 : 250.0,
            curve: Curves.easeOut,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(30.0),
            ),
            child: Stack(
              children: [
                AnimatedPositioned(
                  duration: const Duration(milliseconds: 375),
                  top: 6.0,
                  right: 7.0,
                  curve: Curves.easeOut,
                  child: AnimatedOpacity(
                    opacity: (toggle == 0) ? 0.0 : 1.0,
                    duration: const Duration(milliseconds: 200),
                    child: Container(
                      padding: const EdgeInsets.all(8.0),
                      decoration: BoxDecoration(
                        color: const Color(0xffF2F3F7),
                        borderRadius: BorderRadius.circular(30.0),
                      ),
                      child: AnimatedBuilder(
                        builder: (context, widget) {
                          return Transform.rotate(
                            angle: _con.value * 2.0 * pi,
                            child: widget,
                          );
                        },
                        animation: _con,
                        child: const Icon(
                          Icons.mic,
                          size: 20.0,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ),
                ),
                AnimatedPositioned(
                  duration: const Duration(milliseconds: 375),
                  left: (toggle == 0) ? 20.0 : 35.0,
                  curve: Curves.easeOut,
                  top: 11.0,
                  child: AnimatedOpacity(
                    opacity: (toggle == 0) ? 0.0 : 1.0,
                    duration: const Duration(milliseconds: 200),
                    child: SizedBox(
                      height: 23.0,
                      width: 180.0,
                      child: TextField(
                        controller: _textEditingController,
                        cursorRadius: const Radius.circular(10.0),
                        cursorWidth: 2.0,
                        cursorColor: Colors.black,
                        decoration: InputDecoration(
                          floatingLabelBehavior: FloatingLabelBehavior.never,
                          labelText: "    ${AppLocalizations.of(context)!.translate("Search")} ...",
                          labelStyle: const TextStyle(
                            color: Color(0xff5B5B5B),
                            fontSize: 17.0,
                            fontWeight: FontWeight.w500,
                          ),
                          alignLabelWithHint: true,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20.0),
                            borderSide: BorderSide.none,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                Material(
                  color: mPrimaryColor,
                  borderRadius: BorderRadius.circular(30.0),
                  child: IconButton(
                    splashRadius: 19.0,
                    icon: const Icon(Icons.search, color: Colors.white,),
                    onPressed: () {
                      setState(
                            () {
                          if (toggle == 0) {
                            toggle = 1;
                            _con.reverse();
                            searchAction();
                          } else {
                            toggle = 0;
                            _textEditingController.clear();
                            _con.forward();
                          }
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}