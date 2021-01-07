import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:my_kitchen/models/user.dart';

class UserDatabaseService {
  final String uid;

  final CollectionReference userCollection = FirebaseFirestore.instance.collection("users");

  UserDatabaseService({this.uid});

  Future updateUserData(String name, String image, List<String> likes, List<String> foods, List<String> favorites, List<String> followers) async{
    var currentUser = await userCollection.doc(uid).get();
    if(currentUser.exists){
      print("is exist");
    }else{
      print("is not exist");
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

  Future deleteFoodData({String target, String value}) async{
    DocumentReference docRef = userCollection.doc(uid);
    DocumentSnapshot doc = await docRef.get();
    print(target);
    print(value);
    print(uid);
    List docCon = doc.data()[target];
    print(docCon);
    print(docCon.contains(value));
    if(docCon.contains(value)){
      return await docRef.update({
        target: FieldValue.arrayRemove([value]),
      });
    }
  }

  Future updateUserDataByOne({String target, String value}) async{
    DocumentReference docRef = userCollection.doc(uid);
    DocumentSnapshot doc = await docRef.get();
    print(target);
    print(value);
    print(uid);
    List docCon = doc.data()[target];
    print(docCon);
    print(docCon.contains(value));
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
        name: doc.data()['name'] ?? '',
        image: doc.data()['image'] ?? '',
        likes: List.from(doc.data()['likes']) ?? '',
        foods: List.from(doc.data()['foods']) ?? '',
        favorites: List.from(doc.data()['favorites']) ?? '',
        followers: List.from(doc.data()['followers']) ?? '',
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
        name: snapshot.data()['name'],
        image: snapshot.data()['image'],
        likes: List.from(snapshot.data()['likes']),
        foods: List.from(snapshot.data()['foods']),
        favorites: List.from(snapshot.data()['favorites']),
        followers: List.from(snapshot.data()['followers'])
    );
  }



  Stream<UserData> get userData{
    return userCollection.doc(uid).snapshots().map(_userDataFromSnapshot);
  }

}