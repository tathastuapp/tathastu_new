import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:tathastu/services/user_service.dart';

enum Status {
  Uninitialized,
  Authenticated,
  VerifyingPhoneNumber,
  VerifyPhoneFailed,
  SmsCodeSent,
  VerifyingSmsCode,
  VerifySmsCodeFailed,
  Unauthenticated,
  ProfileNotCreated
}

class AuthService extends ChangeNotifier {
  FirebaseAuth _auth;
  FirebaseUser _user;
  UserService _userService;
  AuthResult _authResult;
  String _verificationId;

  Map<String, dynamic> _response = {
    'status': Status.Unauthenticated,
    'user': null,
    'verificationId': '',
    'error': null
  };

  AuthService.instance()
      : _auth = FirebaseAuth.instance,
        _userService = UserService() {
    _auth.onAuthStateChanged.listen((FirebaseUser firebaseUser) async {
      if (firebaseUser == null) {
        _response = {
          'status': Status.Unauthenticated,
          'user': null,
          'verificationId': '',
          'error': null
        };
        notifyListeners();
      } else {
        _user = firebaseUser;

        UserModel userModel =
            await _userService.getCurrentUserDetails(_user.uid);

        print('User Display Name : ${userModel.displayName}');
        if (userModel.displayName == '') {
          _response = {
            'status': Status.ProfileNotCreated,
            'user': userModel,
            'verificationId': '',
            'error': 'USER_PROFILE_NOT_CREATED'
          };
          notifyListeners();
        } else {
          _response = {
            'status': Status.Authenticated,
            'user': userModel,
            'verificationId': '',
            'error': null
          };
          notifyListeners();
        }
      }
    });
  }

  Map<String, dynamic> get response => _response;

  Future<void> verifyPhoneNumber(String phoneNumber) async {
    _response = {
      'status': Status.VerifyingPhoneNumber,
      'user': null,
      'verificationId': '',
      'error': null
    };
    notifyListeners();

    final PhoneVerificationCompleted verificationCompleted =
        (AuthCredential phoneAuthCredential) async {
      _authResult = await _auth.signInWithCredential(phoneAuthCredential);
      _user = _authResult.user;

      print('Authenticated Phone');
    };

    final PhoneVerificationFailed verificationFailed =
        (AuthException authException) {
      _response = {
        'status': Status.VerifyPhoneFailed,
        'user': null,
        'verificationId': '',
        'error': 'VERIFY_PHONE_FAILED'
      };
      notifyListeners();
      print('Authentication Phone Failed');
      print(authException.message);
    };

    final PhoneCodeSent codeSent =
        (String verificationId, [int forceResendingToken]) async {

      Future.delayed(Duration(seconds: 4), () {
        _response = {
          'status': Status.SmsCodeSent,
          'user': null,
          'verificationId': verificationId,
          'error': null
        };
        notifyListeners();
      });

      _verificationId = verificationId;
      print('SMS Code Sent');
    };

    final PhoneCodeAutoRetrievalTimeout codeAutoRetrievalTimeout =
        (String verificationId) {
      _verificationId = verificationId;
      _response = {
        'status': Status.SmsCodeSent,
        'user': null,
        'verificationId': verificationId,
        'error': null
      };
      notifyListeners();
    };

    await _auth.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        timeout: const Duration(seconds: 5),
        verificationCompleted: verificationCompleted,
        verificationFailed: verificationFailed,
        codeSent: codeSent,
        codeAutoRetrievalTimeout: codeAutoRetrievalTimeout);
  }

  Future<void> signInWithPhoneNumber(String smsCode) async {
    _response = {
      'status': Status.VerifyingSmsCode,
      'user': null,
      'verificationId': '',
      'error': null
    };
    notifyListeners();
    try {
      final AuthCredential credential = PhoneAuthProvider.getCredential(
        verificationId: _verificationId,
        smsCode: smsCode,
      );
      _authResult = await _auth.signInWithCredential(credential);
      final FirebaseUser user = _authResult.user;
      final FirebaseUser currentUser = await _auth.currentUser();
      assert(user.uid == currentUser.uid);
      print('Successfully signed in, uid: ' + user.uid);
    } catch (e) {
      print('Wrong SMS Code');
      print(e);
      _response = {
        'status': Status.VerifySmsCodeFailed,
        'user': null,
        'verificationId': '',
        'error': 'VERIFY_SMSCODE_FAILED'
      };
      notifyListeners();
    }
  }

  Future<FirebaseUser> getCurrentUser() async {
    return await _auth.currentUser();
  }

  Future<UserModel> getUserDetails(String uid) async {
    return await _userService.getCurrentUserDetails(uid);
  }

  UserUpdateInfo userUpdateInfo = UserUpdateInfo();

  Future<void> setDisplayName(String displayName) async {
    FirebaseUser user = await _auth.currentUser();
    userUpdateInfo.displayName = displayName;
    _response = {
      'status': Status.Authenticated,
      'user': user,
      'verificationId': '',
      'error': null
    };
    notifyListeners();
  }

  Future signOut() async {
    _auth.signOut();
    _response = {
      'status': Status.Unauthenticated,
      'user': null,
      'verificationId': '',
      'error': null
    };
    notifyListeners();
    return Future.delayed(Duration.zero);
  }
}