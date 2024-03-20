import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/helper/functions.dart';
import 'package:flutter_application_1/services/auth.dart';
import 'package:flutter_application_1/views/home.dart';
import 'package:flutter_application_1/views/signin.dart';
import 'package:flutter_application_1/widgets/widgets.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});
  //const SignIn({super.key});
  @override
  // ignore: library_private_types_in_public_api
  _SignUpState createState() => _SignUpState();
}
 
class _SignUpState extends State<SignUp> {

  final _formKey = GlobalKey<FormState>();
  late String name, email, password;
  AuthService authService = new AuthService();
  bool _isLoading = false;

  SignUp() async{
    if(_formKey.currentState!.validate()) {
      
      setState(() {
        _isLoading = true;
      });

      authService.signUpEmailAndPass(email, password).then((value)  async {
        
        if(value != null) {
          setState(() {
            _isLoading = false;
          });
        }
        String image = "https://firebasestorage.googleapis.com/v0/b/quiz-4247e.appspot.com/o/files%2Fimages.png?alt=media&token=7d04a0d8-e4e3-476f-a462-895fef97a168";
        await authService.signInEmailAndPass(email, password).then((val)async{
          if(val != null){
            // đọc userId
            String userId = FirebaseAuth.instance.currentUser!.uid;
            setState(() {
              _isLoading = false;
            });
            DocumentReference userRef = FirebaseFirestore.instance.collection('users').doc(userId);

            try {
              DocumentSnapshot doc = await userRef.get();
              print(userRef.get());
              print(doc);
              if(!doc.exists){
                await userRef.set({
                  'image': image,
                  'first name': '',
                  'last name': '',
                  'age': '',
                  'address': '',
                  'statusUser': 1
                });
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text("creatUser_success".tr())),
                );
              }
              // Điều hướng trở lại trang Home
              Navigator.pushReplacement(context, MaterialPageRoute(
                  builder: (context) => SignIn()
              ));
            } catch (error) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text("_error".tr())),
              );
            }
          }
          
        });
      });
    }
    
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
     appBar: AppBar(
        title: AppLogo(),
        elevation: 0.0,
        backgroundColor: Colors.transparent,
      ),
      body: _isLoading ? Container(
        child: Center(child: CircularProgressIndicator(),),
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
                  return val!.isEmpty ? "enter_name".tr() : null;
                },
                decoration: InputDecoration(
                  hintText: "name".tr()
                ),
                onChanged: (val){
                  name = val;

                },
              ),
              SizedBox(height:  6),
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
              SizedBox(height:  6,),
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
              SizedBox(height:  24,),
              GestureDetector(
                onTap: (){
                  SignUp();
                },
                child: blueButton(context : context, label: "_signup".tr()),
                
              ),
              SizedBox(height: 18),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("true_account".tr() + ' ', style: TextStyle(fontSize: 15.5),),
                  GestureDetector(
                    onTap: (){
                      Navigator.pushReplacement(context, MaterialPageRoute(
                        builder: (context) => SignIn()
                      ));
                    },
                    
                    child: Text("_signin".tr(), style: TextStyle(fontSize: 15.5, decoration:  TextDecoration.underline),))

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
