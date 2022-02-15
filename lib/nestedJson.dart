import 'dart:convert';

import 'package:flutter/material.dart';
import '../model2.dart';
import 'package:http/http.dart' as http;

class NestedJson extends StatefulWidget {
  @override
  _NestedJsonState createState() => _NestedJsonState();
}

class _NestedJsonState extends State<NestedJson> {
  List<UserDetail> _list = [];
  var loading = false;
  Future<Null> _fetchData() async {
    setState(() {
      loading = false;
    });
    final response =
        await http.get(Uri.parse("http://jsonplaceholder.typicode.com/user"));
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      setState(() {
        for (Map i in data) {
          _list.add(UserDetail.fromJson(i as Map<String, dynamic>));
        }
        loading = false;
      });
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _fetchData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          elevation: 0.0,
        ),
        body: Container(
            child: loading
                ? Center(child: CircularProgressIndicator())
                : ListView.builder(
                    itemBuilder: (context, i) {
                      final x = _list[i];
                      return Container(
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(x.name!),
                              Text(x.email!),
                              Text(x.phone!),
                              Text(x.website!),
                              SizedBox(height: 5.0),
                              Text("Address",
                                  style: TextStyle(
                                      fontSize: 16.0,
                                      fontWeight: FontWeight.bold)),
                              Text(x.address!.street!),
                              Text(x.address!.suite!),
                              Text(x.address!.city!),
                              Text(x.address!.zipCode!),
                              SizedBox(height: 5.0),
                              Text("Company",
                                  style: TextStyle(
                                      fontSize: 16.0,
                                      fontWeight: FontWeight.bold)),
                              Text(
                                x.company!.name!,
                              ),
                            ]),
                      );
                    },
                    itemCount: _list.length)));
  }
}
