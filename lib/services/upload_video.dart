import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

final FirebaseFirestore _firestore= FirebaseFirestore.instance; 
final FirebaseStorage _storage =FirebaseStorage.instance;
class StoreData{

  Future<String> uploadVideo(String url) async{
    Reference ref= _storage.ref().child('videos/${DateTime.now()}.mp4');
    await ref.putFile(File(url));
    String DowloadUrl= await ref.getDownloadURL();
    return DowloadUrl;
  }
  Future <void> saveVideoData({String? VideodownlodedUrl, String? Title,String? Description,String?location,String? Category})async{
    await _firestore.collection('videos').add({
      "title": Title,
      "url": VideodownlodedUrl,
      "timestamp": FieldValue.serverTimestamp(),
      "description":Description,
      "location": location,
      "category":Category
      
    });
  }
}