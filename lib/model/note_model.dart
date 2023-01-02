// import 'package:firebase_database/firebase_database.dart';
// class NoteModel{
//   String? _id;
//   String _title;
//   String _description;
//
//   NoteModel(this._id, this._title, this._description);
//
//   String? get id => _id;
//   String get title => _title;
//   String get description => _description;
//
//   NoteModel.fromSnapShot(DataSnapshot snapshot){
//     _id = snapshot.key;
//     _title = snapshot.value['title'];
//     _description=snapshot.value['description'];
//   }
//
//
// }