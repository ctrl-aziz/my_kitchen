import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:my_kitchen/models/user.dart';

class UserDatabaseService {
  final String uid;

  final CollectionReference userCollection = FirebaseFirestore.instance.collection("users");

  UserDatabaseService({required this.uid});

  Future updateUserData(String name, String image, List<String> likes, List<String> foods, List<String> favorites, List<String> followers) async{
    var currentUser = await userCollection.doc(uid).get();
    if(currentUser.exists){
      debugPrint("is exist");
    }else{
      debugPrint("is not exist");
      return await userCollection.doc(uid).set({
        'name': name,
        'image': image,
        'likes': likes,
        'foods': foods,
        'favorites': favorites,
        'followers': followers
      });
    }
  }

  Future deleteFoodData({required String target, required String value}) async{
    DocumentReference docRef = userCollection.doc(uid);
    DocumentSnapshot doc = await docRef.get();
    debugPrint(target);
    debugPrint(value);
    debugPrint(uid);
    List docCon = doc.get(target);
    debugPrint(docCon.toString());
    debugPrint(docCon.contains(value).toString());
    if(docCon.contains(value)){
      return await docRef.update({
        target: FieldValue.arrayRemove([value]),
      });
    }
  }

  Future updateUserDataByOne({required String target, required String value}) async{
    DocumentReference docRef = userCollection.doc(uid);
    DocumentSnapshot doc = await docRef.get();
    debugPrint(target);
    debugPrint(value);
    debugPrint(uid);
    List docCon = doc.get(target);
    debugPrint(docCon.toString());
    debugPrint(docCon.contains(value).toString());
    if(target == 'foods'){
      if(!docCon.contains(value)){
        return await docRef.update({
          target: FieldValue.arrayUnion([value]),
        });
      }
    }else{
      if(docCon.contains(value)){
        return await docRef.update({
          target: FieldValue.arrayRemove([value]),
        });
      }else{
        return await docRef.update({
          target: FieldValue.arrayUnion([value]),
        });
      }
    }
  }

  List<UserData> _userListFromSnapshot(QuerySnapshot snapshot){
    return snapshot.docs.map((doc){
      return UserData(
        name: doc.get('name') ?? '',
        image: doc.get('image') ?? '',
        likes: List.from(doc.get('likes')),
        foods: List.from(doc.get('foods')),
        favorites: List.from(doc.get('favorites')),
        followers: List.from(doc.get('followers')),
      );
    }).toList();
  }

  Stream<List<UserData>> get allUsers{
    return userCollection.snapshots()
        .map(_userListFromSnapshot);
  }

  UserData _userDataFromSnapshot(DocumentSnapshot snapshot){
    return UserData(
        uid: uid,
        name: snapshot.get('name'),
        image: snapshot.get('image'),
        likes: List.from(snapshot.get('likes')),
        foods: List.from(snapshot.get('foods')),
        favorites: List.from(snapshot.get('favorites')),
        followers: List.from(snapshot.get('followers'))
    );
  }



  Stream<UserData> get userData{
    return userCollection.doc(uid).snapshots().map(_userDataFromSnapshot);
  }

}