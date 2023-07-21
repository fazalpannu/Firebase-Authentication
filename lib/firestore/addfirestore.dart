import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase/utils/utils.dart';
import 'package:firebase/widget/round_button.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class addfirestore extends StatefulWidget {
  const addfirestore({super.key});

  @override
  State<addfirestore> createState() => _addfirestoreState();
}

class _addfirestoreState extends State<addfirestore> {
  bool loading = false;
  final postadding = TextEditingController();
  // final firebaseref = FirebaseDatabase.instance.ref('Post');
  final firestore = FirebaseFirestore.instance.collection('user');
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Add Post Firebase'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              SizedBox(
                height: 30,
              ),
              TextFormField(
                  controller: postadding,
                  maxLines: 4,
                  decoration: InputDecoration(
                    hintText: 'What is your mind! ',
                    border: OutlineInputBorder(),
                  )),
              SizedBox(
                height: 30,
              ),
              roundbuttom(
                button: 'Add',
                ontap: () {
                  loading = true;
                  setState(() {});
                  String id = DateTime.now().millisecondsSinceEpoch.toString();
                  firestore.doc(id).set({
                    'title': postadding.text.toString(),
                    'id': id
                  }).then((value) {
                    postadding.clear();
                    loading = false;
                    setState(() {});
                    utils().toast('post added');
                  }).onError((error, stackTrace) {
                    loading = false;

                    setState(() {});
                    utils().toast('post added');
                  });
                },
                loading: loading,
              )
            ],
          ),
        ));
  }
}
