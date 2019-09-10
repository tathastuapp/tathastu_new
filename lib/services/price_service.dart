import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Price{

  String id;
  Map<String, dynamic> pricePerKg;

  Price({ this.id, this.pricePerKg});

  factory Price.fromJson(Map<String, dynamic> json){
    return Price(
      id: json['id'],
      pricePerKg: json['price_per_kg'],
    );
  }

  Map<String, dynamic> toJson() =>
    {
      'id': id,
      'price_per_kg': pricePerKg,
    };

  factory Price.fromFirestore(DocumentSnapshot documentSnapshot){
    Map data = documentSnapshot.data;
    String id = documentSnapshot.documentID;
    // print('Price ID : $id  and Price Data : $data');
    return Price(
      id: id,
      pricePerKg: data
    );
  }

}



class PriceService extends ChangeNotifier {
  final Firestore _db = Firestore.instance;

  PriceService.instance();


  /// Get a stream of a single document
  //  savePrice() async{
  //    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
  //    String cityId = 'JM9kFy8LUuZiOAoaTPcz';
  //   _db
  //       .collection('prices')
  //       .document(cityId)
  //       .snapshots()
  //       .map((DocumentSnapshot documentSnapshot) {
  //           return Price.fromFirestore(documentSnapshot);  
  //       })
  //       .listen((onValue){
  //         // print(onValue.pricePerKg);
  //         sharedPreferences.setString('prices', jsonEncode(onValue));
  //       });
        
  // }


  Future<Price> getPrice() async{
     SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    
      print('Hello from getProducts of PriceService');
      dynamic data = await  jsonDecode(sharedPreferences.getString('prices'));
      // print(data);
      Price price = Price.fromJson(data);
      return price;
  }


  /// Get a stream of a single document
  Stream<DocumentSnapshot> streamPrice() {
    String cityId = 'JM9kFy8LUuZiOAoaTPcz';
    return _db
        .collection('prices')
        .document(cityId)
        .snapshots()
        .map((snapshot) => snapshot);
        // .map((snapshot) => Price.fromFirestore(snapshot));
  }

  Stream<List<Price>> streamPriceList(){
    return _db
        .collection('prices')
        .snapshots()
        .map((QuerySnapshot querySnapshot) => querySnapshot.documents.map((DocumentSnapshot documentSnapshot) => Price.fromFirestore(documentSnapshot)).toList());
        
  }
}