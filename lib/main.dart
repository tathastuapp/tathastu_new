import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:tathastu/pages/home/home_page.dart';
import 'package:tathastu/pages/login/user_details_page.dart';
import 'package:tathastu/pages/login/verify_code_page.dart';
import 'package:tathastu/pages/login/verify_phone_page.dart';
import 'package:tathastu/services/auth_service.dart';
import 'package:tathastu/services/data_update_service.dart';
import 'package:tathastu/services/product_service.dart';

void main() => runApp(TathastuApp());

class TathastuApp extends StatefulWidget {
  @override
  _TathastuAppState createState() => _TathastuAppState();
}

class _TathastuAppState extends State<TathastuApp> {
  String cityId = 'JM9kFy8LUuZiOAoaTPcz';

  @override
  void initState() {
    super.initState();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
  }

  @override
  void dispose() {
    super.dispose();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider<AuthService>(
            builder: (context) => AuthService.instance(),
          ),
          ChangeNotifierProvider<ProductService>(
            builder: (context) => ProductService.instance(),
          ),
          ChangeNotifierProvider<DataUpdateService>(
            builder: (context) => DataUpdateService.instance(),
          ),
        ],
        child: MaterialApp(
          title: 'Tathastu',
          theme: ThemeData(
            brightness: Brightness.light,
            // primarySwatch: Colors.deepOrange,
            primaryColor: Colors.redAccent,
            accentColor: Colors.red,
          ),
          debugShowCheckedModeBanner: false,
          home: SplashScreen(),
        ));
  }
}

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();

    Future.delayed(Duration(seconds: 3), () {
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => HomePage()));
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        // backgroundColor: Colors.white,
        body: Center(
          child: Container(
            height: 120.0,
            width: 120.0,
            padding: EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              // border: Border.all(color: Theme.of(context).primaryColor , width: 4.0),
              // gradient: LinearGradient(colors: [
              //   Theme.of(context).primaryColor,
              //   Theme.of(context).accentColor,
              // ], begin: Alignment.topCenter, end: Alignment.bottomCenter,),
              color: Theme.of(context).primaryColor,
              borderRadius: BorderRadius.circular(16.0),
            ),
            child:
                SvgPicture.asset('assets/logo/hand.svg', color: Colors.white),
          ),
        ),
      ),
    );
  }
}

class InitialPage extends StatefulWidget {
  final String title;

  const InitialPage({Key key, this.title}) : super(key: key);
  @override
  _InitialPageState createState() => _InitialPageState();
}

class _InitialPageState extends State<InitialPage> {
  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, AuthService user, _) {
        user.getCurrentUser().then((user) => print(user));
        switch (user.response['status']) {
          case Status.Uninitialized:
          case Status.Unauthenticated:
            return VerifyPhonePage();
          case Status.VerifyingPhoneNumber:
            return VerifyPhonePage();
          case Status.VerifyPhoneFailed:
            print('MAIN:44 - ' + user.response['error'].toString());
            return VerifyPhonePage();
          case Status.SmsCodeSent:
            return VerifyCodePage();
          case Status.VerifyingSmsCode:
            return VerifyCodePage();
          case Status.VerifySmsCodeFailed:
            return VerifyCodePage();
          case Status.ProfileNotCreated:
            return UserDetaislPage(user: user.response['user']);
          case Status.Authenticated:
            return HomePage(user: user.response['user']);
          default:
            return VerifyPhonePage();
        }
      },
    );
  }
}