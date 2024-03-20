import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/views/home.dart';
import 'package:flutter_application_1/widgets/widgets.dart';

class SelectedLanguage extends StatefulWidget {
  final String userId;

  const SelectedLanguage({super.key, required this.userId});

  @override
  State<SelectedLanguage> createState() => _SelectedLanguageState();
}

class _SelectedLanguageState extends State<SelectedLanguage> {
 @override
  Widget build(BuildContext context) {
    return Scaffold(
       appBar: AppBar(
        title: AppLogo(),
        elevation: 0.0,
        backgroundColor: Colors.transparent,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("SL_Title".tr(), 
            style: TextStyle( 
              color: Colors.black, 
              fontSize: 20, 
              fontWeight: FontWeight.bold,
              )
            ),

            ElevatedButton(
              onPressed: () {
                context.setLocale(const Locale("vi"));
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => Home(userId: widget.userId,)),
                );
              },
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.all(8), // Khoảng cách giữa nội dung và viền của ElevatedButton
              ),
              child: Row(
                children: [
                  Padding(
                    padding: EdgeInsets.only(left: 60, right: 30),

                    child: Image.asset(
                      'assets/images/vietnam.png',
                      width: 90,
                      height: 60,
                    ),
                  ),
                  Text(
                    "Sub1_SL_Title".tr(),
                    style: TextStyle(
                      color: Color.fromARGB(255, 0, 0, 0),
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                context.setLocale(const Locale("en"));
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => Home(userId: widget.userId,)),
                );
              },
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.all(8), // Khoảng cách giữa nội dung và viền của ElevatedButton
              ),
              child: Row(
                children: [
                  Padding(
                    padding: EdgeInsets.only(left: 60, right: 30),
                    child: Image.asset(
                      'assets/images/england.png',
                      width: 90,
                      height: 60,
                    ),
                  ),
                  Text(
                    "Sub2_SL_Title".tr(),
                    style: TextStyle(
                      color: Color.fromARGB(255, 0, 0, 0),
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                showLanguageDialog(context);
              },
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.all(8), // Khoảng cách giữa nội dung và viền của ElevatedButton
              ),
              child: Row(
                children: [
                  Padding(
                    padding: EdgeInsets.only(left: 60, right: 30),
                    child: Image.asset(
                      'assets/images/trungquoc.png',
                      width: 90,
                      height: 60,
                    ),
                  ),
                  Text(
                    "Sub3_SL_Title".tr(),
                    style: TextStyle(
                      color: Color.fromARGB(255, 0, 0, 0),
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                showLanguageDialog(context);
              },
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.all(8), // Khoảng cách giữa nội dung và viền của ElevatedButton
              ),
              child: Row(
                children: [
                  Padding(
                    padding: EdgeInsets.only(left: 60, right: 30),

                    child: Image.asset(
                      'assets/images/nhatban.png',
                      width: 90,
                      height: 60,
                    ),
                  ),
                  Text(
                    "Sub4_SL_Title".tr(),
                    style: TextStyle(
                      color: Color.fromARGB(255, 0, 0, 0),
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                showLanguageDialog(context);
              },
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.all(8), // Khoảng cách giữa nội dung và viền của ElevatedButton
              ),
              child: Row(
                children: [
                  Padding(
                    padding: EdgeInsets.only(left: 60, right: 30),
                    
                    child: Image.asset(
                      'assets/images/hanquoc.png',
                      width: 90,
                      height: 60,
                    ),
                  ),
                  
                  Text(
                    
                    "Sub5_SL_Title".tr(),
                    style: TextStyle(
                      color: Color.fromARGB(255, 0, 0, 0),
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}
void showLanguageDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text("iscoming".tr()),
        actions: [
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text("close".tr()),
          ),
        ],
      );
    },
  );
}