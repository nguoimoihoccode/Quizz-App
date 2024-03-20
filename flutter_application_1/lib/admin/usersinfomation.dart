import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/widgets/widgets.dart';

class UserInformationScreen extends StatelessWidget {
  final String userId;

  UserInformationScreen({required this.userId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: AppLogo(),
        elevation: 0.0,
        backgroundColor: Colors.transparent,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('users').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            var userDatas = snapshot.data!.docs;
            return ListView.builder(
              itemCount: userDatas.length,
              itemBuilder: (context, index) {
                var userData = userDatas[index];
                return Padding(
                  padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                  child: Card(
                    child: ListTile(
                      leading: ClipRRect(
                        
                        borderRadius: BorderRadius.circular(30.0),
                        child: Container(
                          width: 60, // Điều chỉnh kích thước của khung chứa hình ảnh
                          height: 60,
                          child: CircleAvatar(
                            backgroundImage: NetworkImage(userData['image']),
                            
                          ),
                        ),
                      ),
                      title: Text(
                        
                        'User ${index+1}',
                        
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      onTap: () {
                        print(userData.id);
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: Text('User ${index+1}'),
                              content: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text('Name: ${userData['first name']}', style: TextStyle(fontSize: 16)),
                                  SizedBox(height: 8.0),
                                  Text('Age: ${userData['age']}', style: TextStyle(fontSize: 16)),
                                  SizedBox(height: 8.0),
                                  Text('Address: ${userData['address']}', style: TextStyle(fontSize: 16)),
                                  SizedBox(height: 8.0),
                                  Text(
                                      'Status: ${userData['statusUser'] == 0 ? 'Khoá' : 'Không khoá'}',
                                      style: TextStyle(fontSize: 16),
                                    ),
                                ],
                              ),
                              actions: [
                                ElevatedButton(
                                  onPressed: () async {
                                    if (userData['statusUser'] == 1) {
                                      // Khoá tài khoản
                                      await FirebaseFirestore.instance
                                          .collection('users')
                                          .doc(userData.id)
                                          .update({'statusUser': 0});
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(content: Text('Đã khoá tài khoản')),
                                      );
                                    } else if (userData['statusUser'] == 0) {
                                      // Mở khoá tài khoản
                                      await FirebaseFirestore.instance
                                          .collection('users')
                                          .doc(userData.id)
                                          .update({'statusUser': 1});
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(content: Text('Đã mở khoá tài khoản')),
                                      );
                                    }
                                    Navigator.pop(context);

                                  },
                                  child: userData['statusUser'] == 1 ? Text('Khoá') : Text('Mở Khoá'),
                                ),
                                ElevatedButton(
                                  onPressed: () {
                                    FirebaseFirestore.instance
                                          .collection('users')
                                          .doc(userData.id)
                                          .delete();
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(content: Text('Đã xoá khoá tài khoản')),
                                      );
                                    Navigator.pop(context);

                                  },
                                  child: Text('Xóa tài khoản'),
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
                              'Name: ${userData['first name']}',
                              style: TextStyle(fontSize: 16),
                            ),
                            SizedBox(height: 8.0),
                            Text(
                              'Age: ${userData['age']}',
                              style: TextStyle(fontSize: 16),
                            ),
                            SizedBox(height: 8.0),
                            Text(
                              'Address: ${userData['address']}',
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