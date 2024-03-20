import 'dart:io';
import 'dart:math';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_application_1/services/database.dart';
import 'package:flutter_application_1/views/addquestion.dart';
import 'package:flutter_application_1/widgets/widgets.dart';
import 'package:image_picker/image_picker.dart';

class CreateQuiz extends StatefulWidget {
  final String userId;
  const CreateQuiz({super.key, required this.userId});

  @override
  _CreateQuizState createState() => _CreateQuizState();
}

class _CreateQuizState extends State<CreateQuiz> {

  final _formKey = GlobalKey<FormState>();
  late String  quizTitle, quizDescription, quizId;
  String quizImageUrl = "";
  DatabaseService databaseService = new DatabaseService();

  bool _isLoading = false;

  CreateQuizOnline() async{
    
    if(_formKey.currentState!.validate()){

      setState(() {
        _isLoading = true;
      });
      Map<String, String> quizMap = {};
      quizId = randomAlphaNumeric(16);

      if(widget.userId == "9ldW7rXuIZeRZWUPLYE7oLBq8kz2"){
        quizMap = {
        "quizId" : quizId,
        "quizImageUrl" : quizImageUrl,
        "quizTitle" : quizTitle,
        "quizDesc" : quizDescription,
        "quizUserIdCreate" : widget.userId,
        "quizStatus" : "1"

        };
      }
      else{
        quizMap = {
        "quizId" : quizId,
        "quizImageUrl" : quizImageUrl,
        "quizTitle" : quizTitle,
        "quizDesc" : quizDescription,
        "quizUserIdCreate" : widget.userId,
        "quizStatus" : "0"
        };
      }
      await databaseService.addQuizData(quizMap, quizId).then((value){
        setState(() {
          _isLoading = false;
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>  AddQuestion(quizId)));
        });
      });
    }
  }
  String randomAlphaNumeric(int length) {
  final random = Random();
  const chars = 'abcdefghijklmnopqrstuvwxyz0123456789';
  String result = '';

  for (int i = 0; i < length; i++) {
    final randomIndex = random.nextInt(chars.length);
    result += chars[randomIndex];
  }

  return result;
}

  // Hàm để chọn ảnh từ thư viện
  void _pickImage() async {
    
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
  
    if (pickedFile != null) {
      final file = File(pickedFile!.path!);
      final path = 'files/${pickedFile!.name}';
      
      final ref = FirebaseStorage.instance.ref().child(path);
      var uploadTask = ref.putFile(file);
      
      try {
        await uploadTask.whenComplete(() {});
        final snapshot = await ref.getDownloadURL();

        setState(() {
          quizImageUrl = snapshot;
        });
      } catch (error) {
        print('Lỗi: $error');
      }

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
      body: _isLoading ?  Container(
        child : Center(child: CircularProgressIndicator(),),
      ) : Form(
        key: _formKey,
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 24),
          child: Column(children: [
           
            Container(
              width: 350,
              height: 200,
              decoration: BoxDecoration(
                image: quizImageUrl.isNotEmpty ? DecorationImage(image: NetworkImage(quizImageUrl), fit: BoxFit.cover) : null,
                color: Colors.blue,
                borderRadius: BorderRadius.circular(8),
              ),
              child: quizImageUrl.isEmpty ? Icon(Icons.person, size: 50) : null,
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: _pickImage,
              child: Text("pick_image".tr()),
            ),

            SizedBox(height: 6,),

            TextFormField(
              validator: (val) => val!.isEmpty ? "enter_quiz_title".tr(): null,
              decoration: InputDecoration(
                hintText: "quiz_title".tr(),
              ),
              onChanged: (val){
                quizTitle = val;
              },
            ),

            SizedBox(height: 6,),
            
            TextFormField(
              validator: (val) => val!.isEmpty ? "enter_quiz_desc".tr(): null,
              decoration: InputDecoration(
                hintText: "quiz_desc".tr(),
              ),
              onChanged: (val){
                quizDescription = val;
              },
            ),
            
            SizedBox(height: 6,),
            
            Spacer(),
            
            GestureDetector(
              onTap: (){
                CreateQuizOnline();
              },
              child: blueButton(context: context, label : "create_quiz".tr())),
            
            SizedBox(height: 60,),
          ]),
        )
      ),
    );
  }
}