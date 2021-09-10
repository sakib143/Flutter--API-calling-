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
  Dio dio = new Dio();

  Future getData() async {
    final String pathUrl = 'https://jsonplaceholder.typicode.com/posts/1';
    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (RequestOptions option) async {
          var header = {
            'Content-type': 'application/json; charset=UTF-8',
            'Accept': 'application/json',
          };
          option.headers.addAll(header);
          return option.data;
        },
      ),
    );

    Response response = await dio.get(pathUrl);
    return response.data;
  }

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
                  print('Geting data');
                  await getData().then((value) => {
                        print(value),
                      });
                },
                child: Text(
                  "Get",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
        ));
  }
}
