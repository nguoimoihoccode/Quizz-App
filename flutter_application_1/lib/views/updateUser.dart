import 'dart:io';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_application_1/views/home.dart';
import 'package:flutter_application_1/views/play_quiz.dart';
import 'package:path/path.dart' as path;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';

class UpdateUser extends StatefulWidget {
  final String userId;
  UpdateUser({required this.userId});

  @override
  _UpdateUserState createState() => _UpdateUserState();
}

class _UpdateUserState extends State<UpdateUser> {
  late TextEditingController _fnameController;
  late TextEditingController _lnameController;
  late TextEditingController _ageController;
  late TextEditingController _addressController;
  String _avatarURL = ""; // Đường dẫn của ảnh avatar
  UploadTask ? uploadTask;  
  @override
  void initState() {
    super.initState();
    _fnameController =  TextEditingController();
    _lnameController = TextEditingController();
    _ageController = TextEditingController();
    _addressController = TextEditingController();
    _fetchUserData();
  }
  
  @override
  void dispose() {
    _fnameController.dispose();
    _lnameController.dispose();
    _ageController.dispose();
    _addressController.dispose();
    //infoStream = null;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final currentLocale = EasyLocalization.of(context)?.locale;
    print(currentLocale);
    return Scaffold(
      appBar: AppBar(
        title: Text( "update_user".tr()),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: ListView(
          children: [
            CircleAvatar(
              radius: 50,
              backgroundImage: _avatarURL.isNotEmpty ? NetworkImage(_avatarURL) : null,
              child: _avatarURL.isEmpty ? Icon(Icons.person, size: 50) : null,
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: _pickImage,
              child: Text("pick_image".tr()),
            ),
            TextFormField(
              controller: _fnameController,
              decoration: InputDecoration(labelText: "first_name".tr()),
            ),
            TextFormField(
              controller: _lnameController,
              decoration: InputDecoration(labelText: "last_name".tr()),
            ),
            TextFormField(
              controller: _ageController,
              decoration: InputDecoration(labelText: "age".tr()),
              keyboardType: TextInputType.number,
            ),
            TextFormField(
              controller: _addressController,
              decoration: InputDecoration(labelText: "address".tr()),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                if (_validateData()) {
                  _updateUser();
                }
              },
              child: Text("update".tr()),
            ),
          ],
        ),
      ),
    );
  }

  // Hàm để chọn ảnh từ thư viện
  void _pickImage() async {
    
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
  
    if (pickedFile != null) {
      final file = File(pickedFile!.path!);
      final path = 'files/${pickedFile!.name}';
      
      final ref = FirebaseStorage.instance.ref().child(path);
      uploadTask = ref.putFile(file);
      
      final snapshot = await uploadTask!.whenComplete(() {});

      _avatarURL = await snapshot.ref.getDownloadURL();
      print(_avatarURL);

    }
  }

  // Hàm để lấy dữ liệu người dùng từ Firestore
  void _fetchUserData() async {
    try {
      DocumentSnapshot userSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(widget.userId)
          .get();

      if (userSnapshot.exists) {
        Map<String, dynamic> userData = userSnapshot.data() as Map<String, dynamic>;
        setState(() {
          _fnameController.text = userData['first name'] ?? '';
          _lnameController.text = userData['last name'] ?? '';
          _ageController.text = (userData['age'] ?? 0).toString();
          _addressController.text = userData['address'] ?? '';
          _avatarURL = userData['image'] ?? '';
        });
      }
    } catch (error) {
      print("_error".tr() + '$error');
    }
  }

  // Hàm để cập nhật thông tin người dùng
  Future<void> _updateUser() async {
    String firstName = _fnameController.text.trim();
    String lastName = _lnameController.text.trim();
    int age = int.tryParse(_ageController.text) ?? 0;
    String address = _addressController.text.trim();
    print(widget.userId);
    DocumentReference userRef = FirebaseFirestore.instance.collection('users').doc(widget.userId);
    print(userRef);
    try {
      DocumentSnapshot doc = await userRef.get();
      print(userRef.get());
      print(doc);
      if(doc.exists){
        await userRef.update({
          'image': _avatarURL,
          'first name': firstName,
          'last name': lastName,
          'age': age,
          'address': address,
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("updateUser_success".tr())),
        );
      }
      else{
        await userRef.set({
          'image': _avatarURL,
          'first name': firstName,
          'last name': lastName,
          'age': age,
          'address': address,
          'statusUser': 1
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("creatUser_success".tr())),
        );
      }
      
      // Điều hướng trở lại trang Home
      Navigator.pushReplacement(context, MaterialPageRoute(
          builder: (context) => Home(userId: widget.userId)
        ));

    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("updateUser_fail".tr())),
      );
      print(error);

    }
    
  }

  // Hàm kiểm tra dữ liệu
bool _validateData() {
  if (_fnameController.text.trim().isEmpty) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Please enter first name")),
    );
    return false;
  }

  if (_lnameController.text.trim().isEmpty) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Please enter last name")),
    );
    return false;
  }

  if (_ageController.text.trim().isEmpty) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Please enter age")),
    );
    return false;
  }

  int? age = int.tryParse(_ageController.text);
  if (age == null || age <= 0) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Please enter a valid age")),
    );
    return false;
  }

  if (_addressController.text.trim().isEmpty) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Please enter address")),
    );
    return false;
  }

  return true;
}
}
