import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/widgets/widgets.dart';

class FeedbackScreen2 extends StatefulWidget {
  final String userId;

  FeedbackScreen2({required this.userId});

  @override
  _FeedbackScreenState createState() => _FeedbackScreenState();
}

class _FeedbackScreenState extends State<FeedbackScreen2> {
  
   @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: AppLogo(),
        elevation: 0.0,
        backgroundColor: Colors.transparent,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('Feedbacks').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            var feedbacks = snapshot.data!.docs;
            print(feedbacks);
            return ListView.builder(
              itemCount: feedbacks.length,
              itemBuilder: (context, index) {
                var feedback = feedbacks[index];

                return Padding(
                  padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                  child: Card(
                    child: ListTile(
                      title: Text(
                        'User ${index+1}',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                       onTap: () {
                        print(feedback.id);
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: Text('User ${index+1}'),
                              content: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    'Góp ý : ${index+1}',
                                    style: TextStyle(fontSize: 16),
                                  ),
                                  SizedBox(height: 8.0),
                                  Text(
                                    'Nội dung: ${feedback['content']}',
                                    style: TextStyle(fontSize: 16),
                                  ),
                                  SizedBox(height: 8.0),
                                Text(
                                    'Thời gian: ${DateTime.fromMillisecondsSinceEpoch(feedback['timestamp'].seconds * 1000).toLocal().day}/${DateTime.fromMillisecondsSinceEpoch(feedback['timestamp'].seconds * 1000).toLocal().month}/${DateTime.fromMillisecondsSinceEpoch(feedback['timestamp'].seconds * 1000).toLocal().year}',
                                    style: TextStyle(fontSize: 16),
                                  ),
                                ],
                              ),
                              actions: [
                                ElevatedButton(
                                  onPressed: () {
                                    FirebaseFirestore.instance
                                          .collection('Feedbacks')
                                          .doc(feedback.id)
                                          .delete();
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(content: Text('Xoá góp ý thành công')),
                                      );
                                    Navigator.pop(context);

                                  },
                                  child: Text('Xóa'),
                                ),
                              ],
                            );
                          },
                        );
                      },
                      subtitle: Padding(
                        padding: EdgeInsets.only(top: 8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Góp ý : ${index+1}',
                              style: TextStyle(fontSize: 16),
                            ),
                            SizedBox(height: 8.0),
                            Text(
                              'Nội dung: ${feedback['content']}',
                              style: TextStyle(fontSize: 16),
                            ),
                            SizedBox(height: 8.0),
                           Text(
                              'Thời gian: ${DateTime.fromMillisecondsSinceEpoch(feedback['timestamp'].seconds * 1000).toLocal().day}/${DateTime.fromMillisecondsSinceEpoch(feedback['timestamp'].seconds * 1000).toLocal().month}/${DateTime.fromMillisecondsSinceEpoch(feedback['timestamp'].seconds * 1000).toLocal().year}',
                              style: TextStyle(fontSize: 16),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            );
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else {
            return CircularProgressIndicator();
          }
        },
      ),
    );
  }
}
