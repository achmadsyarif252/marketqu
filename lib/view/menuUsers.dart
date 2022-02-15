import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../model/api.dart';
import '../model/keranjangModel.dart';
import '../model/produkModel.dart';
import '../view/detailProduk.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MenuUser extends StatefulWidget {
  final VoidCallback signOut;
  MenuUser(this.signOut);
  @override
  _MenuUserState createState() => _MenuUserState();
}

class _MenuUserState extends State<MenuUser> {
  final money = NumberFormat("#,##0", "en_US");

  String? idUser;
  getPref() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      idUser = preferences.getString("id");
    });
    _lihatData();
  }

  final GlobalKey<RefreshIndicatorState> _refresh =
      new GlobalKey<RefreshIndicatorState>();
  final list = <ProdukModel>[];
  var loading = false;
  Future<void> _lihatData() async {
    list.clear();
    setState(() {
      loading = true;
    });
    final response = await http.get(Uri.parse(BaseUrl.lihatProduk));
    if (response.contentLength == 2) {
    } else {
      final data = jsonDecode(response.body);
      data.forEach((api) {
        final ab = new ProdukModel(
            api['id'],
            api['namaProduk'],
            api['qty'],
            api['harga'],
            api['createdDate'],
            api['idUser'],
            api['nama'],
            api['image']);

        list.add(ab);
      });
      setState(() {
        _jumlahKeranjang();
        loading = false;
      });
    }
  }

  tambahKeranjang(String idProduk, String harga) async {
    final response = await http.post(Uri.parse(BaseUrl.tambahKeranjang), body: {
      "idUser": "1",
      "idProduk": idProduk,
      "harga": harga,
    });
    final data = jsonDecode(response.body);
    int value = data['value'];
    String pesan = data['message'];
    if (value == 1) {
      print(pesan);
      _jumlahKeranjang();
    } else {
      print(pesan);
    }
  }

  String jumlah = "0";
  final ex = <KeranjangModel>[];
  _jumlahKeranjang() async {
    ex.clear();
    setState(() {
      loading = true;
    });
    final response = await http.get(Uri.parse(BaseUrl.jumlahKeranjang + "1"));
    final data = jsonDecode(response.body);
    data.forEach((api) {
      final exp = new KeranjangModel(api['jumlah']);
      ex.add(exp);
      jumlah = exp.jumlah;
    });
    setState(() {
      loading = false;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getPref();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: <Widget>[
          Stack(
            children: <Widget>[
              IconButton(
                  icon: Icon(
                    Icons.shopping_cart,
                    color: Colors.white,
                  ),
                  onPressed: () {}),
              jumlah == "0"
                  ? Container()
                  : Positioned(
                      right: 0.0,
                      child: Stack(
                        children: <Widget>[
                          Icon(
                            Icons.brightness_1,
                            size: 25.0,
                            color: Colors.orange,
                          ),
                          Positioned(
                            top: 4,
                            right: 6,
                            child: Text(jumlah,
                                style: TextStyle(
                                    color: Colors.white, fontSize: 11.0)),
                          ),
                        ],
                      ),
                    )
            ],
          ),
          IconButton(
              icon: Icon(Icons.lock_open),
              onPressed: () {
                setState(() {
                  widget.signOut();
                });
              })
        ],
      ),
      body: Container(
          child: GridView.builder(
              itemCount: list.length,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount:
                      MediaQuery.of(context).orientation == Orientation.portrait
                          ? 2
                          : 3),
              itemBuilder: (context, i) {
                final x = list[i];
                return InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => DetailProduk(
                          x,
                        ),
                      ),
                    );
                  },
                  child: Card(
                    child: Column(
                      children: <Widget>[
                        Expanded(
                          child: Hero(
                            tag: x.id,
                            child: Image.network(
                                "http://192.168.0.140/marketq/upload/${x.image}",
                                fit: BoxFit.cover),
                          ),
                        ),
                        Text(
                          x.namaProduk,
                          textAlign: TextAlign.center,
                        ),
                        Text("Rp" + money.format(int.parse(x.harga))),
                        SizedBox(
                          height: 10.0,
                        ),
                        RaisedButton(
                          onPressed: () {
                            tambahKeranjang(x.id, x.harga);
                          },
                          color: Colors.orange,
                          child: Text(
                            "Beli",
                            style: TextStyle(color: Colors.white),
                          ),
                        )
                      ],
                    ),
                  ),
                );
              })),
    );
  }
}
