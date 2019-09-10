import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';
import 'package:tathastu/services/data_update_service.dart';
import 'package:tathastu/services/product_service.dart';
import 'package:tathastu/widgets/product.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


class ProductListWidget extends StatefulWidget {
  @override
  _ProductListWidgetState createState() => _ProductListWidgetState();
}

class _ProductListWidgetState extends State<ProductListWidget> {

  final Firestore firestore = Firestore.instance;

  
  @override
  Widget build(BuildContext context) {
  
  ProductService productService = Provider.of<ProductService>(context);
  DataUpdateService dataUpdateService = Provider.of<DataUpdateService>(context);

  return StreamBuilder<List<ProductDetail>>(
    stream: dataUpdateService.outProductDetailsList,
    // stream: firestore.collection('products').snapshots(),
    builder: (context, snapshot) {
     
      // print(snapshot.connectionState);
      // print(snapshot.hasData);
      // print(snapshot.data);
      if(snapshot.hasData){
      return GridView.count(
        crossAxisCount: 2,
        mainAxisSpacing: 8.0,
        crossAxisSpacing: 8.0,
        childAspectRatio: 0.8,
        padding: EdgeInsets.only(top: 8.0, left: 8.0, right: 8.0, bottom: 64.0),
        children: snapshot.data.map((ProductDetail productDetail){
          // print('Snapshot.data');
          // print(snapshot.data);
          return ProductWidget(productDetail : productDetail,);
              }).toList(),
             
          );
      }
       return Center(child: SpinKitCircle(
                                  color: Theme.of(context).primaryColor,
                                  size: 48.0,
                                ),); 
        },);
            }
  }