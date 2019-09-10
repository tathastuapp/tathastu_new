import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tathastu/services/data_update_service.dart';
// import 'package:tathastu/services/cart_service.dart';
import 'package:tathastu/services/product_service.dart';
import 'package:tathastu/shared/unit_converter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
class ProductWidget extends StatefulWidget {
  final ProductDetail productDetail;

  const ProductWidget({Key key, this.productDetail}) : super(key: key);
  @override
  _ProductWidgetState createState() => _ProductWidgetState();
}

class _ProductWidgetState extends State<ProductWidget> {
  int productUnit = 0;
  Color animatedControllerColor; 

  String totalOrder;
  String order;
  num totalOrderQuantity = 0;

  String productId;
  String photoUrl;
  String minimumQuantityUnit;
  String englishName;
  String gujaratiName;
  String productType;
  bool isOrganic;
  bool isAvailable;
  num minimumQuantity;
  num minimumQuantityPrice;
  Map<String, dynamic> productData;

  @override
  void initState() {
    super.initState();
    productId = widget.productDetail.id;
    // productData = widget.productDetail;
    photoUrl = widget.productDetail.photoUrl;
    englishName = widget.productDetail.englishName;
    gujaratiName = widget.productDetail.gujaratiName;
    productType = widget.productDetail.type;
    isOrganic = widget.productDetail.isOrganic;
    minimumQuantity = widget.productDetail.minimumQuantity;
    minimumQuantityUnit = widget.productDetail.minimumQuantityUnit;
    minimumQuantityPrice = widget.productDetail.pricePerKg;
    isAvailable = widget.productDetail.isAvailable;
  }

  @override
  Widget build(BuildContext context) {
    // CartService cartService = Provider.of<CartService>(context);
    animatedControllerColor = Theme.of(context).primaryColor; 
    

    return Container(
      // shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24.0)),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24.0),
          boxShadow: [
            BoxShadow(
              color: Colors.blueGrey[50],
              blurRadius: 4.0,
              spreadRadius: 1.0 
            )
          ]
        ),
      child: Stack(
        children: <Widget>[
          Positioned(
            top: 36.0,
            right: 16.0,
            left: 16.0,
            child: Container(
              width: 120.0,
              height: 120.0,
              child: Image.network(
                photoUrl,
                fit: BoxFit.contain,
              ),
            ),
          ),
          Positioned(
            top: 4.0,
            right: 40.0,
            child: Container(
              height: 32.0,
              width: 32.0,
              margin: EdgeInsets.all(4.0),
              decoration: BoxDecoration(
                // color: Theme.of(context).primaryColor,
                // gradient: RadialGradient(
                //   colors: [
                //     Theme.of(context).primaryColor,
                //     Theme.of(context).accentColor,
                //   ],
                //   center: Alignment.center,
                // ),
                borderRadius: BorderRadius.circular(32.0),
                // boxShadow: [
                //   BoxShadow(
                //     color: Theme.of(context).primaryColor,
                //     blurRadius: 4.0,
                //     spreadRadius: 0.5,
                //   ),
                // ],
              ),
              child: Center(
                child: Text(
                  ' ₹48 ',
                  style: TextStyle(
                      color: Colors.grey[600], 
                      // fontWeight: FontWeight.bold,
                      fontSize: 16.0,
                      decoration: TextDecoration.lineThrough,
                      decorationThickness: 2.0,
                      decorationColor: Colors.grey[600], 
                      ),
                ), 
              ),
            ),
          ),
          Positioned(
            top: 4.0,
            right: 4.0,
            child: Container(
              height: 32.0,
              width: 32.0,
              margin: EdgeInsets.all(4.0),
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor,
                // gradient: RadialGradient(
                //   colors: [
                //     Theme.of(context).primaryColor,
                //     Theme.of(context).accentColor,
                //   ],
                //   center: Alignment.center,
                // ),
                borderRadius: BorderRadius.circular(32.0),
                // boxShadow: [
                //   BoxShadow(
                //     color: Theme.of(context).primaryColor,
                //     blurRadius: 4.0,
                //     spreadRadius: 0.5,
                //   ),
                // ],
              ),
              child: Center(
                child: Text(
                  '₹$minimumQuantityPrice',
                  style: TextStyle(
                      color: Colors.white, 
                      fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ),
          Positioned(
            top: 12.0,
            left: 12.0,
            child: Text(
              '$minimumQuantity$minimumQuantityUnit',
              style: TextStyle(color: Colors.grey[700], fontSize: 16.0),
            ),
          ),
          Positioned(
            top: 152.0,
            child: Container(
              width: MediaQuery.of(context).size.width / 2,
              child: Center(
                child: Text(
                  '$englishName',
                  style: TextStyle(
                      color: Colors.grey[700],
                      fontSize: 20.0,
                      fontWeight: FontWeight.w500),
                ),
              ),
            ),
          ),
          Positioned(
            top: 178.0,
            child: Container(
              width: MediaQuery.of(context).size.width / 2,
              child: Center(
                child: Text(
                  '$gujaratiName',
                  style: TextStyle(color: Colors.grey[600], fontSize: 16.0),
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 4,
            left: 0,
            right: 0,
            child: AnimatedContainer(
              duration: Duration(milliseconds: 800),
              height: 40.0,
              margin: EdgeInsets.symmetric(horizontal: 4.0),
              decoration: BoxDecoration(
                // gradient: animatedControllerColor,
                color: animatedControllerColor,
                borderRadius: BorderRadius.circular(32.0),
              ),
              // child: (true)
              child: (totalOrderQuantity == 0)
                  ? InkWell(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: <Widget>[
                          Container(
                            padding: EdgeInsets.only(right: 8.0),
                            child: Text(
                              'ADD TO CART',
                              style: TextStyle(
                                  color: Colors.white, 
                                  fontWeight: FontWeight.w600),
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.symmetric(horizontal: 4.0),
                            child: Icon(
                              Icons.add_circle,
                              size: 32.0,
                              color: Colors.white
                            ),
                          ),
                        ],
                      ),
                      onTap: () {
                        // cartService.addProductToCart(widget.product);
                        // num totalQuantity = widget.product.minimumQuantity *
                        //     cartService.getProductQuantity(widget.product.id);
                        // totalOrderQuantity =
                        //     totalOrderQuantity + minimumQunatity;
                        // totalOrder =
                        //     convertUnit2(totalQuantity, minimumQunatityUnit);
                        setState(() {
                          productUnit++;

                          // print(totalOrder);
                          animatedControllerColor = Colors.white;
                          // cartService.addCartProduct(widget.product);
                        });
                      },
                    )
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        InkWell(
                          child: Container(
                            padding: EdgeInsets.all(4.0),
                            decoration: BoxDecoration(
                                // gradient: RadialGradient(colors: [
                                //   Theme.of(context).primaryColor,
                                //   Theme.of(context).accentColor
                                // ], center: Alignment.center),
                                color: Theme.of(context).primaryColor,
                                borderRadius: BorderRadius.circular(32.0)),
                            child: Icon(
                              Icons.remove_circle,
                              size: 32.0,
                              color: Colors.white
                            ),
                          ),
                          onTap: () {
                            // cartService.decreaseProductInCart(
                            //     widget.product);
                            // totalOrderQuantity =
                            //     totalOrderQuantity - minimumQunatity;
                            // totalOrder = convertUnit2(
                            //     totalOrderQuantity, minimumQunatityUnit);
                            setState(() {
                              // widget.product['quantity']--;
                              // cartService.decreaseCartProductQuantity(widget.product);
                              if (totalOrderQuantity == 0) {
                                animatedControllerColor = Theme.of(context).primaryColor;
                              }
                            });
                          },
                        ),
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 2.0,
                          ),
                          child: Text(
                            // '${cartService.getProductQuantityInCart(widget.product)}',
                            '10',
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                                fontSize: 16.0),
                          ),
                        ),
                        InkWell(
                          child: Container(
                            padding: EdgeInsets.all(4.0),
                            decoration: BoxDecoration(
                                // gradient: RadialGradient(colors: [
                                //   Theme.of(context).primaryColor,
                                //   Theme.of(context).accentColor
                                // ], center: Alignment.center),
                                color: Theme.of(context).primaryColor,
                                borderRadius: BorderRadius.circular(32.0)),
                            child: Icon(
                              Icons.add_circle,
                              size: 32.0,
                              color: Colors.white
                            ),
                          ),
                          onTap: () {
                            // cartService.increaseProductInCart(
                            //     widget.product);
                            // totalOrderQuantity =
                            //     totalOrderQuantity + minimumQunatity;
                            // totalOrder = convertUnit2(
                            //     totalOrderQuantity, minimumQunatityUnit);
                            setState(() {
                              // productUnit++;

                              // print(total_order);
                              // widget.product['quantity']++;
                              // cartService.increaseCartProductQuantity(widget.product);
                            });
                          },
                        ),
                      ],
                    ),
            ),
          ),
        ],
      ),
    );
  }
}