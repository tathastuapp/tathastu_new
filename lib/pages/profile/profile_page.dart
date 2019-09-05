import 'package:flutter/material.dart';
// import 'package:tathastu/pages/my_orders_page/my_orders_page.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        
        body: ListView(
          padding: EdgeInsets.all(16.0),
          children: <Widget>[
            Container(
              padding: EdgeInsets.symmetric(vertical: 16.0),
              child: Column(
                children: <Widget>[
                  Icon(
                    Icons.account_circle,
                    size: 64.0,
                    color: Theme.of(context).primaryColor,
                  ),
                  SizedBox(
                    height: 12.0,
                  ),
                  Text(
                    'Ketul Rastogi',
                    style: Theme.of(context).textTheme.title.copyWith(
                        // color: Colors.grey[600],
                        fontSize: 24.0
                        ),
                  ),
                  SizedBox(
                    height: 12.0,
                  ),
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.all(8.0),
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16.0),
                  boxShadow: [
                    BoxShadow(
                        color: Colors.blueGrey[50],
                        blurRadius: 4.0,
                        spreadRadius: 1.0)
                  ]),
              child: Column(
                children: <Widget>[
                  InkWell(
                    onTap: (){
                      // Navigator.push(context, 
                      //   MaterialPageRoute(
                      //     builder: (context) => MyOrdersPage()
                      //   )
                      // );
                    },
                                      child: ListTile(
                      title: Text('My Orders',
                          style: Theme.of(context).textTheme.subhead.copyWith(
                            fontSize: 20.0
                          ),),
                      leading: Icon(
                        Icons.shopping_basket,
                        color: Theme.of(context).primaryColor,
                        size: 30.0,
                      ),
                      trailing: Icon(
                        Icons.keyboard_arrow_right,
                        color: Colors.grey[500],
                        size: 30.0,
                      ),
                    ),
                  ),
                  Divider(),
                  ListTile(
                    title: Text('Proile',
                        style: Theme.of(context).textTheme.subhead.copyWith(
                          fontSize: 20.0
                        ),),
                    leading: Icon(Icons.account_box,
                      color: Theme.of(context).primaryColor,
                      size: 30.0,),
                    trailing: Icon(
                      Icons.keyboard_arrow_right,
                      color: Colors.grey[500],
                      size: 30.0,
                    ),
                  ),
                  Divider(),
                  ListTile(
                    title: Text('Feedback',
                        style: Theme.of(context).textTheme.subhead.copyWith(
                          fontSize: 20.0
                        ),),
                    leading: Icon(Icons.feedback,
                      color: Theme.of(context).primaryColor,
                      size: 30.0,),
                    trailing: Icon(
                      Icons.keyboard_arrow_right,
                      color: Colors.grey[500],
                      size: 30.0,
                    ),
                  ),
                  Divider(),
                  ListTile(
                    title: Text('Terms and conditions',
                        style: Theme.of(context).textTheme.subhead.copyWith(
                          fontSize: 20.0
                        ),),
                    leading: Icon(Icons.description,
                      color: Theme.of(context).primaryColor,
                      size: 30.0,),
                    trailing: Icon(
                      Icons.keyboard_arrow_right,
                      color: Colors.grey[500],
                      size: 30.0,
                    ),
                  ),
                  Divider(),
                  ListTile(
                    title: Text('Contact Us',
                        style: Theme.of(context).textTheme.subhead.copyWith(
                          fontSize: 20.0
                        ),),
                    leading: Icon(Icons.contact_phone,
                      color: Theme.of(context).primaryColor,
                      size: 30.0,),
                    trailing: Icon(
                      Icons.keyboard_arrow_right,
                      color: Colors.grey[500],
                      size: 30.0,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}