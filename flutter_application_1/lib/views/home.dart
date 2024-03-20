import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/services/database.dart';
import 'package:flutter_application_1/views/DrawerWidget.dart';
import 'package:flutter_application_1/views/create_quiz.dart';
import 'package:flutter_application_1/views/play_quiz.dart';
import 'package:flutter_application_1/widgets/widgets.dart';
import 'package:easy_localization/easy_localization.dart';

class Home extends StatefulWidget {
  final String userId;

  const Home({Key? key, required this.userId}) : super(key: key);
  @override
  
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  
  String searchText = '';
  late Stream quizStream = Stream.empty();
  DatabaseService databaseService = new DatabaseService();
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  Widget quizList() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 24),
      child: StreamBuilder(
        stream: quizStream,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            var quizData = snapshot.data!.docs; // get data from _JsonQuerySnapshot
            if (quizData != null) {
              // Xử lý dữ liệu và hiển thị danh sách câu hỏi
              var filteredData = quizData.where((quiz) {
                final title = quiz["quizTitle"].toString().toLowerCase();
                final status = quiz["quizStatus"].toString();
                return title.contains(searchText.toLowerCase()) && status == "1";
              }).toList();
              if (filteredData.isNotEmpty) {
                return ListView.builder(
                  itemCount: filteredData.length,
                  itemBuilder: (context, index) {
                    var quiz = filteredData[index];
                    return QuizTile(
                      imgUrl: quiz["quizImageUrl"],
                      desc: quiz["quizDesc"],
                      title: quiz["quizTitle"],
                      quizId: quiz["quizId"],
                      userId: widget.userId,
                    );
                  },
                );
              } else {
                // Hiển thị thông báo nếu không tìm thấy kết quả
                return Center(
                  child: Text("Không tìm thấy kết quả"),
                );
              }
            }
          }
          return Container();
        },
      ),
    );
  }

  @override
  void initState() {
    databaseService.getQuizData().then((val){
      setState(() {
        quizStream = val;
      });
    });
    super.initState();
    
  }   

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: AppLogo(),
        elevation: 0.0,
        backgroundColor: Colors.transparent,
      ),
      drawer: DrawerWidget(userId: widget.userId),
      body: Container(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              decoration: InputDecoration(
                labelText: "find_topic".tr(),
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
              onChanged: (value) {
                setState(() {
                  searchText = value;
                });
              },
            ),
            SizedBox(height: 16), // Khoảng cách giữa ô tìm kiếm và danh sách
            Expanded(
              child: quizList(),
            ),
            
          ],
          
        ),
      ),
      //body: quizList(),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: (){
          Navigator.push(context, MaterialPageRoute(builder: (context ) => CreateQuiz(userId: widget.userId,)));
        },
      ),
    );
  }
}

class QuizTile extends StatelessWidget {
  const QuizTile({super.key, required this.imgUrl, required this.title, required this.desc, required this.quizId, required this.userId});
  final String imgUrl, title, desc, quizId, userId;
  
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      
      onTap: () async {
        DocumentSnapshot userSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .get();

        if (userSnapshot.exists) {
          Map<String, dynamic> userData = userSnapshot.data() as Map<String, dynamic>;
          if(userData['statusUser'] == 0){
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=> Home(userId: userId)));
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text("Tài khoản bạn đã bị khoá không thể làm bài. Vui lòng vào phần góp ý để gửi yêu cầu mở khoá")),
            );
          }
          else{
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=> PlayQuiz(userId: userId,quizId: quizId,)));

          }
        }
      },
      child: Container(
        margin: EdgeInsets.only(bottom: 8,),
        height: 150,
        child: Stack(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.network(imgUrl, width: MediaQuery.of(context).size.width -48, fit: BoxFit.cover,),  
            ),
            Container(
      
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8), color: Colors.black26,
              ),
              alignment: Alignment.center,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(title, style: TextStyle(color: Colors.white, fontSize: 17, fontWeight: FontWeight.w600),), 
                  SizedBox(height: 4),
                  Text(desc, style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w600),)
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
  
}