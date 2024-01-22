import 'dart:io' as io;

import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:flutter/cupertino.dart';


class UploadImageHelper{
  //firebase_storage.UploadTask _uploadTasks;
  String? imageUrl;

  Future<void> uploadFile(io.File? file, String folderName, String fileName) async {
    if (file == null) {
      debugPrint("No file was selected");
      return;
    }

    //firebase_storage.UploadTask uploadTask;

    // Create a Reference to the file
    firebase_storage.Reference ref = firebase_storage.FirebaseStorage.instance
        .ref()
        .child(folderName)
        .child('/$fileName.jpg');

    final metadata = firebase_storage.SettableMetadata(
        contentType: 'image/jpeg',
        customMetadata: {'picked-file-path': file.path});

      await ref.putFile(io.File(file.path), metadata);
    var link = await ref.getDownloadURL();
    imageUrl = link;
    debugPrint("this is link $link");
  }

  Future<void> deleteFile(String path){
    return firebase_storage.FirebaseStorage.instance.refFromURL(path).delete();
  }
}