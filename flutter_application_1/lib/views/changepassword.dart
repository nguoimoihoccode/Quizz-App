import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/views/home.dart';
import 'package:flutter_application_1/widgets/widgets.dart';

class Changepassword extends StatefulWidget {
  final String userId;

  const Changepassword({Key? key, required this.userId}) : super(key: key);

  @override
  State<Changepassword> createState() => _ChangepasswordState();
}

class _ChangepasswordState extends State<Changepassword> {
  final _auth = FirebaseAuth.instance;
  final _formKey = GlobalKey<FormState>();
  late String _oldPassword = '';
  late String _newPassword = '';
  late String _confirmNewPassword = '';

  void _changePassword() async {
    final user = _auth.currentUser;
    if (user != null) {
      try {
        final credential = EmailAuthProvider.credential(email: user.email!, password: _oldPassword);
        await user.reauthenticateWithCredential(credential);

        if (_newPassword == _confirmNewPassword) {
          await user.updatePassword(_newPassword);
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Mật khẩu đã được thay đổi thành công.')),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Mật khẩu mới và xác nhận mật khẩu mới không khớp.')),
          );
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Có lỗi xảy ra. Vui lòng thử lại sau.')),
        );
      }
    }
    Navigator.pushReplacement(context, MaterialPageRoute(
          builder: (context) => Home(userId: widget.userId)
        ));
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
        padding: const EdgeInsets.all(16.0),  
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              Text("change_pass".tr(), style: TextStyle( color: Colors.black, fontSize: 20, fontWeight: FontWeight.bold,)),

              TextFormField(
                decoration:  InputDecoration(labelText: "oldpass_label".tr()),
                obscureText: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "oldpass_empty".tr();
                  }
                  return null;
                },
                onChanged: (value) {
                  setState(() {
                    _oldPassword = value;
                  });
                },
              ),
              TextFormField(
                decoration: InputDecoration(labelText: "newpass_label".tr()),
                obscureText: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "newpass_empty".tr();
                  }
                  if (value.length < 6) {
                    return "lengthpass".tr();
                  }
                  return null;
                },
                onChanged: (value) {
                  setState(() {
                    _newPassword = value;
                  });
                },
              ),
              TextFormField(
                decoration: InputDecoration(labelText: "new2pass_label".tr()),
                obscureText: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "new2pass_empty".tr();
                  }
                  if (value != _newPassword) {
                    return "new_same_new2_pass".tr();
                  }
                  return null;
                },
                onChanged: (value) {
                  setState(() {
                    _confirmNewPassword = value;
                  });
                },
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _changePassword();
                  }
                },
                child: Text("confirm".tr()),
              ),
            ],
          ),
        ),
      ),
    );
  }
}