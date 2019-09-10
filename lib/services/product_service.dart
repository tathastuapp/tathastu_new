import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Product{

  String id;
  String englishName;
  String gujaratiName;
  String photoUrl;
  bool isOrganic;
  String type;
  String minimumQuantityUnit;
  num minimumQuantity;

  Product({ this.id, this.englishName, this.gujaratiName, this.photoUrl, this.isOrganic, this.type, this.minimumQuantityUnit, this.minimumQuantity, });

  factory Product.fromJson(Map<String, dynamic> json){
    return Product(
      id: json['id'],
      englishName: json['english_name'],
      gujaratiName: json['gujarati_name'],
      photoUrl: json['photo_url'],
      isOrganic: json['is_organic'],
      type: json['type'],
      minimumQuantityUnit: json['min_quantity_unit'],
      minimumQuantity: json['min_quantity'],
    );
  }

  Map<String, dynamic> toJson() =>
    {
      'id': id,
      'english_name': englishName,
      'gujarati_name': gujaratiName,
      'photo_url': photoUrl,
      'is_organic': isOrganic,
      'type': type,
      'min_quantity_unit': minimumQuantityUnit,
      'min_quantity': minimumQuantity,
    };
      

  factory Product.fromFirestore(DocumentSnapshot documentSnapshot){
    Map data = documentSnapshot.data;
    String id = documentSnapshot.documentID;
    // print('ProductId : $id');
    return Product(
      id: id,
      englishName: data['english_name'],
      gujaratiName: data['gujarati_name'],
      photoUrl: data['photo_url'],
      isOrganic: data['is_organic'],
      type: data['type'],
      minimumQuantityUnit: data['min_quantity_unit'],
      minimumQuantity: data['min_quantity'],
    );
  }

}



class ProductService extends ChangeNotifier {
  final Firestore _db = Firestore.instance;

  ProductService.instance();


  /// Get a stream of a single document
   saveProducts() async{
     SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    _db
        .collection('products')
        .snapshots()
        .map((QuerySnapshot querySnapshot) {
          return querySnapshot.documents.map((DocumentSnapshot documentSnapshot) {
            return Product.fromFirestore(documentSnapshot);  
          });
        })
        .listen((onValue){
          List<Product> products = onValue.toList();
          sharedPreferences.setString('products', jsonEncode(products));
        });
        
  }


  Future<List<Product>> getProducts() async{
     SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
      print('Hello from getProducts of ProdutService');
      List<dynamic> data = await  jsonDecode(sharedPreferences.getString('products'));
      List<Product> products = data.map((item){
        // print(item);
        return Product.fromJson(item);
      }).toList();
      // print('List of Products : $products');
      // print(products[0].toJson());
      return products;
  }



  /// Get a stream of a single document
  Stream<Product> streamProduct(String id) {
    return _db
        .collection('products')
        .document(id)
        .snapshots()
        .map((snapshot) => Product.fromFirestore(snapshot));
  }

  Stream<List<DocumentSnapshot>> streamProductList(){
    return _db
        .collection('products')
        .snapshots()
        .map((QuerySnapshot querySnapshot) => querySnapshot.documents.map((DocumentSnapshot documentSnapshot) => documentSnapshot).toList());
        // .map((QuerySnapshot querySnapshot) => querySnapshot.documents.map((DocumentSnapshot documentSnapshot) => Product.fromFirestore(documentSnapshot)).toList());
        
  }
}