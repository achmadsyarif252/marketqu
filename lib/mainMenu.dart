import 'package:flutter/material.dart';
import '../view/home.dart';
import '../view/product.dart';
import '../view/setting.dart';
import '../view/users.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MainMenu extends StatefulWidget {
  final VoidCallback signout;
  MainMenu(this.signout);
  @override
  _MainMenuState createState() => _MainMenuState();
}

class _MainMenuState extends State<MainMenu> {
  signOut() {
    setState(() {
      widget.signout();
    });
  }

  String? username = "", nama = '';
  getPref() async {
    SharedPreferences   preferences = await SharedPreferences.getInstance();
    setState(() {
      username = preferences.getString("username");
      nama = preferences.getString("nama");
    });
  }

  @override
  void initState() {
    super.initState();
    getPref();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        appBar: AppBar(
          title: Text("$username"),
          // bottom: TabBar(tabs: [
          //   Tab(
          //       icon: Icon(
          //         Icons.home,
          //         size: 30.0,
          //       ),
          //       text: "Home",
          //     ),
          //     Tab(
          //       icon: Icon(
          //         Icons.apps,
          //         size: 30.0,
          //       ),
          //       text: "Product",
          //     ),
          //     Tab(
          //       icon: Icon(
          //         Icons.group,
          //         size: 30.0,
          //       ),
          //       text: "Users",
          //     ),
          //     Tab(
          //       icon: Icon(
          //         Icons.account_circle,
          //         size: 30.0,
          //       ),
          //       text: "Setting",
          //     ),
          // ]),
          actions: <Widget>[
            IconButton(
                icon: Icon(Icons.lock_open),
                onPressed: () {
                  signOut();
                })
          ],
        ),
        body: TabBarView(children: [Home(), Product(), User(), Setting()]),
        bottomNavigationBar: TabBar(
            labelColor: Colors.blue,
            unselectedLabelColor: Colors.grey,
            indicator: UnderlineTabIndicator(
                borderSide: BorderSide(style: BorderStyle.none)),
            tabs: [
              Tab(
                icon: Icon(
                  Icons.home,
                  size: 30.0,
                ),
                text: "Home",
              ),
              Tab(
                icon: Icon(
                  Icons.apps,
                  size: 30.0,
                ),
                text: "Product",
              ),
              Tab(
                icon: Icon(
                  Icons.group,
                  size: 30.0,
                ),
                text: "Users",
              ),
              Tab(
                icon: Icon(
                  Icons.account_circle,
                  size: 30.0,
                ),
                text: "Setting",
              ),
            ]),
      ),
    );
  }
}
