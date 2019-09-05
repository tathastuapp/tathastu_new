import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';
import 'package:flutter/services.dart';
import 'package:tathastu/services/auth_service.dart';
import 'package:tathastu/shared/snackbar_widget.dart';

class VerifyCodePage extends StatefulWidget {
  @override
  _VerifyCodePageState createState() => _VerifyCodePageState();
}

class _VerifyCodePageState extends State<VerifyCodePage> {

  final TextEditingController _smsController = TextEditingController();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  final GlobalKey<FormState> _smsCodeKey =
      GlobalKey<FormState>(debugLabel: 'PhoneKey');

  String _smsCode;

  @override
  Widget build(BuildContext context) {

    final AuthService authService = Provider.of<AuthService>(context);
    if (authService.response['error'] == 'VERIFY_PHONE_FAILED') {
      showSnackBar(context, 'Sending sms code is failed. Please try again.', _scaffoldKey);
    }

    return SafeArea(
      child: Scaffold(
        key: _scaffoldKey,
        body: Padding(
          padding: const EdgeInsets.all(32.0),
          child: Form(
            key: _smsCodeKey,
                      child: ListView(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  child: Text(
                    'Enter verification code',
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
                    controller: _smsController,
                    style: Theme.of(context).textTheme.headline,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      hintText: 'Verification Code',
                      labelText: 'Code',
                    ),
                    validator: (String value) {
                          if (value.isEmpty) {
                            return 'SMS Code can not be empty';
                          } else if (value.length != 6) {
                            return 'SMS Code must be of 6 digits';
                          }

                          return null;
                        },
                        onSaved: (value) {
                          setState(() {
                            _smsCode = value;
                          });
                        },
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(vertical: 8.0),
                  child: Text(
                    'We have sent you a 6 digit verification code on your phone number.',
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
                        //     green,
                        //     blue,
                        //   ],
                        // ),
                        color: Theme.of(context).primaryColor,
                        borderRadius: BorderRadius.circular(32.0)
                      ),
                      child: Center(
                        child: (authService.response['status'] ==
                                Status.VerifyingSmsCode)
                            ? Container(
                                // padding: EdgeInsets.all(8.0),
                                child: SpinKitCircle(
                                  color: Colors.white,
                                  size: 24.0,
                                ),
                              )
                            : Text(
                          'VERIFY',
                          style: Theme.of(context).textTheme.button.copyWith(
                            color: Colors.white,
                            fontSize: 20.0
                          )
                        ),
                      ),
                      
                    ),
                    onTap: (authService.response['status'] ==
                                Status.VerifyingSmsCode)
                            ? () {}
                            : () {
                                if (_smsCodeKey.currentState.validate()) {
                                  _smsCodeKey.currentState.save();
                                  try {
                                    authService.signInWithPhoneNumber(_smsCode);
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