import 'package:flutter/material.dart';
import 'package:flutter_application_1/admin/navbar.dart';
import 'package:flutter_application_1/admin/updateQuizz.dart';
import 'package:flutter_application_1/services/database.dart';
import 'package:flutter_application_1/views/create_quiz.dart';
import 'package:flutter_application_1/widgets/widgets.dart';

class HomeAdmin extends StatefulWidget {
  final String userId;
  const HomeAdmin({super.key, required this.userId});

  @override
  _HomeAdminState createState() => _HomeAdminState();
}

class _HomeAdminState extends State<HomeAdmin> {
  late Stream quizStream = const Stream.empty();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  String selectedQuizStatus = "0";
  DatabaseService databaseService = DatabaseService();
  
  Widget quizList() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24),
      child: StreamBuilder(
        stream: quizStream,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            var quizData = snapshot.data!.docs;
            if (quizData != null) {
              // Lọc danh sách câu hỏi dựa vào quizStatus
              var filteredQuizData = quizData.where((quiz) => quiz["quizStatus"] == selectedQuizStatus).toList();
              
              return ListView.builder(
                itemCount: filteredQuizData.length,
                itemBuilder: (context, index) {
                  var quiz = filteredQuizData[index];
                  return QuizTile(
                    imgUrl: quiz["quizImageUrl"],
                    desc: quiz["quizDesc"],
                    title: quiz["quizTitle"],
                    quizId: quiz["quizId"],
                    quizStatus: quiz["quizStatus"]
                  );
                },
              );
            }
          }
          return Container();
        },
      ),
    );
  }

  @override
  void initState() {
    databaseService.getQuizData().then((val) {
      setState(() {
        quizStream = val;
      });
    });
    super.initState();
  }

  @override
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      drawer: DrawerWidget2(userId: widget.userId),
      appBar: AppBar(
        title: AppLogo(),
        elevation: 0.0,
        backgroundColor: Colors.transparent,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(40.0),
          child: Column(
            children: [
              Row(
                children: [
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.0),
                  ),
                  DropdownButton<String>(
                    value: selectedQuizStatus,
                    onChanged: (String? newValue) {
                      setState(() {
                        selectedQuizStatus = newValue!;
                      });
                    },
                    items: const [
                      DropdownMenuItem<String>(
                        value: "1",
                        child: Text("Chủ đề của hệ thống"),
                      ),
                      DropdownMenuItem<String>(
                        value: "0",
                        child: Text("Chủ đề người dùng yêu cầu thêm"),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      body: quizList(),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => CreateQuiz(userId: widget.userId),
            ),
          );
        },
      ),
    );
  }
}

class QuizTile extends StatelessWidget {
  const QuizTile({
    super.key,
    required this.imgUrl,
    required this.title,
    required this.desc,
    required this.quizId, 
    required this.quizStatus,
  });

  final String imgUrl, title, desc, quizId, quizStatus;
  
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => UpdateQuizz(quizId: quizId),
            ),
          );
      },
      child: Container(
        
        margin: const EdgeInsets.only(bottom: 8),
        height: 150,
        child: Stack(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.network(
                imgUrl,
                width: MediaQuery.of(context).size.width - 48,
                fit: BoxFit.cover,
              ),
            ),
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: Colors.black26,
              ),
              alignment: Alignment.center,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 17,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    desc,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}