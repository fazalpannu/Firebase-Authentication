import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase/firestore/addfirestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase/post/add_post.dart';
import 'package:firebase/ui/auth/login_screen.dart';
import 'package:firebase/utils/utils.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

class firestorescreen extends StatefulWidget {
  const firestorescreen({super.key});

  @override
  State<firestorescreen> createState() => _firestorescreenState();
}

class _firestorescreenState extends State<firestorescreen> {
  TextEditingController update = TextEditingController();

  FirebaseAuth auth = FirebaseAuth.instance;
  final firestore = FirebaseFirestore.instance.collection('user').snapshots();
  CollectionReference reffirestore =
      FirebaseFirestore.instance.collection('user');
  void showDialog(String id, String title) {
    update.text = title;
    Get.dialog(
      AlertDialog(
        title: Text('Edit'),
        content: TextFormField(
            controller: update,
            decoration: InputDecoration(
                hintText: 'edit', border: OutlineInputBorder())),
        actions: [
          TextButton(
              onPressed: () {
                Get.back();
              },
              child: Text('Cancel')),
          TextButton(
              onPressed: () {
                reffirestore.doc(id).update({
                  'title': update.text.toLowerCase().toString(),
                }).then((value) {
                  update.clear();
                  utils().toast('Updated');
                }).onError((error, stackTrace) {
                  utils().toast(error.toString());
                });
              },
              child: Text('Update'))
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: Text('Firebase'),
        actions: [
          IconButton(
              onPressed: () {
                auth.signOut().then((value) {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => loginscreen(),
                      ));
                }).onError((error, stackTrace) {
                  utils().toast(error.toString());
                });
              },
              icon: Icon(Icons.logout_outlined)),
          SizedBox(
            width: 10,
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Expanded(
                child: StreamBuilder<QuerySnapshot>(
              stream: firestore,
              builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: Container(
                      height: 50,
                      child: CircularProgressIndicator(
                        strokeWidth: 4,
                        color: Colors.blue,
                      ),
                    ),
                  );
                }
                if (snapshot.hasError) {
                  return Text('Some Error !');
                } else {
                  return ListView.builder(
                      itemCount: snapshot.data!.docs.length,
                      itemBuilder: (context, index) {
                        String title =
                            snapshot.data!.docs[index]['title'].toString();
                        String id = snapshot.data!.docs[index]['id'].toString();
                        return ListTile(
                          title: Text(title),
                          trailing: PopupMenuButton(
                              icon: Icon(Icons.more_vert),
                              itemBuilder: (context) => [
                                    PopupMenuItem(
                                        value: 1,
                                        child: ListTile(
                                          onTap: () {
                                            showDialog(id, title);
                                          },
                                          title: Icon(Icons.edit),
                                          leading: Text('Edit'),
                                        )),
                                    PopupMenuItem(
                                        value: 1,
                                        child: ListTile(
                                          onTap: () {
                                            reffirestore.doc(id).delete();
                                            Get.back();
                                          },
                                          title: Icon(Icons.delete),
                                          leading: Text('Delete'),
                                        )),
                                  ]),
                        );
                      });
                }
              },
            )),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => addfirestore(),
                ));
          },
          child: Icon(Icons.add)),
    );
  }
}
