import 'dart:convert';
import '../model/api.dart';
import '../nestedJson.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'mainMenu.dart';
import 'view/menuUsers.dart';

void main() {
  runApp(
    MaterialApp(
      home: Login(),
    ),
  );
}

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

enum LoginStatus { notSignIn, signIn, signInUsers }

class _LoginState extends State<Login> {
  LoginStatus _loginStatus = LoginStatus.notSignIn;
  String? username, password;
  final _key = GlobalKey<FormState>();
  bool obscuretex = true;
  showHide() {
    setState(() {
      obscuretex = !obscuretex;
    });
  }

  check() {
    final form = _key.currentState;
    if (form!.validate()) {
      form.save();
      print("$username,$password");
      login();
    } else {
      setState(() {
        _autovalidate = true;
      });
    }
  }

  login() async {
    final response = await http.post(Uri.parse(BaseUrl.login),
        body: {"username": username, "password": password});
    final data = jsonDecode(response.body);
    int value = data['value'];
    String pesan = data['message'];
    String usernameAPI = data['username'];
    String namaApi = data['nama'];
    String id = data['id'];
    String level = data['level'];
    if (value == 1) {
      setState(() {
        _loginStatus = LoginStatus.signIn;
        print("DISINI");
        savePref(value, usernameAPI, namaApi, id, level);
        print("checkpoint");
      });

      print(pesan);
    } else {
      print(pesan);
    }
    print(data);
  }

  savePref(
      int value, String username, String nama, String id, String level) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();

    setState(() {
      preferences.setInt("value", value);
      preferences.setString("username", username);
      preferences.setString("nama", nama);
      preferences.setString("id", id);
      preferences.setString("level", level);
      if (preferences.getString("level") == "2") {
        setState(() {
          _loginStatus = LoginStatus.signInUsers;
        });
      }
    });
  }

  var _autovalidate = false;

  var value;
  getPref() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    // ignore: unused_element
    setState() {
      value = preferences.getString("level");
      _loginStatus = value == "1"
          ? LoginStatus.signIn
          : value == "2"
              ? LoginStatus.signInUsers
              : LoginStatus.notSignIn;
    }
  }

  signOut() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      preferences.remove("value");
      _loginStatus = LoginStatus.notSignIn;
    });
  }

  @override
  Widget build(BuildContext context) {
    switch (_loginStatus) {
      case LoginStatus.notSignIn:
        return Scaffold(
          appBar: AppBar(),
          body: Form(
            autovalidateMode: AutovalidateMode.always,
            key: _key,
            child: ListView(
              padding: EdgeInsets.all(16.0),
              children: <Widget>[
                TextFormField(
                  // ignore: missing_return
                  validator: (e) {
                    if (e!.isEmpty) {
                      return "Please Insert Username";
                    }
                    // } else if (!e.contains("@")) {
                    //   return "Wrong FOrmat username";
                    // }
                  },
                  onSaved: (e) => username = e,
                  decoration: InputDecoration(labelText: "Username"),
                ),
                TextFormField(
                  // ignore: missing_return
                  validator: (e) {
                    if (e!.isEmpty) {
                      return "Please Insert Password";
                    }
                  },
                  obscureText: obscuretex,
                  onSaved: (e) => password = e,
                  decoration: InputDecoration(
                      suffixIcon: IconButton(
                          icon: Icon(obscuretex
                              ? Icons.visibility_off
                              : Icons.visibility),
                          onPressed: () {
                            showHide();
                          }),
                      labelText: "Password"),
                ),
                MaterialButton(
                  onPressed: () {
                    check();
                  },
                  child: Text("Login"),
                ),
                InkWell(
                    onTap: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => Register()));
                    },
                    child: Text("Create a new Accout ,in Here",
                        textAlign: TextAlign.center)),
              ],
            ),
          ),
        );
      case LoginStatus.signIn:
        return MainMenu(signOut);
      case LoginStatus.signInUsers:
        return MenuUser(signOut);
    }
  }
}

class Register extends StatefulWidget {
  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  String? username, password, nama;
  final _key = new GlobalKey<FormState>();
  bool obscuretex = true;
  showHide() {
    setState(() {
      obscuretex = !obscuretex;
    });
  }

  var _autovalidate = false;
  check() {
    final form = _key.currentState;
    if (form!.validate()) {
      form.save();
      save();
    } else {
      setState(() {
        _autovalidate = true;
      });
    }
  }

  save() async {
    final response = await http.post(Uri.parse(BaseUrl.register), body: {
      "username": username,
      "password": password,
      "nama": nama,
    });
    final data = jsonDecode(response.body);
    int value = data['value'];
    String pesan = data['message'];
    if (value == 1) {
      setState(() {
        Navigator.pop(context);
      });
    } else {
      print(pesan);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Form(
        autovalidateMode: AutovalidateMode.always,
        key: _key,
        child: ListView(padding: EdgeInsets.all(16), children: [
          TextFormField(
            // ignore: missing_return
            validator: (e) {
              if (e!.isEmpty) {
                return "Please Insert Full Name";
              }
            },
            onSaved: (e) => nama = e,
            decoration: InputDecoration(labelText: "Nama Lengkap"),
          ),
          TextFormField(
            // ignore: missing_return
            validator: (e) {
              if (e!.isEmpty) {
                return "Please Insert Username";
              }
            },
            onSaved: (e) => username = e!,
            decoration: InputDecoration(labelText: "Username"),
          ),
          TextFormField(
            // ignore: missing_return
            validator: (e) {
              if (e!.isEmpty) {
                return "Please Insert Password";
              } else if (e.length < 8) {
                return "Minimal Kata Sandi 8 Karakter";
              }
            },
            obscureText: obscuretex,
            onSaved: (e) => password = e,
            decoration: InputDecoration(
                suffixIcon: IconButton(
                    icon: Icon(
                        obscuretex ? Icons.visibility_off : Icons.visibility),
                    onPressed: () {
                      showHide();
                    }),
                labelText: "Password"),
          ),
          MaterialButton(
            onPressed: () {
              check();
            },
            child: Text("Register"),
          ),
        ]),
      ),
    );
  }
}
