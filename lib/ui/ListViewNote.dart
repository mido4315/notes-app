import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:notes/ui/show_dialog.dart';

import 'custom_card.dart';

class ListViewNote extends StatefulWidget {
  const ListViewNote({Key? key}) : super(key: key);

  @override
  State<ListViewNote> createState() => _ListViewNoteState();
}

class _ListViewNoteState extends State<ListViewNote> {
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notes'),
      ),
      body: Center(
        child: Container(
          child: StreamBuilder<QuerySnapshot>(
              stream:
                  FirebaseFirestore.instance.collection('Notes').snapshots(),
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.hasError) {
                  return Text('Error ${snapshot.error}');
                }
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Text('Loding...');
                } else {
                  print("Hi1${snapshot.data!.docs.length}");
                  return ListView.builder(
                      itemCount: snapshot.data!.docs.length,
                      itemBuilder: (context, i) {
                        print("Hiii${snapshot.data!.size}");
                        return CustomCard(
                          id: snapshot.data!.docs[i].id,
                          title: snapshot.data!.docs[i]['title'],
                          description: snapshot.data!.docs[i]['description'],
                        );
                      });
                  print("Hii");
                  return ListView(
                    children: snapshot.data!.docs
                        .map<Widget>((DocumentSnapshot document) {
                      print("Hiii${document.id}");
                      return CustomCard(
                        id: document.id,
                        title: document['title'],
                        description: document['description'],
                      );
                    }).toList(),
                  );
                }
              }),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        tooltip: 'add',
        onPressed: () {
          _showDialog(context);
        },
      ),
    );
  }

  Future<dynamic> _showDialog(BuildContext context) {
    return showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: const Text(
                'create a new Note',
              ),
              content: Form(
                key: formKey,
                child: Container(
                  height: MediaQuery.of(context).size.height*0.17,
                  width: MediaQuery.of(context).size.width -30,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextFormField(
                        controller: titleController,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Title is empty';
                          } else {
                            return null;
                          }
                        },
                        decoration: InputDecoration(labelText: 'Title'),
                      ),
                      TextFormField(
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Description is empty';
                          } else {
                            return null;
                          }
                        },
                        controller: descriptionController,
                        decoration: InputDecoration(labelText: 'Description'),
                      ),
                    ],
                  ),
                ),
              ),
              actionsAlignment: MainAxisAlignment.spaceAround,
              actions: [
                ElevatedButton(
                    onPressed: () {
                      titleController.clear();
                      descriptionController.clear();
                      Navigator.pop(context);
                    },
                    child: const Text('Cancel')),
                ElevatedButton(
                    onPressed: () {
                      if (formKey.currentState!.validate()) {
                        try {
                          FirebaseFirestore.instance.collection('Notes').add({
                            "title": titleController.text,
                            "description": descriptionController.text,
                          }).then((value) => {
                                titleController.clear(),
                                descriptionController.clear(),
                            Navigator.pop(context),
                              });
                        } catch (e) {
                          print(e.toString());
                        }
                      }
                    },
                    child: const Text('Add')),
              ],
            );
          },
        );
  }
}
