import 'dart:convert';

import 'package:flutter/material.dart';
import '../model/api.dart';
import '../model/produkModel.dart';
import 'package:http/http.dart' as http;

class EditProduk extends StatefulWidget {
  final VoidCallback reload;
  final ProdukModel model;
  EditProduk(this.model, this.reload);
  @override
  _EditProdukState createState() => _EditProdukState();
}

class _EditProdukState extends State<EditProduk> {
  final _key = GlobalKey<FormState>();
  String? namaProduk, qty, harga;

  TextEditingController? txtNama, txtQty, txtHarga;
  setup() {
    txtNama = TextEditingController(text: widget.model.namaProduk);
    txtQty = TextEditingController(text: widget.model.qty);
    txtHarga = TextEditingController(text: widget.model.harga);
  }

  @override
  void initState() {
    super.initState();
    setup();
  }

  check() {
    final form = _key.currentState;
    if (form!.validate()) {
      form.save();
      submit();
    } else {}
  }

  submit() async {
    final response = await http.post(Uri.parse(BaseUrl.editProduk), body: {
      "namaProduk": namaProduk,
      "qty": qty,
      "harga": harga,
      "idProduk": widget.model.id,
    });
    final data = jsonDecode(response.body);
    int value = data['value'];
    String pesan = data['message'];
    if (value == 1) {
      setState(() {
        widget.reload();
        Navigator.pop(context);
      });
    } else {
      print(pesan);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Edit Produk")),
      body: Form(
        key: _key,
        child: ListView(
          padding: EdgeInsets.all(16),
          children: <Widget>[
            TextFormField(
              controller: txtNama,
              onSaved: (e) => namaProduk = e,
              decoration: InputDecoration(labelText: "Nama Produk"),
            ),
            TextFormField(
              controller: txtQty,
              onSaved: (e) => qty = e,
              decoration: InputDecoration(labelText: "Qty"),
            ),
            TextFormField(
              controller: txtHarga,
              onSaved: (e) => harga = e,
              decoration: InputDecoration(labelText: "Harga"),
            ),
            MaterialButton(
                onPressed: () {
                  check();
                },
                child: Text("Submit Changes")),
          ],
        ),
      ),
    );
  }
}
