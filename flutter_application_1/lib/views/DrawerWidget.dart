import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/models/informationUsers.dart';
import 'package:flutter_application_1/services/information.dart';
import 'package:flutter_application_1/views/changepassword.dart';
import 'package:flutter_application_1/views/language.dart';
import 'package:flutter_application_1/views/rank.dart';
import 'package:flutter_application_1/views/feedbacks.dart';
import 'package:flutter_application_1/views/signin.dart';
import 'package:flutter_application_1/views/updateUser.dart';


  
class DrawerWidget extends StatelessWidget {
  final String userId;
  DrawerWidget({required this.userId});

  final _firestore = FirebaseFirestore.instance;
  final _informationService = InformationService(); // Tạo một đối tượng InformationService
  
  late Locale _currentLocale; // Ngôn ngữ hiện tại
  
  void _changepassword(BuildContext context) async {
    try {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => Changepassword(userId: userId,)),
      );
    } catch (e) {
      print(e);
    }
  }
  

  @override
  Widget build(BuildContext context) {
    final currentLocale = EasyLocalization.of(context)?.locale;
    print(currentLocale);
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              color: Colors.blue,
            ),
            child: FutureBuilder<informationUsers>(
              future: _informationService.getInformation(userId),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  final user = snapshot.data!;
                  return GestureDetector(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CircleAvatar(
                          radius: 50,
                          backgroundImage: user.imageUser != null
                              ? NetworkImage(user.imageUser!)
                              : AssetImage('assets/avatar.png') as ImageProvider<Object>?,
                        ),
                        SizedBox(height: 3),
                        Text(
                          user.firstNameUser ?? "first_name".tr(),
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                          ),
                        ),
                      ],
                    ),
                  );
                } else if (snapshot.hasError) {
                  return Text("update_infomationUser".tr());
                } else {
                  return CircularProgressIndicator();
                }
              },
            ),
          ),
          ListTile(
            title: Text("your_account".tr()),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => UpdateUser(userId: userId),
                ),
              );
            },
          ),
          ListTile(
            title: Text("change_pass".tr()),
            onTap: () {
              _changepassword(context);
            },
          ),
          
          
          ListTile(
            title: Text("_rankings".tr()),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => TopRankScreen(),
                ),
              );
            },
          ),
          ListTile(
            title: Text("feed_backs".tr()),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => FeedbackScreen(userId: userId),
                ),
              );
            },
          ),
          ListTile(
            title: Text("language".tr()),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => SelectedLanguage(userId: userId),
                ),
              );
            },
          ),
          // Thêm các mục danh sách khác tại đây
          ListTile(
            title: Text("_logout".tr()),
            onTap: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => SignIn()),
              );
            },
          ),
          
        ],
      ),
    );
  }
}