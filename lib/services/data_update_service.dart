import 'dart:async';
import "package:async" show StreamZip;

import 'package:flutter/material.dart';
import 'package:tathastu/services/is_available_service.dart';
import 'package:tathastu/services/last_update_time_service.dart';
import 'package:tathastu/services/price_service.dart';
import 'package:tathastu/services/product_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


class ProductDetail {
  String id;
  String englishName;
  String gujaratiName;
  String photoUrl;
  bool isOrganic;
  String type;
  String minimumQuantityUnit;
  num minimumQuantity;
  num pricePerKg;
  bool isAvailable;

  ProductDetail(
      {this.id,
      this.englishName,
      this.gujaratiName,
      this.photoUrl,
      this.isOrganic,
      this.type,
      this.minimumQuantityUnit,
      this.minimumQuantity,
      this.pricePerKg,
      this.isAvailable});

  setId(String value) {
    id = value;
  }

  setEnglishName(String value) {
    englishName = value;
  }

  setGujaratiName(String value) {
    gujaratiName = value;
  }

  setPhotoUrl(String value) {
    photoUrl = value;
  }

  setIsOrganic(bool value) {
    isOrganic = value;
  }

  setType(String value) {
    type = value;
  }

  setMinimumQuantityUnit(String value) {
    minimumQuantityUnit = value;
  }

  setMinimumQuantity(num value) {
    minimumQuantity = value;
  }

  setProductPrice(num value) {
    pricePerKg = value;
  }

  setIsAvailable(bool value) {
    isAvailable = value;
  }
}

class DataUpdateService with ChangeNotifier {
  ProductService productService;
  PriceService priceService;
  IsAvailableService isAvailableService;
  LastUpdateTimeService lastUpdateTimeService;
  ProductDetail productDetail;
  List<ProductDetail> productDetails = [];
  List<Product> products = [];
  Price price;
  IsAvailable isAvailable;

  Map data = {};

  StreamController<List<ProductDetail>> productDetailsListController =
      StreamController.broadcast();
  Stream<List<ProductDetail>> get outProductDetailsList =>
      productDetailsListController.stream;
  Sink<List<ProductDetail>> get inProductDetailsList =>
      productDetailsListController.sink;


  closeController() {
    productDetailsListController.close();
  }

  DataUpdateService.instance() {
    productService = ProductService.instance();
    priceService = PriceService.instance();
    isAvailableService = IsAvailableService.instance();
    lastUpdateTimeService = LastUpdateTimeService.instance();

  Stream<List<DocumentSnapshot>> productStream = productService.streamProductList();
  Stream<DocumentSnapshot> priceSnapshot = priceService.streamPrice();
  Stream<DocumentSnapshot> isAvailableSnapshot =isAvailableService.streamIsAvailable();

  StreamZip bothStreams = StreamZip([productStream, priceSnapshot, isAvailableSnapshot]); 

    getProductDetails();
  }

  getProductDetails() {
    String productId;

    productService.streamProductList().listen((products) {
      productDetails = products.map((product) {
        productId = product.id;
        return ProductDetail(
          id: product.id,
          englishName: product.englishName,
          gujaratiName: product.gujaratiName,
          photoUrl: product.photoUrl,
          isOrganic: product.isOrganic,
          type: product.type,
          minimumQuantity: product.minimumQuantity,
          minimumQuantityUnit: product.minimumQuantityUnit,
        );
      }).toList();
      notifyListeners();
    });

    priceService.streamPrice().listen((price) {
      productDetails.map((productDetail) {
        productDetail.pricePerKg = price.pricePerKg[productDetail.id];
      }).toList();
      notifyListeners();
    });

    isAvailableService.streamIsAvailable().listen((isAvailable) {
      productDetails.map((productDetail) {
        productDetail.isAvailable = isAvailable.isAvailable[productDetail.id];
      }).toList();
      notifyListeners();
    });

    inProductDetailsList.add(productDetails);
    notifyListeners();
  }
}
