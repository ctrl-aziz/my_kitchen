

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:my_kitchen/models/foods.dart';

class FoodDatabaseService {
  final String fid;

  final CollectionReference foodCollection = FirebaseFirestore.instance.collection("foods");

  FoodDatabaseService({this.fid});

  deleteFoodData(String fid) async{
    await foodCollection.doc(fid).delete();
  }

  Future updateFoodData(
      {String infid, String name, String image, String owner, List<
          String> content, List<String> howToDo, List<String> favorite, List<
          String> like, List<String> country}) async{
    return await foodCollection.doc(fid).set({
      'infid': infid,
      'name': name,
      'image': image,
      'owner': owner,
      'content': content,
      'howtodo': howToDo,
      'favorite': favorite,
      'like': like,
      'country': country
    });
  }
  Future updateFavoriteFood({String target, String value}) async{
    DocumentReference docRef = foodCollection.doc(fid);
    DocumentSnapshot doc = await docRef.get();
    List docCon = doc.data()[target];
    print(docCon);
    print(docCon.contains(value));
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

  List<FoodsData> _foodListFromSnapshot(QuerySnapshot snapshot){
    return snapshot.docs.map((doc){
      return FoodsData(
        infid: doc.data()['infid'] ?? '',
        name: doc.data()['name'] ?? '',
        image: doc.data()['image'] ?? '',
        owner: doc.data()['owner'],
        content: List.from(doc.data()['content']) ?? '',
        howToDo: List.from(doc.data()['howtodo']) ?? '',
        favorite: List.from(doc.data()['favorite']) ?? '',
        like: List.from(doc.data()['like']) ?? '',
        country: List.from(doc.data()['country']),
      );
    }).toList();
  }

  Stream<List<FoodsData>> get allFoods{
    return foodCollection.snapshots()
        .map(_foodListFromSnapshot);
  }

  FoodsData _foodDataFromSnapshot(DocumentSnapshot snapshot){
    // print("vvvv $fid");
    return FoodsData(
      fid: fid,
      infid: snapshot.data()['infid'],
      name: snapshot.data()['name'],
      image: snapshot.data()['image'],
      owner: snapshot.data()['owner'],
      content: List.from(snapshot.data()['content']),
      howToDo: List.from(snapshot.data()['howtodo']),
      favorite: List.from(snapshot.data()['favorite']),
      like: List.from(snapshot.data()['like']),
      country: List.from(snapshot.data()['country']),
    );
  }



  Stream<FoodsData> get foodData{
    return foodCollection.doc(fid).snapshots().map(_foodDataFromSnapshot);
  }

}