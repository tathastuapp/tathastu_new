import 'package:flutter/material.dart';
import 'package:flutter_upi/flutter_upi.dart';

class PaymentPage extends StatefulWidget {
  @override
  _PaymentPageState createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  Future _initiateTransaction;
  GlobalKey<ScaffoldState> _key;
  Map<String, dynamic> _selectedItem;
  List<Map<String, String>> _upiPaymentList = [
    {
      'title': 'Pay with Bhim UPI',
      'name': 'BHIM UPI',
      'id': '9426302123@upi',
      'mode': FlutterUpiApps.BHIMUPI,
    },
    {
      'title': 'Pay with PayTM UPI',
      'name': 'PayTM UPI',
      'id': '9898108403@paytm',
      'mode': FlutterUpiApps.PayTM,
    },
    {
      'title': 'Pay with Google Pay UPI',
      'name': 'GooglePay UPI',
      'id': 'balajicorp2014@okaxis',
      'mode': FlutterUpiApps.GooglePay,
    },
    {
      'title': 'Pay with PhonePe UPI',
      'name': 'PhonePe UPI',
      'id': '9426302123@ybl',
      'mode': FlutterUpiApps.PhonePe,
    },
    {
      'title': 'Pay with Amazon Pay UPI',
      'name': 'AmazonPay UPI',
      'id': '9426302123@apl',
      'mode': FlutterUpiApps.AmazonPay,
    },
    
  ];

  @override
  void initState() {
    _key = GlobalKey<ScaffoldState>();
    super.initState();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<String> initTransaction(Map<String, dynamic> item) async {
    print(item);
    String response = await FlutterUpi.initiateTransaction(
        app: item['mode'],
        pa: item['id'],
        // pa: '9426302123@upi',
        pn: "Harsh Parikh",
        tr: "TR123495865",
        tn: "Tathastu Test Payment",
        am: "1.00",
        cu: "INR",
        url: "https://www.google.com");
    print('Response : $response');

    return response;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        key: _key,
        
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              summaryTitleWidget(),
              defaultAddressWidget(),
              defaultPaymentMethod(),
              paymentDetailsWidget(),
              noticeForShopping(),
              SizedBox(
                height: 20.0,
              ),
              submitButtonWidget()
            ],
          ),
        ),
      ),
    );
  }

  Widget summaryTitleWidget() {
    return Container(
      child: Text('Summary',
          style: TextStyle(
              color: Theme.of(context).primaryColor,
              fontSize: 32.0,
              fontWeight: FontWeight.bold)),
    );
  }

  Widget defaultAddressWidget() {
    return Container(
      padding: EdgeInsets.all(16.0),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16.0),
          boxShadow: [
            BoxShadow(
              color: Colors.blueGrey[50],
              blurRadius: 4.0,
              spreadRadius: 1.0 
            )
          ]
        ),
      child: Row(
        children: <Widget>[
          Container(
            padding: EdgeInsets.all(4.0),
            child: Icon(
              Icons.location_on,
              size: 32.0,
            ),
          ),
          Expanded(
            child: Container(
              padding: EdgeInsets.only(left: 4.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.all(4.0),
                    child: Text(
                      'Delivery Address',
                      style: Theme.of(context).textTheme.title,
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.all(4.0),
                    child: Text(
                      '28-29, Krushnapark Society, Near Gas Godawn, Hansapur, Patan',
                      style: Theme.of(context).textTheme.body1,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Container(
            child: Icon(Icons.keyboard_arrow_right),
          )
        ],
      ),
    );
  }

  Widget defaultPaymentMethod() {
    return InkWell(
      onTap: _showPaymentMethods,
      child: Container(
        padding: EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16.0),
          boxShadow: [
            BoxShadow(
              color: Colors.blueGrey[50],
              blurRadius: 4.0,
              spreadRadius: 1.0 
            )
          ]
        ),
        child: Row(
          children: <Widget>[
            Container(
              padding: EdgeInsets.all(4.0),
              child: Icon(
                Icons.payment,
                size: 32.0,
              ),
            ),
            Expanded(
              child: Container(
                padding: EdgeInsets.only(left: 4.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    Container(
                      padding: EdgeInsets.all(4.0),
                      child: Text(
                        'Payment Method',
                        style: Theme.of(context).textTheme.title,
                      ),
                    ),
                    (_selectedItem == null || _selectedItem == {}) ? Container() : Container(
                      padding: EdgeInsets.all(4.0),
                      child: Text(
                        _selectedItem['name'],
                        style: Theme.of(context).textTheme.body1,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Container(
              child: Icon(Icons.keyboard_arrow_right),
            )
          ],
        ),
      ),
    );
  }

  Widget paymentDetailsWidget() {
    return Container(
      padding: EdgeInsets.all(16.0),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16.0),
          boxShadow: [
            BoxShadow(
              color: Colors.blueGrey[50],
              blurRadius: 4.0,
              spreadRadius: 1.0 
            )
          ]
        ),
      child: Row(
        children: <Widget>[
          Expanded(
            child: Container(
              padding: EdgeInsets.only(left: 4.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.only(
                      top: 4.0,
                      left: 4.0,
                      right: 4.0,
                      bottom: 8.0,
                    ),
                    child: Text(
                      'Payment Details',
                      style: Theme.of(context).textTheme.title,
                    ),
                  ),
                  Container(
                      height: 100,
                      padding: EdgeInsets.all(4.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          Container(
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Container(
                                  child: Text('Subtotal'),
                                ),
                                Container(
                                  child: Text('120.00'),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Container(
                                  child: Text('Discount (5%)'),
                                ),
                                Container(
                                  child: Text('6.00'),
                                )
                              ],
                            ),
                          ),
                          Container(
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Container(
                                  child: Text('Delivery Charge'),
                                ),
                                Container(
                                  child: Text('Free'),
                                )
                              ],
                            ),
                          ),
                          Container(
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Container(
                                  child: Text(
                                    'Total',
                                    style: Theme.of(context).textTheme.subtitle,
                                  ),
                                ),
                                Container(
                                  child: Text(
                                    '114',
                                    style: Theme.of(context).textTheme.subtitle,
                                  ),
                                )
                              ],
                            ),
                          )
                        ],
                      )),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget submitButtonWidget() {
    return InkWell(
      child: Container(
        padding: EdgeInsets.all(16.0),
        decoration: BoxDecoration(
            color: Theme.of(context).primaryColor,
            borderRadius: BorderRadius.circular(16.0),
            boxShadow: [
              BoxShadow(
                  color: Colors.grey[100], blurRadius: 4.0, spreadRadius: 1.0)
            ]),
        child: Center(
          child: Text(
            'SUBMIT',
            style: TextStyle(
                color: Colors.white,
                fontSize: 20.0,
                fontWeight: FontWeight.bold),
          ),
        ),
      ),
      onTap: () {
        _initiateTransaction = initTransaction(_selectedItem);
        setState(() {});
      },
    );
  }

  Widget noticeForShopping() {
    return Container(
      padding: EdgeInsets.all(8.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Container(
            child: Text(
              'Note',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Container(
            child: Text(
              '1) Items purchased will be delivered on next working day.',
              style: TextStyle(),
            ),
          ),
          Container(
            child: Text(
              '2) For advance paying customers, 5% discount will be given.',
              style: TextStyle(),
            ),
          ),
        ],
      ),
    );
  }

  void _showPaymentMethods() {
    showModalBottomSheet(
        context: context,
        builder: (context) {
          return Container(
            color: Color(0xFF737373),
            height: 300,
            child: Container(
              child: _buildBottomNavigationMenu(),
              decoration: BoxDecoration(
                color: Theme.of(context).canvasColor,
                borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(10),
                  topRight: const Radius.circular(10),
                ),
              ),
            ),
          );
        });
  }

  Column _buildBottomNavigationMenu() {
    return Column(
      children: _upiPaymentList.map((item) {
        return ListTile(
          leading: Icon(Icons.ac_unit),
          title: Text(item['title']),
          onTap: () => _selectItem(item),
        );
      }).toList(),

      
    );
  }

  void _selectItem(Map<String, dynamic> item) {
    Navigator.pop(context);
    setState(() {
      _selectedItem = item;
    });
  }

  Widget showPaymentRespons() {
    return Expanded(
      child: Column(
        children: <Widget>[
          FutureBuilder(
              future: _initiateTransaction,
              builder: (BuildContext ctx, AsyncSnapshot snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting ||
                    snapshot.data == null) {
                  return Text("Processing or Yet to start...");
                } else {
                  switch (snapshot.data.toString()) {
                    case 'app_not_installed':
                      return Text("Application not installed.");
                      break;
                    case 'invalid_params':
                      return Text("Request parameters are wrong");
                      break;
                    case 'user_canceled':
                      return Text("User canceled the flow");
                      break;
                    case 'null_response':
                      return Text("No data received");
                      break;
                    default:
                      {
                        FlutterUpiResponse flutterUpiResponse =
                            FlutterUpiResponse(snapshot.data);
                        print(flutterUpiResponse.txnId);
                        return Text(snapshot.data);
                      }
                  }
                }
              }),
        ],
      ),
    );
  }
}