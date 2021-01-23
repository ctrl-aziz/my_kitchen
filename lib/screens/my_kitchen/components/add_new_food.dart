import 'dart:async';
import 'dart:io' as io;

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:my_kitchen/extensions/constants.dart';
import 'package:my_kitchen/extensions/data.dart';
import 'package:my_kitchen/localizations/app_localizations.dart';
import 'package:my_kitchen/models/foods.dart';
import 'package:my_kitchen/models/user.dart';
import 'package:my_kitchen/services/database/foods_database.dart';
import 'package:my_kitchen/services/database/user_database.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:showcaseview/showcaseview.dart';
import 'package:uuid/uuid.dart';

import 'upload_image_helper.dart';


class AddNewFood extends StatefulWidget {
  final position;

  const AddNewFood({Key key, this.position}) : super(key: key);
  @override
  _AddNewFoodState createState() => _AddNewFoodState(this.position);
}

class _AddNewFoodState extends State<AddNewFood> with UploadImageHelper {
  final position;
  final keyOne = GlobalKey();
  final keyTow = GlobalKey();
  final keyThree = GlobalKey();
  final keyFour = GlobalKey();

  io.File _selectedFile;
  NetworkImage _networkImage;

  bool _inProcess = false;

  List<String> contentList = [];
  List<String> howToDoList = [];
  List<String> countryList = [];
  List<String> favorite = [];
  List<String> like = [];



  List<TextEditingController> _contentControllers = new List();
  List<TextEditingController> _howToDoControllers = new List();
  final _foodNameController = TextEditingController();

  List<bool> _contentSwitchEdit = new List();
  List<bool> _howToDoSwitchEdit = new List();

  List<bool> _selected = List.generate(2, (_) => false);

  var uuid = Uuid();

  var fid;

  DateTime currentBackPressTime;

  FocusNode myFocusNode;

  _AddNewFoodState(this.position);

  Future checkFirstSeen() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool _seen = (prefs.getBool('Add_tut') ?? false);

    if (_seen) {
      print("Not First Time");
    } else {
      prefs.setBool('Add_tut', true);
      WidgetsBinding.instance.addPostFrameCallback((_) => ShowCaseWidget.of(context).startShowCase([
        keyOne,
        keyTow,
        keyThree,
        keyFour,
      ]));
      print("First Time User");
    }
  }

  @override
  void initState() {
    new Timer(new Duration(milliseconds: 200), () {
      checkFirstSeen();
    });
    _selected[0] = true;
    fid = uuid.v1();
    myFocusNode = FocusNode();
    super.initState();
  }

  @override
  void dispose() {
    _contentControllers.forEach((element) {
      element.dispose();
    });
    _howToDoControllers.forEach((element) {
      element.dispose();
    });
    myFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final _user = Provider.of<AppUser>(context);

    AppLocalizations translate = AppLocalizations.of(context);
    TextTheme textTheme = Theme
        .of(context)
        .textTheme;
    Size size = MediaQuery
        .of(context)
        .size;

    if (_user == null) return Align(
        alignment: Alignment.center, child: CircularProgressIndicator());
    print(_user.uid);
    print(like);
    print(favorite);
    print("uniqueKey $fid");
    return WillPopScope(
      onWillPop: onWillPop,
      child: SingleChildScrollView(
        child: StreamBuilder<UserData>(
            stream: UserDatabaseService(uid: _user.uid).userData,
            builder: (context, userSnapshot) {
              if (!userSnapshot.hasData) return Material(
                child: Center(child: CircularProgressIndicator(),),);
              return StreamBuilder<FoodsData>(
                stream: FoodDatabaseService(fid: position).foodData,
                builder: (context, foodSnapshot) {
                  if(foodSnapshot.hasData){
                    fid = foodSnapshot.data.infid;
                    _networkImage = NetworkImage(foodSnapshot.data.image);
                    _foodNameController.text = foodSnapshot.data.name;
                    imageUrl = foodSnapshot.data.image;
                    print("Key ${like.isEmpty}");
                    if(contentList.isEmpty){
                      contentList.addAll(foodSnapshot.data.content);
                    }
                    if(countryList.isEmpty){
                      countryList.addAll(foodSnapshot.data.country);
                    }
                    if(howToDoList.isEmpty){
                      howToDoList.addAll(foodSnapshot.data.howToDo);
                    }
                    if(favorite.isEmpty){
                      favorite.addAll(foodSnapshot.data.favorite);
                    }
                    if(like.isEmpty){
                      like.addAll(foodSnapshot.data.like);
                    }

                  }
                  return Column(
                    children: [
                      /// Select food image
                      CustomShowcaseWidget(
                        globalKey: keyOne,
                        description: "أختر صورة لطبختك",
                        child: Container(
                          child: Stack(
                            children: [
                              InkWell(
                                child: _selectedFile == null
                                    ?
                                (
                                    _networkImage == null
                                        ?
                                    Container(
                                  width: size
                                      .width,
                                  height: 150,
                                  child: Center(
                                      heightFactor: 2.0, child: Container(child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(Icons.image, size: 75.0,),
                                      Text("${translate.translate("Choose image")}",
                                        style: Theme
                                            .of(context)
                                            .textTheme
                                            .subtitle1,)
                                    ],
                                  ))
                                  ),
                                )
                                    :
                                    Container(
                                      width: size
                                          .width,
                                      height: 200,
                                      alignment: Alignment.center,
                                      margin: EdgeInsets.all(0.0),
                                      decoration: BoxDecoration(
                                          image: DecorationImage(
                                              image: _networkImage,
                                              fit: BoxFit.cover
                                          )
                                      ),
                                      child: Container(
                                          width: size
                                              .width,
                                          height: 200,
                                          alignment: Alignment.center,
                                          decoration: BoxDecoration(
                                            color: mBrownColor,
                                          ),
                                          child: Text("")
                                      ),
                                    )
                                )
                                    :
                                Container(
                                  width: size
                                      .width,
                                  height: 200,
                                  alignment: Alignment.center,
                                  margin: EdgeInsets.all(0.0),
                                  decoration: BoxDecoration(
                                      image: DecorationImage(
                                          image: FileImage(_selectedFile),
                                          fit: BoxFit.cover
                                      )
                                  ),
                                  child: Container(
                                      width: size
                                          .width,
                                      height: 200,
                                      alignment: Alignment.center,
                                      decoration: BoxDecoration(
                                        color: mBrownColor,
                                      ),
                                      child: Text("")
                                  ),
                                ),
                                onTap: () {
                                  _chooseCameraOrGallery(context);
                                },
                              ),
                              (_selectedFile != null || _networkImage != null) ? Positioned(
                                right: size.width / 7,
                                left: size.width / 5,
                                top: 30.0,
                                child: Container(
                                  alignment: Alignment.center,
                                  width: size.width * .6,
                                  padding: EdgeInsets.only(right: mDefaultPadding / 3),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                    children: [
                                      TextField(
                                        controller: _foodNameController,
                                        autofocus: true,
                                        decoration: InputDecoration(
                                          border: InputBorder.none,
                                          hintText: '${translate.translate(
                                              "Food Name")}',
                                          hintStyle: Theme
                                              .of(context)
                                              .textTheme
                                              .headline5
                                              .copyWith(color: mWhiteColor,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        style: Theme
                                            .of(context)
                                            .textTheme
                                            .headline5
                                            .copyWith(color: mWhiteColor,
                                            fontWeight: FontWeight.bold),
                                        textAlign: TextAlign.center,
                                        onChanged: (value) {

                                        },
                                      ),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Text("${translate.translate("By")} ",
                                            style: textTheme.subtitle2.copyWith(
                                                color: mWhiteColor),),
                                          Text("${userSnapshot.data.name}",
                                            style: textTheme.subtitle2.copyWith(
                                                color: mWhiteColor),),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ) : Container(),
                              (_inProcess) ? Center(
                                child: Container(
                                  color: mWhiteColor,
                                  height: size
                                      .height * 0.87,
                                  child: Center(
                                    child: CircularProgressIndicator(),
                                  ),
                                ),
                              ) : Center()
                            ],
                          ),
                        ),
                      ),
                      /// Fill foods information
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: mDefaultPadding*0.5, vertical: 00.0),
                        height: 550.0,
                        color: mBackgroundColor,
                        child: Column(
                          children: [
                            /// Fill Countries details
                            CustomShowcaseWidget(
                              globalKey: keyTow,
                              description: "أختر البلد المتواجد فيها هذه الطبخة",
                              child: Container(
                                  height: 100.0,
                                  child: Column(
                                    children: [
                                      Container(
                                        child: Text("${translate.translate(
                                            "Choose food's countries")}", style: Theme
                                            .of(context)
                                            .textTheme
                                            .headline6,),
                                        alignment: Alignment.centerRight,
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: mDefaultPadding*0.75),
                                      ),
                                      Container(
                                        height: 50.0,
                                        child: ListView.builder(
                                            itemCount: title.length,
                                            scrollDirection: Axis.horizontal,
                                            itemBuilder: (context, index) {
                                              return Padding(
                                                padding: const EdgeInsets.symmetric(
                                                    horizontal: mDefaultPadding*0.25, vertical: mDefaultPadding*0.25),
                                                child: FlatButton(
                                                  child: Text(translate.translate("${title[index]}")),
                                                  color: (countryList.contains(
                                                      reCountries[title[index]]))
                                                      ? mWhiteColor
                                                      : mGrayColor[300],
                                                  shape: RoundedRectangleBorder(
                                                      borderRadius: BorderRadius
                                                          .circular(20.0)
                                                  ),
                                                  onPressed: () {
                                                    if (!countryList.contains(
                                                        reCountries[title[index]])) {
                                                      setState(() {
                                                        countryList.add(
                                                            reCountries[title[index]]);
                                                      });
                                                    } else {
                                                      print(index);
                                                      print(countryList);
                                                      setState(() {
                                                        countryList.remove(
                                                            reCountries[title[index]]);
                                                      });
                                                    }
                                                  },
                                                ),
                                              );
                                            }),
                                      ),
                                    ],
                                  )
                              ),
                            ),
                            /// Fill Food Content list
                            /// Fill howToDo list
                            Center(
                              child: ToggleButtons(
                                children: [
                                  Text("${translate.translate("Content")}",
                                    style: TextStyle(fontFamily: "Cairo"),),
                                  Text("${translate.translate("How To Do")}",
                                    style: TextStyle(fontFamily: "Cairo"),),
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
                                      if(howToDoList.contains("")){
                                        howToDoList.remove("");
                                      }
                                    });
                                  } else if (value == 1) {
                                    setState(() {
                                      _selected[0] = false;
                                      _selected[1] = true;
                                      if(contentList.contains("")){
                                        contentList.remove("");
                                      }
                                    });
                                  }
                                  // print(_selected);
                                },
                              ),
                            ),
                            SizedBox(height: 3.0,),
                            CustomShowcaseWidget(
                              globalKey: keyThree,
                              description: "أضف المكونات و كيفية تحضير طبختك هنا",
                              child: Container(
                                  width: size
                                      .width,
                                  height: 320,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.all(Radius.circular(
                                        9.0)),
                                    color: mWhiteColor,
                                  ),
                                  child: (_selected[0] && !_selected[1])
                                      ? content(translate)
                                      : howToDo(translate)
                              ),
                            ),
                            SizedBox(height: 10.0,),
                            /// Send data to database and storage
                            /// if [FoodDatabaseService()] content are fill
                            CustomShowcaseWidget(
                              globalKey: keyFour,
                              description: "عند الانتهاء شارك طبختك لكي يعرف عنها الجميع",
                              child: RaisedButton(
                                  color: mPrimaryColor,
                                  splashColor: mPrimaryColor.withOpacity(0.5),
                                  highlightColor: mPrimaryColor.withOpacity(0.5),
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(18.0),
                                      side: BorderSide(color: mPrimaryColor)
                                  ),
                                  padding: EdgeInsets.symmetric(
                                      horizontal: mDefaultPadding*5, vertical: 1.0),
                                  child: Text(
                                    "${translate.translate("Share")}", style: Theme
                                      .of(context)
                                      .textTheme
                                      .headline5
                                      .copyWith(color: mWhiteColor,
                                      fontWeight: FontWeight.bold),),
                                  onPressed: () async{
                                    if (_selectedFile != null) {
                                      await uploadFile(_selectedFile, _user.uid, fid);
                                    }
                                    if (contentList.isNotEmpty &&
                                        howToDoList.isNotEmpty &&
                                        _user != null) {
                                      if(contentList.contains("")){
                                        setState(() {
                                          contentList.remove("");
                                        });
                                      }
                                      if(howToDoList.contains("")){
                                        setState(() {
                                          howToDoList.remove("");
                                        });
                                      }
                                      print(_user.uid);
                                      if(imageUrl == null){
                                        Fluttertoast.showToast(msg: "جار التحميل اضغط مرة اخرى للحفظ");
                                      }else{
                                        Fluttertoast.showToast(msg: "جار المشاركة...", toastLength: Toast.LENGTH_SHORT);
                                        UserDatabaseService(uid: _user.uid)
                                            .updateUserDataByOne(
                                            target: 'foods',
                                            value: fid
                                        );
                                        FoodDatabaseService(fid: fid).updateFoodData(
                                            infid: fid,
                                            name: _foodNameController.text,
                                            image: imageUrl,
                                            owner: userSnapshot.data.name,
                                            content: contentList,
                                            howToDo: howToDoList,
                                            favorite: favorite,
                                            like: like,
                                            country: countryList
                                        );
                                      }

                                      Scaffold.of(context).showSnackBar(
                                          SnackBar(
                                            content: Text("${translate.translate(
                                                "Food added successfully")}",
                                              style: TextStyle(color: mTextColor),
                                              textAlign: TextAlign.center,),
                                            duration: Duration(seconds: 1),
                                            backgroundColor: mWhiteColor,
                                          )
                                      );
                                      Navigator.pop(context);
                                    } else {
                                      Scaffold.of(context).showSnackBar(
                                          SnackBar(
                                            shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.only(
                                                  topLeft: Radius.circular(20.0),
                                                  topRight: Radius.circular(20.0)),
                                            ),
                                            content: Text("${translate.translate(
                                                "Please fill all fields")}",
                                              style: TextStyle(color: mTextColor),
                                              textAlign: TextAlign.center,),
                                            duration: Duration(seconds: 1),
                                            backgroundColor: mWhiteColor,
                                          )
                                      );
                                    }
                                  }
                              ),
                            )
                          ],
                        ),
                      ),
                    ],
                  );
                }
              );
            }
        ),
      ),
    );


  }

  Future<bool> onWillPop() {
    DateTime now = DateTime.now();
    if (currentBackPressTime == null ||
        now.difference(currentBackPressTime) > Duration(seconds: 2)) {
      currentBackPressTime = now;
      Fluttertoast.showToast(msg: "اضغط مرة اخرى للخروج");
      return Future.value(false);
    }
    return Future.value(true);
  }


  Column content(AppLocalizations translate) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Container(
            height: 250.0,
            child: ReorderableListView(
              children: List.generate(contentList.length, (index) {
                _contentControllers.add(new TextEditingController());
                _contentSwitchEdit.add(false);
                return ListTile(
                    key: UniqueKey(),
                    leading: Text("${index + 1}. "),
                    title: (contentList[index] != null &&
                        contentList[index] != "" && !_contentSwitchEdit[index])
                        ?
                    Container(
                      child: Text(contentList[index]),
                    )
                        :
                    TextField(
                      controller: _contentControllers[index],
                      autofocus: true,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: '${translate.translate("Add Content")}',
                        hintStyle: TextStyle(
                            fontSize: 14, fontWeight: FontWeight.w600),
                      ),
                      style: TextStyle(
                          fontSize: 14, fontWeight: FontWeight.w600),
                      onSubmitted: (value) {
                        if (value != null && value != "") {
                          if (!_contentSwitchEdit[index]) {
                            setState(() {
                              contentList.insert(index, value);
                            });
                          }
                          else {
                            setState(() {
                              contentList[index] = value;
                              _contentSwitchEdit[index] = false;
                            });
                          }
                        }
                      },
                    ),
                    trailing: Container(
                      width: MediaQuery
                          .of(context)
                          .size
                          .width / 7.5 * 1.7,
                      child: Row(
                        children: [
                          Flexible(
                            flex: 1,
                            child: IconButton(
                              padding: EdgeInsets.all(0),
                              icon: Icon(
                                Icons.edit, size: 25.0,
                                color: mGreenColor.shade300,),
                              onPressed: () {
                                print("Edit");
                                setState(() {
                                  _contentSwitchEdit[index] =
                                  !_contentSwitchEdit[index];
                                });
                              },
                            ),
                          ),
                          Flexible(
                            flex: 1,
                            child: IconButton(
                              icon: Icon(Icons.delete),
                              color: mPrimaryColor,
                              iconSize: 25.0,
                              onPressed: () {
                                print("Delete");
                                print(index);
                                if (contentList.length > 1) {
                                  setState(() {
                                    contentList.removeAt(index);
                                    _contentControllers.removeAt(index);
                                  });
                                }
                              },
                            ),
                          ),
                        ],
                      ),
                    )
                );
              }),
              onReorder: (int oldIndex, int newIndex) {
                setState(() {
                  if (newIndex > oldIndex) {
                    newIndex -= 1;
                  }
                  final String newString = contentList.removeAt(oldIndex);
                  contentList.insert(newIndex, newString);
                });
              },
            )
        ),
        Divider(),
        GestureDetector(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("${translate.translate("Add")}"),
              Icon(Icons.add),
            ],
          ),
          onTap: () {
            if (!contentList.contains("")) {
              setState(() {
                contentList.add("");
              });
            }
          },
        )
      ],
    );
  }

  Column howToDo(AppLocalizations translate) {
    print("how To Do $howToDoList");
    return Column(
      children: [
        Container(
            height: 250.0,
            child: ReorderableListView(
              children: List.generate(howToDoList.length, (index) {
                _howToDoControllers.add(new TextEditingController());
                _howToDoSwitchEdit.add(false);
                print(
                    howToDoList[index].contains(
                        _howToDoControllers[index].text));
                return ListTile(
                    key: UniqueKey(),
                    leading: Text("${index + 1}. "),
                    title: (howToDoList[index] != null &&
                        howToDoList[index] != "" &&
                        !_howToDoSwitchEdit[index])
                        ?
                    Container(
                      child: Text(howToDoList[index]),) : TextField(
                      controller: _howToDoControllers[index],
                      autofocus: true,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: '${translate.translate("Add How To Do")}',
                        hintStyle: TextStyle(
                            fontSize: 14, fontWeight: FontWeight.w600),
                      ),
                      style: TextStyle(
                          fontSize: 14, fontWeight: FontWeight.w600),
                      onSubmitted: (value) {
                        if (value != null && value != "") {
                          if (!_howToDoSwitchEdit[index]) {
                            setState(() {
                              howToDoList.insert(index, value);
                            });
                          }
                          else {
                            setState(() {
                              howToDoList[index] = value;
                              _howToDoSwitchEdit[index] = false;
                            });
                          }
                        }
                      },

                    ),
                    trailing: Container(
                      width: MediaQuery
                          .of(context)
                          .size
                          .width / 7.5 * 1.7,
                      child: Row(
                        children: [
                          Flexible(
                            flex: 1,
                            child: IconButton(
                              padding: EdgeInsets.all(0),
                              icon: Icon(
                                Icons.edit, size: 25.0,
                                color: mGreenColor.shade300,),
                              onPressed: () {
                                print("Edit");
                                setState(() {
                                  _howToDoSwitchEdit[index] =
                                  !_howToDoSwitchEdit[index];
                                });
                              },
                            ),
                          ),
                          Flexible(
                            flex: 1,
                            child: IconButton(
                              icon: Icon(Icons.delete),
                              color: mPrimaryColor,
                              iconSize: 25.0,
                              onPressed: () {
                                print("Delete");
                                print(index);
                                if (howToDoList.length > 1) {
                                  setState(() {
                                    howToDoList.removeAt(index);
                                    _howToDoControllers.removeAt(index);
                                  });
                                }
                              },
                            ),
                          ),
                        ],
                      ),
                    )
                );
              }),
              onReorder: (int oldIndex, int newIndex) {
                setState(() {
                  if (newIndex > oldIndex) {
                    newIndex -= 1;
                  }
                  final String newString = howToDoList.removeAt(oldIndex);
                  howToDoList.insert(newIndex, newString);
                });
              },
            )
        ),
        Divider(),
        GestureDetector(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("${translate.translate("Add")}"),
              Icon(Icons.add),
            ],
          ),
          onTap: () {
            if (!howToDoList.contains("")) {
              setState(() {
                howToDoList.add("");
              });
            }
          },
        )
      ],
    );
  }

  /// Get and crop selected image
  getImage(ImageSource source) async {
    AppLocalizations translate = AppLocalizations.of(context);
    this.setState(() {
      _inProcess = true;
    });
    PickedFile image = await ImagePicker().getImage(source: source);
    if (image != null) {
      io.File cropped = await ImageCropper.cropImage(
          sourcePath: image.path,
          aspectRatio: CropAspectRatio(
              ratioX: 2, ratioY: 1),
          compressQuality: 100,
          maxWidth: 700,
          maxHeight: 700,
          compressFormat: ImageCompressFormat.jpg,
          androidUiSettings: AndroidUiSettings(
            toolbarColor: mPrimaryColor,
            toolbarTitle: "${translate.translate("Edit image")}",
            statusBarColor: mPrimaryColor,
            backgroundColor: mWhiteColor,
          )
      );

      this.setState(() {
        _selectedFile = cropped;
        _inProcess = false;
      });
    } else {
      this.setState(() {
        _inProcess = false;
      });
    }
  }

  /// Select way to pick image (from Camera or Gallery)
  void _chooseCameraOrGallery(BuildContext context) {
    AppLocalizations translate = AppLocalizations.of(context);
    // getImage(ImageSource.gallery);
    showModalBottomSheet(context: context, builder: (builder) {
      final Size size = MediaQuery
          .of(builder)
          .size;
      return new Container(
        height: 150.0,
        color: Colors.transparent,
        child: Column(
          children: [
            Flexible(
              flex: 1,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: size.width / 12),
                child: Align(
                  child: Text(
                    "${translate.translate("Open By")} :", style: Theme
                      .of(context)
                      .textTheme
                      .headline6
                      .copyWith(color: mWhiteColor),),
                  alignment: Alignment(1.0, 0.0),
                ),
              ),
            ),
            Flexible(
              flex: 3,
              child: Container(
                padding: EdgeInsets.symmetric(vertical: mDefaultPadding*0.75),
                decoration: BoxDecoration(
                    color: mWhiteColor,
                    borderRadius: new BorderRadius.only(
                        topLeft: const Radius.circular(30.0),
                        topRight: const Radius.circular(30.0)
                    )
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        IconButton(icon: Icon(
                          Icons.image, size: 50.0, color: mPrimaryColor,),
                          onPressed: () {
                            getImage(ImageSource.gallery);
                            Navigator.pop(builder);
                          },
                        ),
                        Container(margin: const EdgeInsets.only(right: 15.0),
                            alignment: Alignment.center,
                            child: Text("${translate.translate("Gallery")}",
                              textAlign: TextAlign.center,))
                      ],
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        IconButton(
                            icon: Icon(Icons.camera, size: 50.0,),
                            color: mPrimaryColor,
                            onPressed: () {
                              getImage(ImageSource.camera);
                              Navigator.pop(builder);
                            }),
                        Container(margin: const EdgeInsets.only(right: 15.0),
                            alignment: Alignment.center,
                            child: Text("${translate.translate("Camera")}",
                              textAlign: TextAlign.center,))
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      );
    });
  }
}

class CustomShowcaseWidget extends StatelessWidget {
  final Widget child;
  final String description;
  final GlobalKey globalKey;

  const CustomShowcaseWidget({
    @required this.description,
    @required this.globalKey,
    @required this.child});

  @override
  Widget build(BuildContext context) => Showcase(
    key: globalKey,
    child: child,
    description: description,
  );


}


