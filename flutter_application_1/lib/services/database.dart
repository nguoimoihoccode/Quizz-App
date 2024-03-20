import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseService{

  Future<void> addQuizData(Map<String, dynamic> quizData, String quizId) async {
    try {
      await FirebaseFirestore.instance
          .collection('Quiz')
          .doc(quizId)
          .set(quizData);
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> addQuestionData(Map<String, dynamic> questionData, String quizId) async {
    await FirebaseFirestore.instance
        .collection("Quiz")
        .doc(quizId)
        .collection("QNA")
        .add(questionData)
        .catchError((e) {
      print(e.toString());
    });
  }
  Future<void> addHighScore(Map<String, dynamic> scoreUsersData, String quizId) async {
    await FirebaseFirestore.instance
        .collection("Quiz")
        .doc(quizId)
        .collection("Scores")
        .add(scoreUsersData)
        .catchError((e) {
      print(e.toString());
    });
  }
  
  
  getQuizData() async {
    return await FirebaseFirestore.instance.collection("Quiz").snapshots();
  }
  
  getQuestionData(String quizId) async{
    return await FirebaseFirestore.instance
        .collection("Quiz")
        .doc(quizId)
        .collection("QNA")
        .get();
  }
  
}