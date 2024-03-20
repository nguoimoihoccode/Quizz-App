import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/admin/feedbackscreen.dart';
import 'package:flutter_application_1/admin/usersinfomation.dart';
import 'package:flutter_application_1/models/informationUsers.dart';
import 'package:flutter_application_1/services/information.dart';
import 'package:flutter_application_1/views/signin.dart';

class DrawerWidget2 extends StatelessWidget {
  final String userId;
  DrawerWidget2({required this.userId});

  final _firestore = FirebaseFirestore.instance;
  final _informationService = InformationService();

  late Locale _currentLocale;

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
                  return Padding(
                    padding: EdgeInsets.only(left: 0, right: 0),
                    child: Container(
                      width: 90,
                      height: 90,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(45),
                            child: Image.asset(
                              'assets/images/admin.jpg',
                              width: 90,
                              height: 90,
                            ),
                          ),
                          SizedBox(height: 8),
                          Text(
                            'Admin',
                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                  );
                } else {
                  return CircularProgressIndicator();
                }
              },
            ),
          ),
          ListTile(
            title: Text("view_users".tr()),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => UserInformationScreen(userId: userId),
                ),
              );
            },
          ),
          ListTile(
            title: Text("view_feedbacks".tr()),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => FeedbackScreen2(userId: userId),
                ),
              );
            },
          ),
          ListTile(
            title: Text("_logout".tr()),
            onTap: () {
              FirebaseAuth.instance.signOut();
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