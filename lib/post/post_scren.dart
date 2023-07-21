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

class postscreen extends StatefulWidget {
  const postscreen({super.key});

  @override
  State<postscreen> createState() => _postscreenState();
}

class _postscreenState extends State<postscreen> {
  TextEditingController search = TextEditingController();
  TextEditingController update = TextEditingController();

  FirebaseAuth auth = FirebaseAuth.instance;
  final firebaseref = FirebaseDatabase.instance.ref('Post');

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
                firebaseref.child(id).update({
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
        title: Text('Post'),
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
            TextFormField(
              onChanged: (value) {
                setState(() {});
              },
              controller: search,
              decoration: InputDecoration(
                  hintText: 'Search', border: OutlineInputBorder()),
            ),
            Expanded(
                child: StreamBuilder(
              stream: firebaseref.onValue,
              builder: (context, AsyncSnapshot<DatabaseEvent> snapshot) {
                if (!snapshot.hasData) {
                  return Center(
                    child: Container(
                      height: 50,
                      child: CircularProgressIndicator(
                        strokeWidth: 4,
                        color: Colors.blue,
                      ),
                    ),
                  );
                } else {
                  Map<dynamic, dynamic> map =
                      snapshot.data!.snapshot.value as dynamic;
                  List<dynamic> list = [];
                  list.clear();
                  list = map.values.toList();

                  return ListView.builder(
                    itemCount: snapshot.data!.snapshot.children.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        title: InkWell(
                            onTap: () {}, child: Text(list[index]['title'])),
                      );
                    },
                  );
                }
              },
            )),
            Expanded(
              child: FirebaseAnimatedList(
                defaultChild: Center(
                  child: Container(
                    height: 50,
                    child: CircularProgressIndicator(
                      strokeWidth: 4,
                      color: Colors.blue,
                    ),
                  ),
                ),
                query: firebaseref,
                // ignore: dead_code
                itemBuilder: (context, snapshot, animation, index) {
                  final title = snapshot.child('title').value.toString();
                  final id = snapshot.child('id').value.toString();
                  if (search.text.toString().isEmpty) {
                    return ListTile(
                      leading: CircleAvatar(
                          foregroundImage: NetworkImage(
                              snapshot.child('title').value.toString())),
                      title: Text(title),
                      subtitle: Text(id),
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
                                  firebaseref
                                      .child(
                                          snapshot.child('id').value.toString())
                                      .remove();
                                  Get.back();
                                },
                                title: Icon(Icons.delete),
                                leading: Text('Delete'),
                              )),
                        ],
                      ),
                    );
                  } else if (title
                      .toLowerCase()
                      .contains(search.text.toLowerCase().toString())) {
                    return ListTile(
                      title: Text(title),
                    );
                  } else {
                    return Container();
                  }
                },
              ),
            )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => addpost(),
                ));
          },
          child: Icon(Icons.add)),
    );
  }
}
