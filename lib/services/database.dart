import 'package:flutter/cupertino.dart';
import 'package:my_kitchen/services/database/user_database.dart';

class DatabaseHelper{
  final context;
  final uid;

  DatabaseHelper({this.context, this.uid});

  StreamBuilder fitchData() {
   return StreamBuilder(
       stream: UserDatabaseService(uid: uid).userData,
       builder: (context, snapshot){
         return snapshot.data;
       }
     );
  }
}