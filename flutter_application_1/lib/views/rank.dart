import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/widgets/widgets.dart';

class TopRankScreen extends StatefulWidget {
  @override
  _TopRankScreenState createState() => _TopRankScreenState();
}

class _TopRankScreenState extends State<TopRankScreen> {
  String selectedTopic = '';
  late String selectedQuizTitle = "";
  late String selectedQuizId = "";
  Map<String, String> quizMap = {};

  List<String> quizTitles = [];
  List<String> quizIds = [];
  List<String> userIds = [];
  List<Map<String, dynamic>> scoresData = [];
  List<Map<String, dynamic>> displayedScoresData = [];
 
  void fetchQuizTitles() async {
    QuerySnapshot snapshot = await FirebaseFirestore.instance.collection("Quiz").get();
    if (snapshot.docs.isNotEmpty) {
      setState(() {
        quizTitles = snapshot.docs
            .map((doc) => (doc.data() as Map<String, dynamic>)["quizTitle"] as String)
            .toList();
        selectedQuizTitle = (quizTitles.isNotEmpty ? quizTitles[0] : null)!;

        quizIds = snapshot.docs
            .map((doc) => (doc.data() as Map<String, dynamic>)["quizId"] as String)
            .toList();
        selectedQuizId = (quizIds.isNotEmpty ? quizIds[0] : null)!;
        for (int i = 0; i < quizTitles.length; i++) {
          quizMap[quizTitles[i]] = quizIds[i];
        }
      });
    }
  }
  
  @override
  void initState() {
    super.initState();
    fetchQuizTitles();
  }
  
  void fetchScores(selectedQuizTitle) async {

    QuerySnapshot scoreSnapshot = await FirebaseFirestore.instance
      .collection("Quiz")
      .doc(quizMap[selectedQuizTitle])
      .collection("Scores")
      .get();
    print(selectedQuizTitle);
    print(quizMap[selectedQuizTitle]);

    for (QueryDocumentSnapshot doc in scoreSnapshot.docs) {
      String userId = doc.id;
      int highScore = (doc.data() as Map<String, dynamic>)['highScore'] as int? ?? 0;
      
      DocumentSnapshot userSnapshot = await FirebaseFirestore.instance
        .collection("users")
        .doc(userId)
        .get();
      Map<String, dynamic> userData = userSnapshot.data() as Map<String, dynamic>;
      String firstName = userData['first name'] as String? ?? "";
      String image = userData['image'] as String? ?? "";

      print(doc.id);
      print(firstName);
      print(highScore);
      
      scoresData.add({
        'userId': userId,
        'firstName': firstName,
        'highScore': highScore,
        'image': image,
        
      });
    }
    setState(() {
      displayedScoresData = List.from(scoresData);
      displayedScoresData.sort((a, b) => b['highScore'].compareTo(a['highScore']));
    });
    
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: AppLogo(),
        elevation: 0.0,
        backgroundColor: Colors.transparent,
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [ 
          Text("rankings".tr(), style: TextStyle( color: Colors.black, fontSize: 20, fontWeight: FontWeight.bold,)),
          Padding(
            padding: const EdgeInsets.all(2.0),
            child: Align(
              alignment: Alignment.center,
              child: DropdownButton<String>(
                value: selectedQuizTitle,
                onChanged: (newValue) {
                  setState(() {
                    selectedQuizTitle = newValue!;
                    fetchScores(selectedQuizTitle);
                    scoresData = [];
                  });
                },
                items: quizTitles.map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
              ),
            ),
          ),
          
          Expanded(
            child: ListView.builder(
              itemCount: displayedScoresData.length,
              itemBuilder: (context, index) {
                final scoreData = displayedScoresData[index];
                final name = scoreData['firstName'];
                final score = scoreData['highScore'];
                final image = scoreData['image'];

                return Card(
                  child: ListTile(
                    leading: CircleAvatar(
                          radius: 30,
                          backgroundImage: image != null
                              ? NetworkImage(image)
                              : AssetImage('assets/avatar.png') as ImageProvider<Object>?,
                        ),
                    title: Text(name),
                    subtitle: Text('Score: $score'),
                  ),
                );
              },
            ),
          ),
        ],
      ),
      )
    );
  }
}
