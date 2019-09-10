import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LastUpdateTime{

  String id;
  Map<String, dynamic> lastUpdatedOn;

  LastUpdateTime({ this.id, this.lastUpdatedOn});


  factory LastUpdateTime.fromJson(Map<String, dynamic> json){
    return LastUpdateTime(
      id: json['id'],
      lastUpdatedOn: json['lastUpdatedOn'],
    );
  }

  Map<String, dynamic> toJson() =>
    {
      'id': id,
      'lastUpdatedOn': lastUpdatedOn,
    };


  factory LastUpdateTime.fromFirestore(DocumentSnapshot documentSnapshot){
    Map data = documentSnapshot.data;
    String id = documentSnapshot.documentID;
    // print('ProductId : $id');
    return LastUpdateTime(
      id: id,
      lastUpdatedOn: data
    );
  }

}



class LastUpdateTimeService extends ChangeNotifier {
  final Firestore _db = Firestore.instance;

  LastUpdateTimeService.instance();

  /// Get a stream of a single document
   saveLastUpdateTime() async{
     SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
     String cityId =sharedPreferences.get('cityId');
    _db
        .collection('data_update')
        .document(cityId)
        .snapshots()
        .map((snapshot) => LastUpdateTime.fromFirestore(snapshot))
        .listen((onData){
          sharedPreferences.setString('lastUpdateTime', jsonEncode(onData));
        });
  }


  Future<LastUpdateTime> getLastUpdateTime(String id) async{
     SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    
      print('Hello from getProducts of ProdutService');
      dynamic data = await jsonDecode(sharedPreferences.getString('lastUpdateTime'));
      LastUpdateTime lastUpdateTime = LastUpdateTime.fromJson(data);
      return lastUpdateTime;
  }


  /// Get a stream of a single document
  Stream<LastUpdateTime> streamLastUpdateTime(String id) {
    return _db
        .collection('data_update')
        .document(id)
        .snapshots()
        .map((snapshot) => LastUpdateTime.fromFirestore(snapshot));
  }

  Stream<List<LastUpdateTime>> streamLastUpdateTimeList(){
    return _db
        .collection('data_update')
        .snapshots()
        .map((QuerySnapshot querySnapshot) => querySnapshot.documents.map((DocumentSnapshot documentSnapshot) => LastUpdateTime.fromFirestore(documentSnapshot)).toList());
        
  }
}