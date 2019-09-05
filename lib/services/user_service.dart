import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tathastu/services/auth_service.dart';


class UserModel {
  final String uid;
  final String displayName;
  final DateTime birthDate;
  final String gender;
  final String deviceToken;
  final String city;

  UserModel({this.uid, this.displayName, this.birthDate, this.gender, this.deviceToken, this.city}); 

  factory UserModel.fromFirestore(DocumentSnapshot documentSnapshot){
    Map data = documentSnapshot.data;
    String id = documentSnapshot.documentID;

    return UserModel(
      uid: id,
      displayName: (data['display_name'] != null) ? data['display_name'] : '', 
      birthDate:   (data['birth_date'] != null) ? (data['birth_date'] as Timestamp).toDate() : null,
      gender: (data['gender'] != null) ? data['gender'] : '',
      deviceToken: (data['device_token'] != null) ? data['device_token'] : '',
      city: (data['city_name'] != null) ? data['city_name'] : '',
    );
  }
}


class UserService {
  
  Firestore _db;

  UserService(){
    _db = Firestore.instance;
  }

  Future<UserModel> getCurrentUserDetails(String uid) async{

    DocumentSnapshot userDocumentSnapshot = await _db.collection('users').document(uid).get();
    return UserModel.fromFirestore(userDocumentSnapshot);
  }


  Future<void> updateUserDetails(UserModel userModel) async{
    AuthService authService = AuthService.instance();

    await _db.collection('users').document(userModel.uid).setData(
      {
        'uid' :userModel.uid,
        'display_name':userModel.displayName,
        'birthdate': Timestamp.fromDate(userModel.birthDate),
        'gender':userModel.gender,
        'city':userModel.city
      }, merge: true
    );
  }

  Future<void> updateDisplayName(String uid,String displayName) async{
    await _db.collection('users').document(uid).setData({'display_name':displayName},merge: true);
  }

  Future<void> updateBirthDate(String uid,DateTime birthDate) async{
    await _db.collection('users').document(uid).setData({'birthdate':Timestamp.fromDate(birthDate),},merge: true);
  }

  Future<void> updateGender(String uid,String gender) async{
    await _db.collection('users').document(uid).setData({'gender':gender},merge: true);
  }

}