import 'package:firebase/ui/auth/login_screen.dart';
import 'package:firebase/utils/utils.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../widget/round_button.dart';

class signup extends StatefulWidget {
  const signup({super.key});

  @override
  State<signup> createState() => _signupState();
}

class _signupState extends State<signup> {
  bool _loading = false;
  FirebaseAuth auth = FirebaseAuth.instance;
  final _formkey = GlobalKey<FormState>();
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    email.dispose();
    password.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        SystemNavigator.pop();
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text('Sign Up'),
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
                        TextFormField(
                          keyboardType: TextInputType.text,
                          controller: password,
                          obscureText: true,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'enter password';
                            }
                            // if (value.length < 6) {
                            //   return 'Password must be at least 6 characters long.';
                            // }
                            return null;
                          },
                          decoration: InputDecoration(
                              hintText: 'Enter The Password',
                              prefixIcon: Icon(Icons.lock_open)),
                        ),
                      ],
                    )),
                SizedBox(
                  height: 50,
                ),
                roundbuttom(
                  button: 'Sign Up',
                  ontap: () {
                    if (_formkey.currentState!.validate()) {
                      setState(() {
                        _loading = true;
                      });
                      auth
                          .createUserWithEmailAndPassword(
                              email: email.text.toString(),
                              password: password.text.toString())
                          .then((value) {
                        email.clear();
                        password.clear();
                        utils().toast('Sign Up Successfully!');
                        setState(() {
                          _loading = false;
                        });
                      }).onError((error, stackTrace) {
                        setState(() {
                          _loading = false;
                        });
                        utils().toast(error.toString());
                      });
                    }
                  },
                  loading: _loading,
                ),
                SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Already have account"),
                    TextButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => loginscreen(),
                              ));
                        },
                        child: Text(
                          'Login',
                          style: TextStyle(
                            decoration: TextDecoration.underline,
                          ),
                        ))
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
