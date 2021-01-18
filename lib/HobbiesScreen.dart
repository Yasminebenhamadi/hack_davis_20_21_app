import 'package:circular_profile_avatar/circular_profile_avatar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'dart:developer';

import 'SignInScreen.dart';
import 'SignInScreen.dart';

class HobbyScreen extends StatefulWidget {
  static const String id = "HobbyScreen";
  @override
  _HobbyScreenState createState() => _HobbyScreenState();
}

class _HobbyScreenState extends State<HobbyScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  Stream<QuerySnapshot> _stream;
  String _uid;
  String _name;
  String _email;
  String hobby;
  int rating;

  getuser() async {
    var doc = await _firestore.collection('Users').doc(_uid).get();
    setState(() {
      _name = doc.data()['name'];
      _email = doc.data()['email'];
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {
      hobby = null;
      rating = null;
      _uid = _auth.currentUser.uid;
      _stream = _firestore
          .collection('Users')
          .doc(_uid)
          .collection('Hobbies')
          .orderBy('rating', descending: true)
          .snapshots();
    });
    getuser();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[400],
      appBar: AppBar(
        leading: IconButton(icon: Icon(Icons.ac_unit), onPressed: getuser),
        backgroundColor: Colors.grey[700],
        title: Text(
          'Hobbies',
          style: TextStyle(fontSize: 30),
        ),
        centerTitle: true,
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(
              Icons.add,
              color: Colors.white,
              size: 30,
            ),
            onPressed: () {
              showCupertinoDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    title: Text('Add a hobby'),
                    content: Container(
                      height: 130,
                      child: Column(
                        children: [
                          TextField(
                            onChanged: (value) {
                              setState(() {
                                hobby = value;
                              });
                            },
                            textCapitalization: TextCapitalization.words,
                            decoration: InputDecoration(
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Colors.blueAccent, width: 1.0),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Colors.blueAccent, width: 2.0),
                                ),
                                hintText: 'Example: swimming'),
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          TextField(
                            onChanged: (value) {
                              setState(() {
                                rating = int.parse(value);
                                if (rating < 1) {
                                  rating = 1;
                                }
                                if (rating > 10) {
                                  rating = 10;
                                }
                              });
                            },
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                                labelText: 'Rating',
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Colors.blueAccent, width: 1.0),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Colors.blueAccent, width: 2.0),
                                ),
                                hintText: 'Example: 5 (max : 10, min : 1)'),
                          ),
                        ],
                      ),
                    ),
                    actions: [
                      FlatButton(
                          onPressed: () async {
                            if (hobby.isNotEmpty && rating != null) {
                              await _firestore
                                  .collection('Users')
                                  .doc(_uid)
                                  .collection('Hobbies')
                                  .doc(hobby.toLowerCase())
                                  .set({
                                'hobby': hobby.trim(),
                                'rating': rating,
                              }).then((value) {
                                print('hobby added');
                                setState(() {
                                  hobby = null;
                                  rating = null;
                                });
                                Navigator.pop(context);
                              });
                            } else {
                              Navigator.pop(context);
                            }
                          },
                          child: Text('Submit')),
                      FlatButton(
                          onPressed: () => Navigator.pop(context),
                          child: Text('Cancel'))
                    ],
                  );
                },
              );
            },
          ),
          IconButton(
              icon: Icon(
                Icons.exit_to_app,
                color: Colors.white,
                size: 30,
              ),
              onPressed: () async {
                await _auth.signOut();
                Navigator.pushReplacementNamed(context, SignInScreen.id);
              }),
        ],
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        padding: EdgeInsets.all(20),
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: Colors.white,
              ),
              child: Row(
                children: [
                  CircularProfileAvatar(
                    '',
                    backgroundColor: Colors.red[100],
                    initialsText: Text(
                      _name != null ? _name[0].toString().toUpperCase() : '',
                      style: TextStyle(fontSize: 60),
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _name.toUpperCase(),
                        style: TextStyle(fontSize: 30),
                      ),
                      Text(
                        _email,
                        style: TextStyle(fontSize: 12),
                      )
                    ],
                  )
                ],
              ),
            ),
            SizedBox(
              height: 10,
            ),
            listContainer(),
          ],
        ),
      ),
    );
  }

  listContainer() {
    return Container(
      height: 500,
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20), color: Colors.white),
      child: StreamBuilder(
        stream: _stream,
        builder: (context, snapshot) {
          return snapshot.hasData
              ? ListView.builder(
                  itemCount: snapshot.data.docs.length,
                  itemBuilder: (context, index) {
                    return Card(
                        child: Container(
                      padding: EdgeInsets.all(10),
                      child: Text(
                        snapshot.data.docs[index].data()['hobby'],
                        style: TextStyle(fontSize: 20),
                      ),
                    ));
                  },
                )
              : Container(
                  child: Center(
                    child: Text('Add your hobbies here'),
                  ),
                );
        },
      ),
    );
  }
}
