import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/admin/HomeAdmin.dart';
import 'package:flutter_application_1/helper/functions.dart';
import 'package:flutter_application_1/services/auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_application_1/views/forgot_password_page.dart';
import 'package:flutter_application_1/views/home.dart';
import 'package:flutter_application_1/views/signin.dart';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_application_1/views/signup.dart';
import 'package:flutter_application_1/widgets/widgets.dart';

class SignIn extends StatefulWidget {
  const SignIn({super.key});

  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {

  final _formKey = GlobalKey<FormState>();
  late String email, password;
  late String userId = "";
  AuthService authService = new AuthService();
  bool isLoading = false;
  int loginAttempts = 0;
  
  _SignIn() async{
    if(_formKey.currentState!.validate()){
      setState(() {
        isLoading = true;
      });
     
      await authService.signInEmailAndPass(email.trim(), password).then((val)async{
        if(val != null){

          // đọc userId
          userId = FirebaseAuth.instance.currentUser!.uid;
          // Kiểm tra nếu tài khoản là admin
          bool isAdmin = await checkIfAdmin(email, password);

          setState(() {
            isLoading = false;
          });
         
          if (isAdmin) {
            HelperFunctions.saveUserLoggedInDetails(isLoggedin: false);
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => HomeAdmin(userId: userId)),
            );
          } else {
            HelperFunctions.saveUserLoggedInDetails(isLoggedin: false);
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => Home(userId: userId)),
            );
          }
        }
        else{
          setState(() {
            isLoading = false;
          });
         
          Navigator.pushReplacement(context, MaterialPageRoute(
            builder: (context) => SignIn()
          ));
        }
      });
    }
  }

  Future<bool> checkIfAdmin(String email, String password) async {
    // Thực hiện kiểm tra xem userId có phải là của admin hay không
    if(email != "talitran1002@gmail.com" || password != "admin123"){
      return false;
    }
    return true;
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: AppLogo(),
        elevation: 0.0,
        backgroundColor: Colors.transparent,
      ),
      body: isLoading ? Container(
        child: Center(
          child: CircularProgressIndicator(),
        ),
      ) : Form(
        key: _formKey,
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 24),
          //color: Colors.blue,
          child: Column(
            children: [
              Spacer(),
              TextFormField(
                validator: (val){
                  return val!.isEmpty ? "enter_email".tr() : null;
                },
                decoration: InputDecoration(
                  hintText: "Email"
                ),
                onChanged: (val){
                  email = val;
                },
              ),
              SizedBox(height:  6),
              TextFormField(
                obscureText: true,
                validator: (val){
                  return val!.isEmpty ? "enter_pass".tr() : null;
                },
                decoration: InputDecoration(
                  hintText: "pass".tr()
                ),
                onChanged: (val){
                  password = val;
                },
              ),
              SizedBox(height: 10,),
              Padding(padding: const EdgeInsets.symmetric(horizontal: 25.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context, 
                          MaterialPageRoute(
                            builder: (context) {
                              return ForgotPasswordPage();
                            },
                          ),
                        );
                      },
                      child: Text(
                        "forgot_pass".tr(),
                        style: TextStyle(color: Colors.blue,fontWeight: FontWeight.bold,),
                      ),
                    )
                  ],
                ),
              ),

              SizedBox(height:  14),
              GestureDetector(
                onTap: (){
                  _SignIn();
                },
                child: blueButton(context : context, label : "_signin".tr()),
              ),
              SizedBox(height: 18),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("no_account".tr() + ' ', style: TextStyle(fontSize: 15.5),),
                  GestureDetector(
                    onTap: (){
                      Navigator.pushReplacement(context, MaterialPageRoute(
                        builder: (context) => SignUp()
                      ));
                    },
                    child: Text("_signup".tr(), style: TextStyle(fontSize: 15.5, decoration:  TextDecoration.underline),))

                ],
              ),
              SizedBox(height:  80),

            ],
          )
        )
      ),
    );
  }
}
