import 'package:flutter/cupertino.dart';
import 'package:my_kitchen/services/database/user_database.dart';

class DatabaseHelper {
  final BuildContext context;
  final String uid;

  DatabaseHelper({
    required this.context,
    required this.uid,
  });

  StreamBuilder fitchData() {
    return StreamBuilder(
        stream: UserDatabaseService(uid: uid).userData,
        builder: (context, snapshot) {
          return snapshot.data;
        });
  }
}
