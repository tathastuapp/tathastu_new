import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

class Product{

  String id;
  String englishName;
  String gujaratiName;
  String photoUrl;
  bool isOrganic;
  String type;
  String minimumQuantityUnit;
  num minimumQuantity;
  num minimumQuantityPrice;
  bool isAvailable;

  Product({ this.id, this.englishName, this.gujaratiName, this.photoUrl, this.isOrganic, this.type, this.minimumQuantityUnit, this.minimumQuantity, this.minimumQuantityPrice, this.isAvailable });

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
      minimumQuantityPrice: data['min_quantity_price'],
      isAvailable: data['is_available']
    );
  }

}



class ProductService extends ChangeNotifier {
  final Firestore _db = Firestore.instance;

  ProductService.instance();

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
        
  }
}