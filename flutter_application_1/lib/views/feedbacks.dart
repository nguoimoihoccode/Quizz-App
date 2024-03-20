import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/widgets/widgets.dart';

class FeedbackScreen extends StatefulWidget {
  final String userId;
  FeedbackScreen({required this.userId});
  @override
  _FeedbackScreenState createState() => _FeedbackScreenState();
}

class _FeedbackScreenState extends State<FeedbackScreen> {
  late TextEditingController _feedbackController;

  @override
  void initState() {
    super.initState();
    _feedbackController = TextEditingController();
  }

  @override
  void dispose() {
    _feedbackController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final currentLocale = EasyLocalization.of(context)?.locale;
    print(currentLocale);
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
          Text("send_cmt".tr(), style: TextStyle( color: Colors.black, fontSize: 20, fontWeight: FontWeight.bold,)),
            TextField(
              controller: _feedbackController,
              decoration: InputDecoration(
                labelText: "content".tr(), 
              ),
              maxLines: 5,
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () {
                // Gửi feedback
                print(widget.userId);
                sendFeedback();
              },
              child: Text("send".tr()),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> sendFeedback() async {
    String feedbackContent = _feedbackController.text;

    // Kiểm tra xem nội dung feedback có rỗng hay không
    if (feedbackContent.isNotEmpty) {
      try {
        // Lưu feedback vào Firestore
        await FirebaseFirestore.instance.collection('Feedbacks').add({
          'userId': widget.userId,
          'content': feedbackContent,
          'timestamp': FieldValue.serverTimestamp(),
        });

        // Xóa nội dung feedback sau khi gửi thành công
        _feedbackController.clear();

        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text("send_cmt".tr()),
              content: Text("send_success".tr()),
              actions: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('OK'),
                ),
              ],
            );
          },
        );
      } catch (e) {
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text("_error".tr()),
              actions: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('OK'),
                ),
              ],
            );
          },
        );
        print( "_error".tr() + '$e');
      }
    } else {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text("_error".tr()),
            content: Text("content_empty".tr()),
            actions: [
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('OK'),
              ),
            ],
          );
        },
      );
    }
  }
}