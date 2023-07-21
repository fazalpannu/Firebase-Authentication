import 'dart:io';

import 'package:firebase/utils/utils.dart';
import 'package:firebase/widget/round_button.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

class uploadimage extends StatefulWidget {
  const uploadimage({super.key});

  @override
  State<uploadimage> createState() => _uploadimageState();
}

class _uploadimageState extends State<uploadimage> {
  firebase_storage.FirebaseStorage storage =
      firebase_storage.FirebaseStorage.instance;
  DatabaseReference database = FirebaseDatabase.instance.ref('Post');
  File? image;
  final imagePicker = ImagePicker();
  bool loading = false;

  Future<void> pickImage() async {
    final pickedFile = await imagePicker.pickImage(source: ImageSource.camera);

    if (pickedFile != null) {
      image = File(pickedFile.path);
      setState(() {});
      // Now you can use the 'image' variable.
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Image'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            SizedBox(
              height: 20,
            ),
            InkWell(
              onTap: () {
                pickImage();
              },
              child: Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    border: Border(
                        top: BorderSide(color: Colors.black),
                        bottom: BorderSide(color: Colors.black),
                        right: BorderSide(color: Colors.black),
                        left: BorderSide(color: Colors.black))),
                height: 100,
                width: 100,
                child: image != null
                    ? Image.file(
                        image!,
                        fit: BoxFit.fill,
                      )
                    : Icon(Icons.image),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            roundbuttom(
              button: 'Upload',
              ontap: () async {
                loading = true;
                setState(() {});
                String id = DateTime.now().microsecondsSinceEpoch.toString();
                firebase_storage.Reference ref = firebase_storage
                    .FirebaseStorage.instance
                    .ref('/foldername/' + id);
                firebase_storage.UploadTask uploadTask = ref.putFile(image!);
                await Future.value(uploadTask).then((value) async {
                  var newurl = await ref.getDownloadURL();

                  database.child(id).set(
                      {'id': id, 'title': newurl.toString()}).then((value) {
                    utils().toast('Uploaded!');
                    loading = false;
                    setState(() {});
                  });
                }).onError((error, stackTrace) {
                  utils().toast(error.toString());
                  loading = false;
                  setState(() {});
                });
              },
              loading: loading,
            ),
            Center(
              child: Container(
                width: 200,
                height: 200,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: NetworkImage(
                        'https://firebasestorage.googleapis.com/v0/b/flutterfirebase-c0bd2.appspot.com/o/foldername%2F1689968981705590?alt=media&token=8f730da7-be0c-4793-ab61-cbd23396e5c6'),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
