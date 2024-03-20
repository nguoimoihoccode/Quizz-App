import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/views/home.dart';
import 'package:flutter_application_1/widgets/widgets.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';

class ResultsAns extends StatefulWidget {
  const ResultsAns({super.key, 
                    required this.userId, 
                    required this.questionAnswerMap, 
                    required this.correctAnswer,});
  final String userId;                  
  final Map<String, String> questionAnswerMap;
  final List<String> correctAnswer;
  @override
  State<ResultsAns> createState() => _ResultsAnsState();
}

int _correct = 0;
int _incorrect = 0;
int _notAttempted = 0;
int total = 0;
  
class _ResultsAnsState extends State<ResultsAns> {
  @override
  void initState(){
    _correct = 0;
    _incorrect = 0;
    total = widget.questionAnswerMap.length;
    getInfo();
    
    super.initState();
  }

  void getInfo(){
    for (int i = 0; i < widget.questionAnswerMap.length; i++) {
      String? userAnswer = widget.questionAnswerMap["Câu ${i + 1}"];
      if (userAnswer == widget.correctAnswer[i]) {
        _correct++;
      } else {
        _incorrect++;
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
      body: Container(
        color: Colors.white10,
        padding: const EdgeInsets.all(8),
        
        child: Column(
          children: [
            
            // Lấy số lượng câu trả lời đúng thêm vào Limit
            Text("mark".tr(), style: TextStyle(color: Colors.black),maxLines: 1,),
            LinearPercentIndicator(lineHeight: 20,
              percent: _correct/total,
              backgroundColor: Colors.brown,
              progressColor: Colors.red,
            ),
            
            // Lấy số lượng câu trả lời đúng thêm vào Your mark
            Padding(padding: const EdgeInsets.all(8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(children: [
                Container(width: 20,height: 20,color: Colors.green,),
                const SizedBox(width: 10,),
                 Text("correct".tr()),
              ],),
              Row(children: [
                Container(width: 20,height: 20,color: Colors.red,),
                const SizedBox(width: 10,),
                 Text("wrong".tr()),
              ],),
              Row(children: [
                Container(width: 20,height: 20,color: Colors.grey,),
                const SizedBox(width: 10,),
                 Text("not_answer".tr()),
                
              ],),
            ],),
            ),
          
            Expanded(
              child: GridView.count(
                crossAxisCount: 5,
                childAspectRatio: 1.0,
                padding: const EdgeInsets.all(4.0),
                mainAxisSpacing: 4.0,
                crossAxisSpacing: 4.0,
                children: widget.questionAnswerMap.entries.map((entry) {
                  final question = entry.key;
                  final userAnswer = entry.value;
                  final correctAnswer = widget.correctAnswer[widget.questionAnswerMap.keys.toList().indexOf(question)];

                  Color cardColor;
                  if (userAnswer == correctAnswer) {
                    cardColor = Colors.green;
                  } else if (userAnswer == "") {
                    cardColor = Colors.grey;
                  } else {
                    cardColor = Colors.red;
                  }

                  return Card(
                    elevation: 2,
                    color: cardColor,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                            Text(
                              
                              question,
                              style: TextStyle(
                                color: cardColor == Colors.white ? Colors.black : Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                              maxLines: 1,
                              textAlign: TextAlign.center,
                            ),
                            SizedBox(width: 10),
                            Text(
                              userAnswer,
                              style: TextStyle(
                                color: cardColor == Colors.white ? Colors.black : Colors.white,
                              ),
                            ),
                      ],
                    ),
                  );
                }).toList(),
              ),
            ),
            GestureDetector(
              onTap: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => Home(userId: widget.userId,)),
                );
              },
              child: blueButton(
                context: context,
                 label: "go_home".tr(), buttonWidth: MediaQuery.of(context).size.width/2),)
          ],
        ),
      ),
    );
  }
}