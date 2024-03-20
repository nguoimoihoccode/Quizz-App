// ignore_for_file: use_build_context_synchronously
import 'dart:async';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/views/resultAnswer.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:flutter_application_1/models/question_model.dart';
import 'package:flutter_application_1/services/database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_application_1/widgets/countdowntime.dart';
import 'package:flutter_application_1/widgets/quiz_play_widgets.dart';
import 'package:flutter_application_1/widgets/widgets.dart';

class PlayQuiz extends StatefulWidget {
  const PlayQuiz({super.key, required this.quizId, required this.userId});
  final String quizId;
  final String userId;

  @override
  _PlayQuizState createState() => _PlayQuizState();
}
int _correct = 0;
int _incorrect = 0;
int _notAttempted = 0;
int total = 0;
Stream<List<int>>? infoStream;
int countdownTime = 100;

class _PlayQuizState extends State<PlayQuiz> {
  
  DatabaseService databaseService = new DatabaseService();
  QuerySnapshot? questionsSnapshot;
  Map<String, String> questionAnswerMap = {};
  late List<String> correctAnswer = [];

  QuestionModel getQuestionModelFromDatasnapshot(
    DocumentSnapshot questionSnapshot) {
      QuestionModel questionModel = new QuestionModel();

      questionModel.question = questionSnapshot["question"];
      /// shuffling the options
      List<String> options = [
        questionSnapshot["option1"],
        questionSnapshot["option2"],
        questionSnapshot["option3"],
        questionSnapshot["option4"]
      ];
      options.shuffle();
      
      questionModel.option1 = options[0];
      questionModel.option2 = options[1];
      questionModel.option3 = options[2];
      questionModel.option4 = options[3];
      questionModel.correctOption = questionSnapshot["option1"];
      questionModel.answered = false;
      for (int i = 0; i < 4; i++) {
        if(questionModel.correctOption == options[i]){
          switch (i) {
            case 0:
              correctAnswer.add("A");
              break;
            case 1:
              correctAnswer.add("B");
              break;
            case 2:
              correctAnswer.add("C");
              break;
            default:
              correctAnswer.add("D");
          }
        }
      }
      return questionModel;
    }
  
  @override
  void initState() {
    databaseService.getQuestionData(widget.quizId).then((value){
      questionsSnapshot = value;
      total = questionsSnapshot!.docs.length;
      for (int i = 1; i <= total; i++) {
        String questionKey = 'Câu $i';
        questionAnswerMap[questionKey] = ""; 
      }
      _notAttempted = total;
      _correct = 0;
      _incorrect = 0;
      setState(() {
        correctAnswer =[];
      });
    });

    infoStream ??= Stream<List<int>>.periodic(
        const Duration(milliseconds: 100),
        (x) => [_correct, _incorrect],
      ).asBroadcastStream();
    
    super.initState();
  }
  void updateOrCreateScore() async {
    for (int i = 0; i < questionAnswerMap.length; i++) {
      String? userAnswer = questionAnswerMap["Câu ${i + 1}"];
      if (userAnswer == correctAnswer[i]) {
        _correct++;
      } else {
        _incorrect++;
      }
    }

    DocumentReference userRef = FirebaseFirestore.instance.collection('Quiz').doc(widget.quizId).collection("Scores").doc(widget.userId); 
    DocumentSnapshot doc = await userRef.get();

    if (doc.exists) {
      if(doc['highScore'] < _correct){
        await userRef.update({
          'highScore': _correct
        });
      }
    } else {
      await userRef.set({
        'highScore': _correct
      });
    }

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => ResultsAns(
          userId: widget.userId,
          questionAnswerMap: questionAnswerMap,
          correctAnswer: correctAnswer,
        ),
      ),
    );
  }
  
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: AppLogo(),
        elevation: 0.0,
        backgroundColor: Colors.transparent,
      ),
      body: Column(
  children: [
    Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        ElevatedButton(
          onPressed: () {
            print(correctAnswer);
            showDialog(
              context: context,
              builder: (_) => AlertDialog(
                title: Text("your_exam".tr()),
                content: SizedBox(
                  width: MediaQuery.of(context).size.width * 0.8,
                  child: GridView.count(
                    crossAxisCount: 3,
                    childAspectRatio: 1.0,
                    padding: const EdgeInsets.all(4.0),
                    mainAxisSpacing: 4.0,
                    crossAxisSpacing: 4.0,
                    children: questionAnswerMap.entries.map((entry) {
                      return GestureDetector(
                        child: Padding(
                          padding: EdgeInsets.all(8),
                          child: Text(
                            "${entry.key}: ${entry.value}",
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                            maxLines: 1,
                          ),
                        ),
                        onTap: () {
                          Navigator.of(context).pop();
                        },
                      );
                    }).toList(),
                  ),
                ),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text("close".tr()),
                  ),
                ],
              ),
            );
          },
          child: Text("answer_sheet".tr()),
        ),
        CountdownWidget(
          onFinished: () {
            updateOrCreateScore();
          },
        ),
        ElevatedButton(
          onPressed: () {
            updateOrCreateScore();
          },
          child: Icon(Icons.check),
        ),
      ],
    ),
    SizedBox(height: 10),
    Expanded(
      child: SingleChildScrollView(
        child: Container(
          child: Column(
            children: [
              questionsSnapshot == null
                  ? Container(
                      child: Center(child: CircularProgressIndicator()),
                    )
                  : ListView.builder(
                      padding: EdgeInsets.symmetric(horizontal: 24),
                      shrinkWrap: true,
                      physics: ClampingScrollPhysics(),
                      itemCount: questionsSnapshot!.docs.length,
                      itemBuilder: (context, index) {
                        return QuizPlayTile(
                          questionModel: getQuestionModelFromDatasnapshot(
                            questionsSnapshot!.docs[index],
                          ),
                          index: index,
                          questionAnswerMap: questionAnswerMap,
                        );
                      },
                    ),
            ],
          ),
        ),
      ),
    ),
  ],
)

    );
  }
  
} 

class QuizPlayTile extends StatefulWidget {
  const QuizPlayTile( {super.key, required this.questionModel, required this.index, required this.questionAnswerMap});
  
  final QuestionModel questionModel;
  final int index;
  final Map<String, String> questionAnswerMap;
  @override
  _QuizPlayTileState createState() => _QuizPlayTileState();
}

class _QuizPlayTileState extends State<QuizPlayTile> {
  String optionSelected = "";
  String option = "";

  final FlutterTts flutterTts = FlutterTts();
  bool isSpeaking = false;
  

  Future<void> speak(String text) async {
    await flutterTts.setLanguage("vi-VN");
    await flutterTts.speak(text);
  }

  Future<void> stopSpeaking() async {
    if (isSpeaking) {
      await flutterTts.stop();
      setState(() {
        isSpeaking = false; // Dừng đọc
      });
    }
  }
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  "Câu ${widget.index+1}: ${widget.questionModel.question}",
                  style: TextStyle(fontSize: 18, color: Colors.black87),
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  if (isSpeaking) {
                    stopSpeaking();
                  } else {
                    setState(() {
                      isSpeaking = true;
                    });
                    speak('Câu ${widget.index+1}: ${widget.questionModel.question}');
                  }
                },
                child: Text(isSpeaking ? "stop".tr() : "listen".tr()),
              ),
            ],
          ),
          SizedBox(height: 12,),
          
          GestureDetector(
            onTap: () {
              option ="A";
              optionSelected = widget.questionModel.option1;
              updateAnswerMap();
            },
            
            child: OptionTile(
              option: "A",
              description: "${widget.questionModel.option1}",
              optionSelected: optionSelected,
            ),
          ),
          SizedBox(height: 4,),
          GestureDetector(
            onTap: () {
              option ="B";

              optionSelected = widget.questionModel.option2;
              updateAnswerMap();
            },
            child: OptionTile(
              option: "B",
              description: "${widget.questionModel.option2}",
              optionSelected: optionSelected,
            ),
          ),
          SizedBox(height: 4,),
          GestureDetector(
            onTap: () {
              option ="C";
              optionSelected = widget.questionModel.option3;
              updateAnswerMap();
            },
            child: OptionTile(
              option: "C",
              description: widget.questionModel.option3,
              optionSelected: optionSelected,
            ),
          ),
          SizedBox(height: 4,),
          GestureDetector(
            onTap: () {
              option ="D";
              optionSelected = widget.questionModel.option4;
              updateAnswerMap();
            },
            child: OptionTile(
              option: "D",
              description: widget.questionModel.option4,
              optionSelected: optionSelected,
            ),
          ),
          SizedBox(height: 20,),
        ],
      ),
      
    );
  }
  void updateAnswerMap(){
    setState(() {
      widget.questionAnswerMap["Câu ${widget.index + 1}"] = option;
    });
  }
}