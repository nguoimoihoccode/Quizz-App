import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart'; 
import 'package:flutter_application_1/models/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluttertoast/fluttertoast.dart';
class AuthService {
  
  FirebaseAuth _auth = FirebaseAuth.instance;
  
  Users ? _userFromFirebaseUser(User? user) {
    return user != null ? Users(uid: user.uid) : null;
  }


  Future signInEmailAndPass(String email, String password) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return userCredential.user;
    } on FirebaseException catch (e){
      if(e.code == 'user-not-found' || e.code == 'wrong-password'){
        Fluttertoast.showToast(msg: 'Invalid email or password.');
      }
      else{
        Fluttertoast.showToast(msg: "An error occurred: ${e.code}");
      }
    }
      
    return null;
  }

  Future signUpEmailAndPass(String email, String password) async {
    try {
      
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      User ? firebaseUser = userCredential.user;
      return _userFromFirebaseUser(firebaseUser); // Sử dụng firebaseUser thay vì User
      // Tiếp tục xử lý với firebaseUser nếu cần
    } catch (e) {
      print(e.toString());
    }
  }

  Future signOut() async{
    try{
      return await _auth.signOut();
    }catch(e){
      print(e.toString());
      return null;
    }
  }

}
