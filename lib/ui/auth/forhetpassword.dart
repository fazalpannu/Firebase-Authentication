import 'package:firebase/ui/auth/login_screen.dart';
import 'package:firebase/ui/auth/sign_up.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../utils/utils.dart';
import '../../widget/round_button.dart';

class forgetpassword extends StatefulWidget {
  const forgetpassword({super.key});

  @override
  State<forgetpassword> createState() => _forgetpasswordState();
}

class _forgetpasswordState extends State<forgetpassword> {
  FirebaseAuth auth = FirebaseAuth.instance;
  bool loading = false;
  final _formkey = GlobalKey<FormState>();
  TextEditingController email = TextEditingController();

  @override
  void login() {
    auth.sendPasswordResetEmail(email: email.text.toString()).then((value) {
      email.clear();

      setState(() {
        loading = false;
      });
      Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => loginscreen(),
          ));
      utils().toast('Send mail for password change');
    }).onError((error, stackTrace) {
      setState(() {
        loading = false;
      });
      utils().toast(error.toString());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('forget password'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Form(
                  key: _formkey,
                  child: Column(
                    children: [
                      TextFormField(
                        controller: email,
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                            hintText: 'Enter The Email',
                            helperText: 'e.g fazal@gmail.com',
                            prefixIcon: Icon(Icons.mark_email_read_outlined)),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'enter email';
                          }
                          final RegExp emailRegex = RegExp(
                              r'^[\w-]+(\.[\w-]+)*@([\w-]+\.)+[a-zA-Z]{2,7}$');

                          if (!emailRegex.hasMatch(value)) {
                            return 'Please enter a valid email address.';
                          }
                          return null;
                        },
                      ),
                      SizedBox(
                        height: 5,
                      ),
                    ],
                  )),
              SizedBox(
                height: 50,
              ),
              roundbuttom(
                button: 'request',
                ontap: () {
                  if (_formkey.currentState!.validate()) {
                    setState(() {
                      loading = true;
                    });
                    login();
                  }
                },
                loading: loading,
              ),
              SizedBox(
                height: 30,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
