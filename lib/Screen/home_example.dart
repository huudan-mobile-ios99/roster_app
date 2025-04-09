import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../Model/myobject.dart';
import '../model/user.dart';

class MyHomePageExample extends StatefulWidget {
  String? number;
  String? name;
  String? vietnameseName;
  String? role;
  String? group;
  String? birthday;

  MyHomePageExample(
      {this.number,
      this.name,
      this.vietnameseName,
      this.role,
      this.group,
      this.birthday});

  @override
  State<MyHomePageExample> createState() => _MyHomePageExampleState();
}

class _MyHomePageExampleState extends State<MyHomePageExample> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: Text('homepage'),
          automaticallyImplyLeading: false,
        ),
        body: const Center(child: Text('homepage'))
        // body:
        // StreamBuilder(
        //   stream: FirebaseFirestore.instance.collection('user').snapshots(),
        //   builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        //     if (!snapshot.hasData) return const Center(child: Text('nothing'));
        //     return ListView.builder(
        //         itemCount: snapshot.data?.docs.length,
        //         itemBuilder: (context, index) {
        //           final name = snapshot.data?.docs[index]['name'];
        //           final age = snapshot.data?.docs[index]['age'];
        //           final birthday = snapshot.data?.docs[index]['birthday'];
        //           final id = snapshot.data?.docs[index].id;
        //           return Card(
        //             child: ListTile(
        //               title: Text('${index + 1} $name $age'),
        //             ),
        //           );
        //         });
        //   },
        // ),

        // floatingActionButton: FloatingActionButton(
        //   onPressed: () {
        //     // createNewUser();
        //     // createObject();
        //     // createMapData();
        //     getUserByRole(role: 'user');
        //   },
        //   tooltip: 'press',
        //   child: const Icon(Icons.add),
        // ), // This trailing comma makes auto-formatting nicer for build methods.
        );
  }

  Future createNewUser() async {
    // log('create user');
    // final docs = FirebaseFirestore.instance.collection('user').doc();
    // final user = User(
    //     id: docs.id,
    //     name: 'Thanh Khanh',
    //     age: 23,
    //     birthday: DateTime(1999, 02, 11));
    // final json = user.toJson();
    // await docs.set(json);
  }

  Future createObject() async {
    MyObject myObject =
        MyObject.fromJson({'foo': 'hi', 'bar': 0}); // Instance of MyObject.

    var collection = FirebaseFirestore.instance.collection('user');
    await collection
        .add(myObject.toMap()) // <-- Convert myObject to Map<String, dynamic>
        .then((_) => print('Added'))
        .catchError((error) => print('Add failed: $error'));
  }

  Future createMapData() async {
    List<Map<String, String>> myData = [
      {'questions': 'How many?', 'answer': 'five'},
      {'question': 'How much?', 'answer': 'five dollars'},
    ];
    FirebaseFirestore.instance.doc('user/document').set({'some_key': myData});
  }

  Future getUserByRole({role}) async {
    final myDocs = FirebaseFirestore.instance.collection('user').snapshots();
    // print(myDocs.first['']);
  }
}
