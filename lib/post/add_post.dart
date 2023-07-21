import 'package:firebase/utils/utils.dart';
import 'package:firebase/widget/round_button.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class addpost extends StatefulWidget {
  const addpost({super.key});

  @override
  State<addpost> createState() => _addpostState();
}

class _addpostState extends State<addpost> {
  bool loading = false;
  final postadding = TextEditingController();
  final firebaseref = FirebaseDatabase.instance.ref('Post1');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Add Post'),
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
                  String id = DateTime.now().millisecondsSinceEpoch.toString();
                  loading = true;
                  setState(() {});
                  firebaseref.child(id).set({
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
                    utils().toast(error.toString());
                  });
                },
                loading: loading,
              )
            ],
          ),
        ));
  }
}
