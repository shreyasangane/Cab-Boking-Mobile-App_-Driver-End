
import 'package:cabdriver/brand_colors.dart';
import 'package:cabdriver/globalvariables.dart';
import 'package:cabdriver/screen/login.dart';
import 'package:cabdriver/screen/mainpage.dart';
import 'package:cabdriver/screen/vehicleinfo.dart';
import 'package:cabdriver/widgets/ProgressDialog.dart';
import 'package:cabdriver/widgets/TaxiButton.dart';
import 'package:connectivity/connectivity.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_otp/flutter_otp.dart';
import 'dart:math';


FlutterOtp otp= FlutterOtp();

int r;

class RegistrationPage extends StatefulWidget {
  static const String id = 'register';


  @override
  _RegistrationPageState createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  final GlobalKey<ScaffoldState> scaffoldKey = new GlobalKey<ScaffoldState>();



  void showSnackBar(String title) {
    final snackbar = SnackBar(
        content: Text(
          title,
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 15),
        ));
    scaffoldKey.currentState.showSnackBar(snackbar);
  }

  final FirebaseAuth _auth = FirebaseAuth.instance;

  var fullNamedController = TextEditingController();

  var phoneController = TextEditingController();

  var emailController = TextEditingController();

  var passwordController = TextEditingController();

  var otpController = TextEditingController();

  void registerUser() async {

    showDialog(
      barrierDismissible: false,
      context: context,
      //builder is use because ProgressDialog is custome widget
      builder: (BuildContext context)=> ProgressDialog('Regisetering You ...',),
    );


    final FirebaseUser user = (await _auth.createUserWithEmailAndPassword(
      email:emailController.text,
      password: passwordController.text,
    ).catchError((ex){

      Navigator.pop(context);
      PlatformException thisEx=ex;
      showSnackBar(thisEx.message);

    })).user;

    //on successful registration
    Navigator.pop(context);

    if (user != null) {
      DatabaseReference newUserRef= FirebaseDatabase.instance.reference().child('drivers/${user.uid}');

      //Prepare data to be saved on users table
      Map userMap={
        'fullname':fullNamedController.text,
        'email': emailController.text,
        'phone':phoneController.text,
      };

      newUserRef.set(userMap);

      currentFirebaseUser = user;

      //Navigator.pushNamedAndRemoveUntil(context,VehicleInfoPage.id, (route) => false);
      Navigator.pushNamed(context, VehicleInfoPage.id);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: <Widget>[
                SizedBox(
                  height: 30,
                ),
                Image(
                  alignment: Alignment.center,
                  height: 100.0,
                  width: 100.0,
                  image: AssetImage('images/logo.png'),
                ),
                SizedBox(height: 20),
                Text(
                  'Create a Driver\'s Account',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 25, fontFamily: 'Brand-Bold'),
                ),
                Padding(
                  padding: EdgeInsets.all(20.0),
                  child: Column(
                    children: <Widget>[
                      //Name
                      TextField(
                        controller: fullNamedController,
                        keyboardType: TextInputType.text,
                        decoration: InputDecoration(
                            labelText: 'Full Name',
                            labelStyle: TextStyle(
                              fontSize: 14.0,
                            ),
                            hintStyle: TextStyle(
                              color: Colors.grey,
                              fontSize: 10.0,
                            )),
                        style: TextStyle(fontSize: 14),
                      ),

                      SizedBox(
                        height: 2,
                      ),

                      //Email
                      TextField(
                        controller: emailController,
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                            labelText: 'Email Address',
                            labelStyle: TextStyle(
                              fontSize: 14.0,
                            ),
                            hintStyle: TextStyle(
                              color: Colors.grey,
                              fontSize: 10.0,
                            )),
                        style: TextStyle(fontSize: 14),
                      ),

                      SizedBox(
                        height: 2,
                      ),

                      //Phone
                      TextField(
                        controller: phoneController,
                        keyboardType: TextInputType.phone,
                        decoration: InputDecoration(
                            labelText: 'Phone Number',
                            labelStyle: TextStyle(
                              fontSize: 14.0,
                            ),

                            hintStyle: TextStyle(
                              color: Colors.grey,
                              fontSize: 10.0,
                            )),
                        style: TextStyle(fontSize: 14),
                      ),

                      FlatButton(
                        onPressed: () {

                          int minNumber = 1000;
                          int maxNumber = 6000;
                          String countryCode ="+91";
                          var now = new DateTime.now();
                          Random rnd = new Random(now.millisecondsSinceEpoch);
                          r = minNumber + rnd.nextInt(maxNumber - minNumber);

                          String OTP= r.toString();

                          if(phoneController.text.length != 10){
                            showSnackBar('Please provide a valid phone number');
                            return;
                          }

                          otp.sendOtp(phoneController.text, OTP,
                              minNumber, maxNumber, countryCode);
                        },
                        child: Text('Send OTP to verify phone'),
                      ),


                      //Enter OTP

                      TextField(
                        controller: otpController,
                        keyboardType: TextInputType.phone,
                        decoration: InputDecoration(
                            labelText: 'Enter OTP',
                            labelStyle: TextStyle(
                              fontSize: 14.0,
                            ),
                            hintStyle: TextStyle(
                              color: Colors.grey,
                              fontSize: 10.0,
                            )),
                        style: TextStyle(fontSize: 14),
                      ),

                      SizedBox(
                        height: 2,
                      ),


                      //Password
                      TextField(
                        controller: passwordController,
                        obscureText: true,
                        decoration: InputDecoration(
                            labelText: 'Password',
                            labelStyle: TextStyle(
                              fontSize: 14.0,
                            ),
                            hintStyle: TextStyle(
                              color: Colors.grey,
                              fontSize: 10.0,
                            )),
                        style: TextStyle(fontSize: 14),
                      ),

                      SizedBox(
                        height: 40,
                      ),

                      TaxiButton(
                        title: 'REGISTER',
                        color: BrandColors.colorAccentPurple,
                        onPressed: () async {

                          //check network availability
                          var connectivityResult = await Connectivity().checkConnectivity();

                          if(r.toString() !=otpController.text){
                            showSnackBar('Please enter valid otp');
                            return;
                          }



                          if(connectivityResult != ConnectivityResult.mobile && connectivityResult != ConnectivityResult.wifi){
                            showSnackBar('No Internet Connectivity');
                            return;
                          }

                          if(fullNamedController.text.length <3){
                            showSnackBar('Please provide a valid fullname');
                            return;
                          }



                          if(!emailController.text.contains('@')){
                            showSnackBar('Please provide a valid email address');
                            return;
                          }

                          if(phoneController.text.length != 10){
                            showSnackBar('Please provide a valid phone number');
                            return;
                          }

                          if(passwordController.text.length <8){
                            showSnackBar('Password must be atleast 8 characters');
                            return;
                          }

                          registerUser();
                        },
                      ),
                    ],
                  ),
                ),
                FlatButton(
                  onPressed: () {
                    Navigator.pushNamedAndRemoveUntil(
                        context, LoginPage.id, (route) => false);
                  },
                  child: Text('Already have an Driver account? Log In'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
