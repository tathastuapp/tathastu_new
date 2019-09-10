import 'package:badges/badges.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:tathastu/pages/profile/profile_page.dart';
import 'package:tathastu/services/data_update_service.dart';
import 'package:tathastu/services/user_service.dart';
import 'package:tathastu/widgets/product_list.dart';
import 'package:provider/provider.dart';
class HomePage extends StatefulWidget {
  final UserModel user;

  const HomePage({Key key, this.user}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    // CartService cartService = Provider.of<CartService>(context);
  DataUpdateService dataUpdateService = Provider.of<DataUpdateService>(context);
    return SafeArea(
      child: DefaultTabController(
        length: 3,
        child: Scaffold(
          // backgroundColor: Colors.grey[200],
          appBar: AppBar(
            automaticallyImplyLeading: false,
            backgroundColor: Colors.transparent,
            elevation: 0, 
            title: Padding(
              padding: const EdgeInsets.all(8.0),
              child: InkWell(
                onTap: (){
                  FirebaseAuth.instance.signOut();
                },
                              child: Text(
                  'Tathastu',
                  style: TextStyle(
                    fontSize: 30.0,
                    color: Colors.grey[800],
                    fontWeight: FontWeight.bold
                  ),
                ),
              ),
            ),
            actions: <Widget>[
              InkWell(
                onTap: (){
                  dataUpdateService.getProductDetails();
                },
                              child: Container(
                  padding: EdgeInsets.all(8.0),
                  margin: EdgeInsets.all(8.0),
                  child: Badge(
                    badgeContent:
                        Text('5', style: TextStyle(color: Colors.black)),
                    badgeColor: Colors.yellow,
                    child: Icon(
                      Icons.notifications,
                      color: Theme.of(context).primaryColor, 
                      size: 32.0,
                    ),
                  ),
                ),
              ),
              InkWell(
                 onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ProfilePage()));
                },
                              child: Container(
                  padding: EdgeInsets.all(8.0),
                  margin: EdgeInsets.all(8.0),
                  child: Icon(
                    Icons.account_circle,
                    color: Theme.of(context).primaryColor, 
                    size: 32.0,
                  ),
                ),
              ),
              InkWell(
                onTap: () {
                  // Navigator.push(
                  //     context,
                  //     MaterialPageRoute(
                  //         builder: (context) => ShoppingCartPage()));
                },
                child: Container(
                  padding: EdgeInsets.all(8.0),
                  margin: EdgeInsets.all(8.0),
                  child: Badge(
                    badgeContent: Text(
                        // cartService.getTotalItemsInCart().toString(),
                        '5',
                        style: TextStyle(color: Colors.black)),
                    badgeColor: Colors.yellow,
                    child: Icon(
                      Icons.shopping_cart,
                      color: Theme.of(context).primaryColor, 
                      size: 32.0,
                    ),
                  ),
                ),
              ),
            ],
            
            bottom: TabBar(
              unselectedLabelColor: Colors.grey,
              labelColor: Theme.of(context).primaryColor, 
              // indicatorColor: Colors.white,
              labelStyle:
                  TextStyle(fontSize: 18.0, fontWeight: FontWeight.w600),
              tabs: <Widget>[
                Tab(
                  text: 'Vegetables',
                ),
                Tab(
                  text: 'Fruits',
                ),
                Tab(
                  text: 'Flowers',
                )
              ],
            ),
          ),
          body: sliverGrid(),
          // backgroundColor: Theme.of(context).primaryColor,
          // bottomNavigationBar: BottomAppNavBar(),
        ),
      ),
    );
  }

  // Widget sliverGrid(CartService cartService) {
  Widget sliverGrid() {
    return Stack(
      children: <Widget>[
        
        ProductListWidget(),
        Positioned(
          bottom: 0.0,
          left: 0.0,
          right: 0.0, 
          child: (0 > 1)
          // child: (cartService.getTotalAmountOfCart() > 1)
              ? InkWell(
                  child: Container(
                    // width: MediaQuery.of(context).size.width,
                    height: 56.0,
                    // padding: EdgeInsets.all(8.0), 
                    // margin: EdgeInsets.all(16.0),
                    decoration: BoxDecoration(
                        color: Theme.of(context).primaryColor,
                        // borderRadius: BorderRadius.circular(32.0),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Icon(Icons.shopping_cart,
                          color: Colors.white
                        ),
                        SizedBox(
                          width: 16.0,
                        ), 
                        Text(
                          'GO TO CART',
                          style: TextStyle(color: Colors.white, fontSize: 20.0, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                  onTap: (){
                    // Navigator.push(
                    //   context,
                    //   MaterialPageRoute(
                    //       builder: (context) => ShoppingCartPage()));
                  },
                )
              : Container(),
        ),
      ],
    );
  }
}