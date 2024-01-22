import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:my_kitchen/models/foods.dart';

class FoodDatabaseService {
  final String? fid;

  final CollectionReference foodCollection = FirebaseFirestore.instance.collection("foods");

  FoodDatabaseService({this.fid});

  deleteFoodData(String fid) async {
    await foodCollection.doc(fid).delete();
  }

  Future updateFoodData({
    required String infid,
    required String name,
    required String image,
    required String owner,
    required List<String> content,
    required List<String> howToDo,
    required List<String> favorite,
    required List<String> like,
    required List<String> country,
  }) async {
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

  Future updateFavoriteFood({required String target, required String value}) async {
    DocumentReference docRef = foodCollection.doc(fid);
    DocumentSnapshot doc = await docRef.get();
    List docCon = doc.get(target);
    print(docCon);
    print(docCon.contains(value));
    if (docCon.contains(value)) {
      return await docRef.update({
        target: FieldValue.arrayRemove([value]),
      });
    } else {
      return await docRef.update({
        target: FieldValue.arrayUnion([value]),
      });
    }
  }

  List<FoodsData> _foodListFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc) {
      return FoodsData(
        infid: doc.get('infid') ?? '',
        name: doc.get('name') ?? '',
        image: doc.get('image') ?? '',
        owner: doc.get('owner'),
        content: List.from(doc.get('content')),
        howToDo: List.from(doc.get('howtodo')),
        favorite: List.from(doc.get('favorite')),
        like: List.from(doc.get('like')),
        country: List.from(doc.get('country')),
      );
    }).toList();
  }

  Stream<List<FoodsData>> get allFoods {
    return foodCollection.snapshots().map(_foodListFromSnapshot);
  }

  FoodsData _foodDataFromSnapshot(DocumentSnapshot snapshot) {
    // print("vvvv $fid");
    return FoodsData(
      fid: fid!,
      infid: snapshot.get('infid'),
      name: snapshot.get('name'),
      image: snapshot.get('image'),
      owner: snapshot.get('owner'),
      content: List.from(snapshot.get('content')),
      howToDo: List.from(snapshot.get('howtodo')),
      favorite: List.from(snapshot.get('favorite')),
      like: List.from(snapshot.get('like')),
      country: List.from(snapshot.get('country')),
    );
  }

  Stream<FoodsData> get foodData {
    return foodCollection.doc(fid).snapshots().map(_foodDataFromSnapshot);
  }
}
