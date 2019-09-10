import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class IsAvailable{

  String id;
  Map<String, dynamic> isAvailable;

  IsAvailable({ this.id, this.isAvailable});

  factory IsAvailable.fromJson(Map<String, dynamic> json){
    return IsAvailable(
      id: json['id'],
      isAvailable: json['is_available'],
    );
  }

  Map<String, dynamic> toJson() =>
    {
      'id': id,
      'is_available': isAvailable,
    };

  factory IsAvailable.fromFirestore(DocumentSnapshot documentSnapshot){
    Map data = documentSnapshot.data;
    String id = documentSnapshot.documentID;
    // print('ProductId : $id');
    return IsAvailable(
      id: id,
      isAvailable: data
    );
  }

}



class IsAvailableService extends ChangeNotifier {
  final Firestore _db = Firestore.instance;

  IsAvailableService.instance();


  /// Get a stream of a single document
   saveIsAvailable() async{
     SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
     String cityId = 'JM9kFy8LUuZiOAoaTPcz';
    _db
        .collection('is_available')
        .document(cityId)
        .snapshots()
        .map((DocumentSnapshot documentSnapshot) {
            return IsAvailable.fromFirestore(documentSnapshot);  
        })
        .listen((onValue){
          IsAvailable isAvailable = onValue;
          sharedPreferences.setString('isAvailable', jsonEncode(isAvailable));
        });
        
  }


  Future<IsAvailable> getIsAvailables() async{
     SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    
      print('Hello from getProducts of IsAvailableService');
      dynamic data = await  jsonDecode(sharedPreferences.getString('isAvailable'));
      // print(data);
      IsAvailable isAvailable = IsAvailable.fromJson(data);
      return isAvailable;
  }


  /// Get a stream of a single document
  Stream<DocumentSnapshot> streamIsAvailable() {
    String cityId = 'JM9kFy8LUuZiOAoaTPcz';
    return _db
        .collection('is_available')
        .document(cityId)
        .snapshots()
        .map((snapshot) => snapshot);
        // .map((snapshot) => IsAvailable.fromFirestore(snapshot));
  }

  Stream<List<IsAvailable>> streamIsAvailableList(){
    return _db
        .collection('is_available')
        .snapshots()
        .map((QuerySnapshot querySnapshot) => querySnapshot.documents.map((DocumentSnapshot documentSnapshot) => IsAvailable.fromFirestore(documentSnapshot)).toList());
        
  }
}