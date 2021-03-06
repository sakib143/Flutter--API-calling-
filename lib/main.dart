import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.green,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(title: 'API Demo Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  //Post api request related stuff by Sakib START
  Dio dio = new Dio();
  //Below two variable will be used for decoding API response.
  Map<String, dynamic> datamodel;
  String mockData, title = "", body = '', userId = '', id = '';

  Future postData() async {
    final pathUrl = "https://jsonplaceholder.typicode.com/posts";
    dynamic data = {
      "title": "Flutter api calling",
      "body": "Flutter body",
      "userId": 1
    };
    var response = await dio.post(
      pathUrl,
      data: data,
      options: Options(
        headers: {
          'Content-type': 'application/json; charset=UTF-8',
        },
      ),
    );
    setState(() {
      mockData = response.toString(); // Add data to string for decoding.
    });
    return response.data;
  }
  //Post api request related stuff by Sakib END

// //After API call done, decode API response related stuff START
  Future decodeData() async {
    print("decodeData methd is calling !!! ");
    final Map parsedDdata = await json.decode(mockData);
    setState(() {
      title = parsedDdata['title'];
      body = parsedDdata['body'];
      id = parsedDdata['id'].toString();
      userId = parsedDdata['userId'].toString();
    });
  }
  //After API call done, decode API response related stuff END

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: Text("Flutter - Retrofit Implementation"),
        ),
        body: Center(
          child: Column(
            children: [
              MaterialButton(
                color: Colors.black,
                onPressed: () async {
                  print("Posting data");
                  await postData().then((value) {
                    print("API response");
                    print(value);
                  }).whenComplete(() async {
                    await decodeData();
                  });
                },
                child: Text(
                  "Post",
                  style: TextStyle(color: Colors.white),
                ),
              ),
              Text('Title:- $title'),
              Text('Body:-  $body'),
              Text('User id :-  $userId'),
              Text('Id:-  $id'),
            ],
          ),
        ));
  }
}
