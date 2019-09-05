import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:tathastu/services/auth_service.dart';
// import 'package:tathastu/services/city_service.dart';
import 'package:tathastu/services/user_service.dart';
import 'package:tathastu/shared/snackbar_widget.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:intl/intl.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:simple_autocomplete_formfield/simple_autocomplete_formfield.dart';

// final cities = <CityModel>[
//   CityModel(cityName: 'Patan',pincode: '384265'),
//   CityModel(cityName: 'Mehsana',pincode : '384002')
// ];

class UserDetaislPage extends StatefulWidget {
  final UserModel user;
  const UserDetaislPage({Key key, this.user}) : super(key: key);

  @override
  _UserDetaislPageState createState() => _UserDetaislPageState();
}

class _UserDetaislPageState extends State<UserDetaislPage> {
  final TextEditingController _displayeNameController = TextEditingController();
  final GlobalKey<FormState> _phoneKey =
      GlobalKey<FormState>(debugLabel: 'PhoneKey');
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  // CityModel selectedCity;
  UserModel userModel;
  String _displayName;
  String _selectedGender = '';
  DateTime _selectedDate;

  final format = DateFormat("dd-MM-yyyy");

  @override
  void initState() {
    
    _selectedDate = widget.user.birthDate;
    _selectedGender = widget.user.gender;
    _displayName = widget.user.displayName;
    
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    final UserService userService =UserService();
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
                pageTitle(),
                // cityInputField(),
                displayNameInputField(),
                birthDateInputField(),
                genderSelectField(),
                submitButtonField(authService, userService)
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<Null> _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
      context: context,
      initialDate: new DateTime.now(),
      lastDate: new DateTime(1947),
      firstDate: new DateTime(2099),
    );

    if (picked != null && picked != _selectedDate) {
      print("Date selected ${_selectedDate.toString()}");
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  Widget pageTitle(){
    return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  child: Text('User Details',
                      style: Theme.of(context).textTheme.display1.copyWith(
                            // fontSize: 32.0,
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).primaryColor,
                          )),
                );
  }

  // Widget cityInputField(){
  //   return Padding(
  //                 padding: const EdgeInsets.symmetric(vertical: 8.0),
  //                 child: SimpleAutocompleteFormField<CityModel>(
  //                   style: Theme.of(context).textTheme.headline,
  //                   decoration: InputDecoration(
  //                     labelText: 'City',
  //                     hintText: 'City Name',
  //                   ),
  //                   suggestionsHeight: 100.0,
  //                   itemBuilder: (context, CityModel city) => Padding(
  //                     padding: EdgeInsets.all(8.0),
  //                     child: Column(
  //                         crossAxisAlignment: CrossAxisAlignment.start,
  //                         children: [
  //                           Text(city.cityName,
  //                               style: Theme.of(context).textTheme.title),
  //                           Text(city.pincode,
  //                             style: Theme.of(context).textTheme.subtitle
  //                           )
  //                         ]),
  //                   ),
  //                   onSearch: (search) async => cities
  //                       .where((CityModel city) =>
  //                           city.cityName
  //                               .toLowerCase()
  //                               .contains(search.toLowerCase()) ||
  //                           city.pincode
  //                               .toLowerCase()
  //                               .contains(search.toLowerCase()))
  //                       .toList(),
  //                   itemFromString: (string) => cities.singleWhere(
  //                       (CityModel city) =>
  //                           city.cityName.toLowerCase() == string.toLowerCase(),
  //                       orElse: () => null),
  //                   onChanged: (CityModel value) => setState(() => selectedCity = value),
  //                   onSaved: (CityModel value) => setState(() => selectedCity = value),
  //                   validator: (CityModel city) => city == null ? 'Invalid city.' : null,
  //                 ),
  //               );
  // }

  Widget displayNameInputField(){
    return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: TextFormField(
                    controller: _displayeNameController,
                    style: Theme.of(context).textTheme.headline,
                    // keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      hintText: 'Display Name',
                      labelText: 'Name',
                    ),
                    validator: (String value) {
                      if (value.isEmpty) {
                        return 'Display name can not be empty';
                      } 

                      return null;
                    },
                    onSaved: (value) {
                      setState(() {
                        _displayName = value;
                      });
                    },
                  ),
                );
  }

  Widget birthDateInputField(){
    return DateTimeField(
                  style: Theme.of(context).textTheme.headline,
                  decoration: InputDecoration(
                    hintText: 'Date Of Birth',
                    labelText: 'Birthdate',
                  ),
                  format: format,
                  onShowPicker: (context, currentValue) {
                    return showDatePicker(
                        context: context,
                        firstDate: DateTime(1900),
                        initialDate: _selectedDate ?? DateTime.now(),
                        lastDate: DateTime(2100));
                  },
                  onChanged: (value){
                    setState(() {
                      _selectedDate = value;
                    });
                  },
                  onSaved: (value){
                    setState(() {
                      _selectedDate = value;
                    });
                  },
                );
  }

  Widget genderSelectField(){
    return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Container(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: <Widget>[
                        Container(
                          child: Text(
                            'Gender',
                            style: Theme.of(context)
                                .textTheme
                                .headline
                                .copyWith(color: Colors.grey[600]),
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            setState(() {
                              _selectedGender = 'Male';
                            });
                          },
                          child: Container(
                            width: 100.0,
                            height: 100.0,
                            // padding: EdgeInsets.all(16.0),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(16.0),
                              border: Border.all(
                                  color: (_selectedGender == 'Male')
                                      ? Theme.of(context).primaryColor
                                      : Colors.transparent,
                                  width: 2.0),
                              boxShadow: [
                                BoxShadow(
                                    color: Colors.grey[100],
                                    blurRadius: 4.0,
                                    spreadRadius: 1.0)
                              ],
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Container(
                                  height: 32.0,
                                  width: 32.0,
                                  child: SvgPicture.asset(
                                    'assets/icons/man-avatar.svg',
                                    color: Theme.of(context).primaryColor,
                                  ),
                                ),
                                Container(
                                  padding: EdgeInsets.all(8.0),
                                  child: Text(
                                    'Male',
                                    style: Theme.of(context).textTheme.subhead,
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            setState(() {
                              _selectedGender = 'Female';
                            });
                          },
                          child: Container(
                            width: 100.0,
                            height: 100.0,
                            // padding: EdgeInsets.all(16.0),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(16.0),
                              border: Border.all(
                                  color: (_selectedGender == 'Female')
                                      ? Theme.of(context).primaryColor
                                      : Colors.transparent,
                                  width: 2.0),
                              boxShadow: [
                                BoxShadow(
                                    color: Colors.grey[100],
                                    blurRadius: 4.0,
                                    spreadRadius: 1.0)
                              ],
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Container(
                                  height: 32.0,
                                  width: 32.0,
                                  child: SvgPicture.asset(
                                    'assets/icons/woman-avatar.svg',
                                    color: Theme.of(context).primaryColor,
                                  ),
                                ),
                                Container(
                                  padding: EdgeInsets.all(8.0),
                                  child: Text(
                                    'Female',
                                    style: Theme.of(context).textTheme.subhead,
                                  ),
                                )
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                );
  }

  Widget submitButtonField(AuthService authService, UserService userService){
    return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  child: InkWell(
                    child: Container(
                      padding: EdgeInsets.all(16.0),
                      decoration: BoxDecoration(
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
                                'LET\'S START',
                                style: TextStyle(
                                  fontSize: 20.0,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                      ),
                    ),
                    onTap: (authService.response['status'] ==
                            Status.VerifyingPhoneNumber)
                        ? () {}
                        : () async {
                            if (_phoneKey.currentState.validate()) {
                              _phoneKey.currentState.save();
                              try {
                                FirebaseUser user = await authService.getCurrentUser();
                                await authService.setDisplayName(_displayName);
                                await userService.updateUserDetails(UserModel(
                                  uid: user.uid,
                                  displayName: _displayName,
                                  birthDate: _selectedDate,
                                  // city: selectedCity.cityName,
                                  gender: _selectedGender
                                ));
                                
                              } on PlatformException {
                                print('Error Occured');
                              }
                            }
                          },
                  ),
                );
  }

}

// class CityModel {
//   CityModel(this.cityName, this.pincode);
//   final String cityName, pincode;
//   @override
//   String toString() => cityName;
// }