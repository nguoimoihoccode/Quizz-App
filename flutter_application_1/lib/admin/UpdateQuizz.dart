import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class UpdateQuizz extends StatefulWidget {
  final String quizId;
  

  const UpdateQuizz({Key? key, required this.quizId}) : super(key: key);

  @override
  State<UpdateQuizz> createState() => _UpdateQuizzState();
}

class _UpdateQuizzState extends State<UpdateQuizz> {
  late TextEditingController questionController ;
  late TextEditingController option1;
  late TextEditingController option2;
  late TextEditingController option3;
  late TextEditingController option4;
  TextEditingController explanationController = TextEditingController();

  int currentQuestionIndex = 0;
  List<Map<String, dynamic>> quizData = [];
  List<Map<String, dynamic>> questionData = [];


  @override
  void initState() {
    super.initState();

    // Khởi tạo các controllers cho các tùy chọn câu trả lời
    questionController = TextEditingController();
    option1= TextEditingController();
    option2= TextEditingController();
    option3= TextEditingController();
    option4= TextEditingController();

    getQuestion();
  }

  @override
  void dispose() {
    // Giải phóng bộ nhớ khi dispose widget
    questionController.dispose();
    option1.dispose();
    option2.dispose();
    option3.dispose();
    option4.dispose();
    explanationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Update Quiz'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              TextFormField(
                controller: questionController,
                decoration: const InputDecoration(
                  labelText: 'Question',
                ),
              ),
              const SizedBox(height: 16.0),
              TextFormField(
                controller: option1,
                decoration: InputDecoration(labelText: '1'),
              ),
              TextFormField(
                controller: option2,
                decoration: InputDecoration(labelText: '2'),
              ),
              TextFormField(
                controller: option3,
                decoration: InputDecoration(labelText: '3'),
              ),
              TextFormField(
                controller: option4,
                decoration: InputDecoration(labelText: '4'),
              ),
              const SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: () {
                  // Thực hiện cập nhật, sửa đổi hoặc xóa nội dung của câu hỏi
                  updateQuestion();
                },
                child: const Text('Update Question'),
              ),
              const SizedBox(height: 16.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(
                  onPressed: () {
                    // Xử lý sự kiện khi nhấn nút "Next"
                    navigateToNextQuestion();
                  },
                  child: const Text('Next'),
                ),
                ElevatedButton(
                  onPressed: () {
                    // Xử lý sự kiện khi nhấn nút "Previous"
                    navigateToPreviousQuestion();
                  },
                  child: const Text('Previous'),
                ),
              ],
            ),
            ],
          ),
        ),
      ),
    );
  }

  void getQuestion() async {
    QuerySnapshot quizzSnapshot = await FirebaseFirestore.instance
        .collection('Quiz')
        .doc(widget.quizId)
        .collection("QNA")
        .get();

    quizData = quizzSnapshot.docs.map((doc) {
      final data = doc.data() as Map<String, dynamic>;
      final docId = doc.id; // Lấy ID của tài liệu
      data['docId'] = doc.id; // Thêm docId vào dữ liệu của tài liệu
      return {
        'docId': docId, // Thêm docId vào đối tượng mới
        ...data, // Sao chép dữ liệu từ tài liệu vào đối tượng mới
        //Là đúng, toán tử "..." trong Dart được gọi là "spread operator" (hoặc "spread syntax"). 
        //Khi sử dụng toán tử "..." trước một Map, nó sao chép tất cả các cặp key-value từ Map đó vào Map mới.
      };
    }).toList();

    if (quizData.isNotEmpty) {
      setState(() {
        questionController.text = quizData[currentQuestionIndex]['question'] ?? '';
        option1.text = quizData[currentQuestionIndex]['option1'] ?? '';
        option2.text = quizData[currentQuestionIndex]['option2'] ?? '';
        option3.text = quizData[currentQuestionIndex]['option3'] ?? '';
        option4.text = quizData[currentQuestionIndex]['option4'] ?? '';
      });
    }
  }

  void navigateToNextQuestion() {
    if (currentQuestionIndex < quizData.length - 1) {
      setState(() {
        currentQuestionIndex++;
        questionController.text = quizData[currentQuestionIndex]['question'] ?? '';
        option1.text = quizData[currentQuestionIndex]['option1'] ?? '';
        option2.text = quizData[currentQuestionIndex]['option2'] ?? '';
        option3.text = quizData[currentQuestionIndex]['option3'] ?? '';
        option4.text = quizData[currentQuestionIndex]['option4'] ?? '';
      });
    }
  }

  void navigateToPreviousQuestion() {
    if (currentQuestionIndex > 0) {
      setState(() {
        currentQuestionIndex--;
        questionController.text = quizData[currentQuestionIndex]['question'] ?? '';
        option1.text = quizData[currentQuestionIndex]['option1'] ?? '';
        option2.text = quizData[currentQuestionIndex]['option2'] ?? '';
        option3.text = quizData[currentQuestionIndex]['option3'] ?? '';
        option4.text = quizData[currentQuestionIndex]['option4'] ?? '';
      });
    }
  }

  Future<void> updateQuestion() async {
    DocumentReference quizRef = FirebaseFirestore.instance.collection('Quiz').doc(widget.quizId);
    DocumentSnapshot doc = await quizRef.get();
    if(doc.exists){
      await quizRef.update({
        'quizStatus': "1",
      });
    }


    DocumentReference questionRef = FirebaseFirestore.instance
                                                      .collection('Quiz').doc(widget.quizId)
                                                      .collection("QNA").doc(quizData[currentQuestionIndex]['docId']);
    try {
      DocumentSnapshot doc = await questionRef.get();
      if(doc.exists){
        await questionRef.update({
          'question': questionController.text.trim(),
          'option1': option1.text.trim(),
          'option2': option2.text.trim(),
          'option3': option3.text.trim(),
          'option4': option4.text.trim(),
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Update quiz successfully')),
        );
         getQuestion();
      }
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to update successfully')),
      );
    }
  }
}