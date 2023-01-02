import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'ListViewNote.dart';

class CustomCard extends StatelessWidget {
  final id;
  final title;
  final description;

  CustomCard({
    required this.id,
    required this.title,
    required this.description,
  });

  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        titleController.text = title;
        descriptionController.text = description;
        _showDialog(context);
      },
      child: Card(
        child: ListTile(
          leading: IconButton(
            onPressed: () {
              try {
                FirebaseFirestore.instance.collection('Notes').doc(id).delete();
              } catch (e) {
                print('_dell${e}');
              }
            },
            icon: const Icon(Icons.remove_circle),
          ),
          title: Text(title),
          subtitle: Text(description),
        ),
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
              height: MediaQuery.of(context).size.height * 0.17,
              width: MediaQuery.of(context).size.width - 30,
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
                    decoration: InputDecoration(
                      labelText: 'Description',
                    ),
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
                      FirebaseFirestore.instance
                          .collection('Notes')
                          .doc(id)
                          .update({
                        "title": titleController.text,
                        "description": descriptionController.text,
                      }).then((value) => {
                          
                                Navigator.pop(context),
                              });
                    } catch (e) {
                      print(e.toString());
                    }
                  }
                },
                child: const Text('Update')),
          ],
        );
      },
    );
  }
}
