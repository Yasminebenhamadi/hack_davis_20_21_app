import 'dart:convert';

import 'package:circular_profile_avatar/circular_profile_avatar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'classes/outdoordata.dart';
import 'utilities/constants.dart';
import 'package:http/http.dart' as http;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:developer';

class DisplayScreen extends StatefulWidget {
  static const String id = "DisplayScreen";

  @override
  _DisplayScreenState createState() => _DisplayScreenState();
}

class _DisplayScreenState extends State<DisplayScreen> {
  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  Stream<QuerySnapshot> _stream;
  int _currIndex = 0;
  OutdoorData _data;

  getdata() async {
    var data = await requestAPI();
    setState(() {
      _data = data;
      print('data: $_data');
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _stream = _firestore.collection('Users').snapshots();
    getdata();
    log('data:$_data');
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('The Mavenclaws'),
          backgroundColor: Colors.green[700],
        ),
        body: IndexedStack(
          //Using indexedStack to ensure the pages dont get destroy when sitching tab
          children: getWidgetList(),
          index: _currIndex,
        ),
        bottomNavigationBar: BottomNavigationBar(
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
                icon: Icon(Icons.location_city), title: Text("Info")),
            BottomNavigationBarItem(
              icon: Icon(Icons.map),
              title: Text("Map"),
            ),
            BottomNavigationBarItem(
                icon: Icon(Icons.graphic_eq), title: Text("Graph")),
            BottomNavigationBarItem(
                icon: Icon(Icons.list), title: Text("Settings"))
          ],
          selectedItemColor: Colors.redAccent,
          currentIndex: _currIndex,
          unselectedItemColor: Colors.black,
          onTap: _onTap,
        ),
      ),
    );
  }

  void _onTap(int index) {
    setState(() {
      _currIndex = index;
    });
  }

  List<Widget> getWidgetList() {
    return <Widget>[
      Container(
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
                      'U',
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
                        'User 1'.toUpperCase(),
                        style: TextStyle(fontSize: 30),
                      ),
                      Text(
                        'email@example.com',
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
            // listContainer(),
          ],
        ),
      ),
//      CustomScrollView(
//        slivers: <Widget>[
//          SliverToBoxAdapter(
//            child: AspectRatio(
//              aspectRatio: 10,
//              child: Text("USERS NEARBY", style: kHeaderTextStyle,)
//            ),
//          ),
//          SliverFixedExtentList(
//            itemExtent: 70,
//            delegate: SliverChildBuilderDelegate(
//                  (BuildContext context, int index) {
//                return FlatButton(
//                  child: Container(
//                      alignment: Alignment.center,
//                      color: Colors.lightBlue[100 * (index % 9)],
//                      child: Text("Hi"),
//                  ),
//                  onPressed: () {
//                  },
//                );
//              },
//            ),
//          ),
//        ],
//      ),
      StreamBuilder(
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
      Container(),
      Center(
        child: Column(
          children: <Widget>[
            Card(
              child: Container(
                  padding: EdgeInsets.all(10),
                  child: Text(
                      '${_data.content}. Current temperature is ${_data.temp}, covid cases number is ${_data.covidCases}, please avoid social gathering')),
              shape: RoundedRectangleBorder(
                side: BorderSide(color: Colors.white70, width: 1),
                borderRadius: BorderRadius.circular(10),
              ),
              elevation: 20,
              margin: EdgeInsets.all(20),
              color: Colors.yellow[200],
            ),
            Container(
              padding: EdgeInsets.all(10),
              margin: EdgeInsets.all(10),
              width: 160,
              height: 160,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.blue,
                border: Border.all(color: Colors.cyan[300], width: 13),
              ),
              child: RawMaterialButton(
                child: Text("Get Advice"),
                elevation: 11,
                onPressed: null,
                shape: CircleBorder(),
                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
            ),
            FlatButton(
                onPressed: () {
                  print(_data.temp);
                  print(_data.content);
                  print(_data.covidCases);
                },
                child: Text('press'))
          ],
        ),
      ),
    ];
  }

  Future<OutdoorData> requestAPI() async {
    final response = await http.get(
        'https://4dd1aea4a605.ngrok.io/checkactivities?userID=user123&fishing=10&hanggliding=8&hiking=2');

    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      print('data fetched');
      return OutdoorData.fromJson(jsonDecode(response.body));
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load album');
    }
  }
}
