import 'dart:async';

import 'package:firebase/firestore/firestorescreen.dart';
import 'package:firebase/post/post_scren.dart';
import 'package:firebase/ui/auth/login_screen.dart';
import 'package:firebase/ui/uploadimage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SplashServices {
  void login(BuildContext context) {
    final auth = FirebaseAuth.instance;

    final user = auth.currentUser;
    if (user != null) {
      Timer(Duration(seconds: 8), () {
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => postscreen(),
            ));
      });
    } else {
      Timer(Duration(seconds: 8), () {
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => loginscreen(),
            ));
      });
    }
  }
}
