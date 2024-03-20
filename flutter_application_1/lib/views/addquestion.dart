import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/services/database.dart';
import 'package:flutter_application_1/views/home.dart';
import 'package:flutter_application_1/widgets/widgets.dart';

class AddQuestion extends StatefulWidget {
  final String quizId;
  const AddQuestion(this.quizId);
  @override
  _AddQuestionState createState() => _AddQuestionState();
}

class _AddQuestionState extends State<AddQuestion> {

  final _formKey = GlobalKey<FormState>();
  late String question, option1, option2, option3, option4;
  bool _isLoading = false;
  DatabaseService databaseService = new DatabaseService();



  uploadQuestionData() {

    if (_formKey.currentState!.validate()) {

      setState(() {
        _isLoading = true;
      });

      Map<String, String> questionMap = {
        "question": question,
        "option1": option1,
        "option2": option2,
        "option3": option3,
        "option4": option4
      };
      

      print("${widget.quizId}");
      databaseService.addQuestionData(questionMap, widget.quizId).then((value) {
        question = "";
        option1 = "";
        option2 = "";
        option3 = "";
        option4 = "";
        setState(() {
          _isLoading = false;
        });

      }).catchError((e){
        print(e);
      });

      

    }else{
      print("error is happening ");
    }
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: AppLogo(),
        elevation: 0.0,
        backgroundColor: Colors.transparent,
        //brightness: Brightness.li,
      ),
      body: _isLoading ? Container(
        child: Center(
          child: CircularProgressIndicator(),
        ),
      ): Form(
        key: _formKey,
        child: Container(
            padding: EdgeInsets.symmetric(horizontal: 24),
        
          child: Column(children: [
            TextFormField(
                validator: (val) => val!.isEmpty ? "enter_ques".tr(): null,
                decoration: InputDecoration(
                  hintText: "_ques".tr(),
                ),
                onChanged: (val){
                  question = val;
                },
              ),
        
              SizedBox(height: 6,),
        
              TextFormField(
                validator: (val) => val!.isEmpty ? "enter_op1".tr(): null,
                decoration: InputDecoration(
                  hintText: "enter_op1_correct".tr(),
                ),
                onChanged: (val){
                  option1 = val;
                },
              ),
        
              SizedBox(height: 6,),
              
              TextFormField(
                validator: (val) => val!.isEmpty ? "enter_op2".tr(): null,
                decoration: InputDecoration(
                  hintText: "option2".tr(),
                ),
                onChanged: (val){
                  option2 = val;
                },
              ),
              
              SizedBox(height: 6,),
              TextFormField(
                validator: (val) => val!.isEmpty ? "enter_op3".tr(): null,
                decoration: InputDecoration(
                  hintText: "option3".tr(),
                ),
                onChanged: (val){
                  option3 = val;
                },
              ),
              SizedBox(height: 6,),
              TextFormField(
                validator: (val) => val!.isEmpty ? "enter_op4".tr(): null,
                decoration: InputDecoration(
                  hintText: "option4".tr(),
                ),
                onChanged: (val){
                  option4 = val;
                },
              ),
              
              Spacer(),
              Row(
                children: [
                  GestureDetector(
                    onTap: (){
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => Home(userId: "9ldW7rXuIZeRZWUPLYE7oLBq8kz2",)),

                      );
                    },
                    child: blueButton(context : context, label: "sumbit".tr(), buttonWidth : MediaQuery.of(context).size.width/2 - 36)),
                  SizedBox(width: 24,),
                  
                  GestureDetector(
                    onTap: (){
                      uploadQuestionData();
                    },
                    child: blueButton(context : context, label: "add_ques".tr(), buttonWidth : MediaQuery.of(context).size.width/2 - 36)),
                ],
              )
             
          ],),
        ),
      ),
    );
  }
}