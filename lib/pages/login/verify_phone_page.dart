import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:tathastu/services/auth_service.dart';
import 'package:tathastu/shared/snackbar_widget.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class VerifyPhonePage extends StatefulWidget {

  @override
  _VerifyPhonePageState createState() => _VerifyPhonePageState();
}

class _VerifyPhonePageState extends State<VerifyPhonePage> {
  final TextEditingController _phoneNumberController = TextEditingController();
  final GlobalKey<FormState> _phoneKey =
      GlobalKey<FormState>(debugLabel: 'PhoneKey');
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  String _phoneNumber;

  @override
  Widget build(BuildContext context) {
    final AuthService authService = Provider.of<AuthService>(context);
    if (authService.response['error'] == 'VERIFY_PHONE_FAILED') {
      showSnackBar(context, 'Sending sms code is failed. Please try again.',
          _scaffoldKey);
    }
    return SafeArea(
      child: Scaffold(
        key: _scaffoldKey,
        body: Padding(
          padding: const EdgeInsets.all(32.0),
          child: Form(
            key: _phoneKey,
            child: ListView(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  child: Text(
                    'Verify phone number',
                    style: Theme.of(context).textTheme.display1.copyWith(
                      // fontSize: 32.0,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).primaryColor,
                    )
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  child: TextFormField(
                    controller: _phoneNumberController,
                    style: Theme.of(context).textTheme.headline,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      hintText: 'Phone number',
                      labelText: 'Phone',
                    ),
                    validator: (String value) {
                      if (value.isEmpty) {
                        return 'Phone number can not be empty';
                      } else if (value.length != 10) {
                        return 'Phone number must be of 10 digits';
                      }

                      return null;
                    },
                    onSaved: (value) {
                      setState(() {
                        _phoneNumber = '+91' + value;
                      });
                    },
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(vertical: 8.0),
                  child: Text(
                    'When you tap on send, Tathastu will send you a text with verification code. Message and data rates may apply. The verified phone number can be used to login.',
                    style: Theme.of(context).textTheme.caption.copyWith(
                      // fontSize: 13.0
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  child: InkWell(
                    child: Container(
                      padding: EdgeInsets.all(16.0),
                      decoration: BoxDecoration(
                          // gradient: LinearGradient(
                          //   colors: [
                          //     blue,
                          //     // pink,
                          //     green,
                          //   ],
                          // ),
                          color: Theme.of(context).primaryColor,
                          borderRadius: BorderRadius.circular(32.0)),
                      child: Center(
                        child: (authService.response['status'] ==
                                Status.VerifyingPhoneNumber)
                            ? Container(
                                // padding: EdgeInsets.all(8.0),
                                child: SpinKitCircle(
                                  color: Colors.white,
                                  size: 24.0,
                                ),
                              )
                            : Text(
                                'SEND',
                                style: TextStyle(
                                    fontSize: 20.0, color: Colors.white),
                              ),
                      ),
                    ),
                    onTap: (authService.response['status'] ==
                            Status.VerifyingPhoneNumber)
                        ? () {}
                        : () {
                            if (_phoneKey.currentState.validate()) {
                              _phoneKey.currentState.save();
                              try {
                                authService.verifyPhoneNumber(_phoneNumber);
                              } on PlatformException {
                                print('Error Occured');
                              }
                            }
                          },
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}