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
  String mockStringData;

  //Below two variable will be used for decoding API response.
  Map<String, dynamic> datamodel;
  List<dynamic> alAllData;
  String mockData, title = "", body = '', userId = '', id = '';

  Future getMainCategory() async {
    final pathUrl = "http://103.240.90.81:8101/api/get_spdata";
    dynamic data = {
      "Mode": "getallactivecategory",
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

  //After API call done, decode API response related stuff START
  Future decodeData() async {
    print("decodeData methd is calling !!! ");
    final Map parsedDdata = await json.decode(mockData);
    print(parsedDdata['data']);
    setState(() {
      alAllData = parsedDdata['data'];
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
      body: Container(
        child: FutureBuilder(
          future: getMainCategory().whenComplete(
            () async {
              await decodeData();
            },
          ),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (!snapshot.hasData) {
              return Center(child: CircularProgressIndicator());
            }
            return ListView.builder(
                itemCount: alAllData.length,
                itemBuilder: (BuildContext context, int index) {
                  return Card(
                    child: ListTile(
                      title: Text(alAllData[index]['ItemCategoryName']),
                      subtitle: Text(alAllData[index]['ShortName']),
                    ),
                  );
                });
          },
        ),
      ),
    );
  }
}
