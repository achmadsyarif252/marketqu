import 'dart:convert';

import 'package:flutter/material.dart';
import '../model.dart';
import 'package:http/http.dart' as http;

class SearchJSON extends StatefulWidget {
  @override
  _SearchJSONState createState() => _SearchJSONState();
}

class _SearchJSONState extends State<SearchJSON> {
  List<Posts> _list = [];
  List<Posts> _search = [];
  var loading = false;
  Future<Null> fetchData() async {
    setState(() {
      loading = true;
    });
    _list.clear();
    final response =
        await http.get(Uri.parse("https://jsonplaceholder.typicode.com/posts"));
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      setState(() {
        for (Map i in data) {
          _list.add(Posts.formJson(i as Map<String, dynamic>));
          loading = false;
        }
      });
    }
  }

  TextEditingController controller = TextEditingController();
  onsearch(String text) async {
    _search.clear();
    if (text.isEmpty) {
      setState(() {
        return;
      });
    } else {
      _list.forEach((e) {
        if (e.title!.contains(text) || e.id.toString().contains(text)) {
          _search.add(e);
        }
      });
      setState(() {});
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Container(
          child: loading
              ? Center(child: CircularProgressIndicator())
              : Column(
                  children: <Widget>[
                    Container(
                      padding: EdgeInsets.all(10.0),
                      color: Colors.blue,
                      child: Card(
                        elevation: 5.0,
                        child: ListTile(
                          leading: Icon(Icons.search),
                          trailing: IconButton(
                              icon: Icon(Icons.cancel),
                              onPressed: () {
                                controller.clear();
                                onsearch('');
                              }),
                          title: TextField(
                            controller: controller,
                            onChanged: onsearch,
                            decoration: InputDecoration(
                              hintText: "Search",
                              border: InputBorder.none,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: _search.length != 0 || controller.text.isNotEmpty
                          ? ListView.builder(
                              itemBuilder: (context, i) {
                                final b = _search[i];
                                return Container(
                                  padding: EdgeInsets.all(10.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Text(b.title!,
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 18.0)),
                                      SizedBox(
                                        height: 5,
                                      ),
                                      Text(b.body!)
                                    ],
                                  ),
                                );
                              },
                              itemCount: _search.length,
                            )
                          : ListView.builder(
                              itemBuilder: (context, i) {
                                final a = _list[i];
                                return Container(
                                  padding: EdgeInsets.all(10.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Text(a.title!,
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 18.0)),
                                      SizedBox(
                                        height: 5,
                                      ),
                                      Text(a.body!)
                                    ],
                                  ),
                                );
                              },
                              itemCount: _list.length,
                            ),
                    ),
                  ],
                )),
    );
  }
}
