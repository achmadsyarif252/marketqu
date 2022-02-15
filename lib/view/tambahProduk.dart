import 'dart:convert';
import 'dart:io';
import 'package:async/async.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import '../custom/currency.dart';
import '../custom/datePicker.dart';
import '../model/api.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as path;

class TambahProduk extends StatefulWidget {
  final VoidCallback reload;
  TambahProduk(this.reload);
  @override
  _TambahProdukState createState() => _TambahProdukState();
}

class _TambahProdukState extends State<TambahProduk> {
  File? _imageFile;
  String? namaProduk, qty, harga, idUser;
  final _key = GlobalKey<FormState>();
  getPref() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      idUser = preferences.getString("idUser");
    });
  }

  String? pilihTanggal, labeltext;
  DateTime tgl = DateTime.now();
  final TextStyle valueStyle = TextStyle(fontSize: 16.0);
  Future<Null> _selectedDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: tgl,
        firstDate: DateTime(1992),
        lastDate: DateTime(2099));
    if (picked != null && picked != tgl) {
      setState(() {
        tgl = picked;
        pilihTanggal = new DateFormat.yMd().format(tgl);
      });
    } else {}
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getPref();
  }

  check() {
    final form = _key.currentState;
    if (form!.validate()) {
      form.save();
      submit();
    }
  }

  submit() async {
    try {
      var stream =
          http.ByteStream(DelegatingStream.typed(_imageFile!.openRead()));
      var length = await _imageFile!.length();
      var uri = Uri.parse(BaseUrl.tambahProduk);
      var request = http.MultipartRequest("POST", uri);
      request.fields['namaProduk'] = namaProduk!;
      request.fields['qty'] = qty!;
      request.fields['harga'] = harga!.replaceAll(",", "");
      request.fields['idUser'] = "1";
      request.fields['expDate'] = "$tgl";
      request.files.add(http.MultipartFile("image", stream, length,
          filename: path.basename(_imageFile!.path)));
      var response = await request.send();
      if (response.statusCode > 2) {
        print("Image Uploaded");
        setState(() {
          widget.reload();
          Navigator.pop(context);
        });
      } else {
        print("Image Failed Upload");
      }
    } catch (e) {
      debugPrint("Error :$e");
    }
  }

  _pilihGalery() async {
    var image = await ImagePicker().pickImage(
        source: ImageSource.gallery, maxHeight: 1920, maxWidth: 1000);
    setState(() {
      _imageFile = File(image!.path);
    });
  }

  _pilihKamera() async {
    var image = await ImagePicker()
        .pickImage(source: ImageSource.camera, maxHeight: 1920, maxWidth: 1000);
    setState(() {
      _imageFile = image as File;
    });
  }

  @override
  Widget build(BuildContext context) {
    var placeholder = Container(
      width: double.infinity,
      height: 250,
      child: Icon(
        Icons.image,
        size: 100,
      ),
    );
    return Scaffold(
      appBar: AppBar(),
      body: Form(
        key: _key,
        child: ListView(
          padding: EdgeInsets.all(16),
          children: <Widget>[
            Container(
              width: double.infinity,
              height: 250.0,
              child: InkWell(
                onTap: () {
                  _pilihGalery();
                },
                child: _imageFile == null
                    ? placeholder
                    : Image.file(
                        _imageFile!,
                        fit: BoxFit.cover,
                      ),
              ),
            ),
            TextFormField(
              onSaved: (e) => namaProduk = e,
              decoration: InputDecoration(labelText: "Nama Produk"),
            ),
            TextFormField(
              onSaved: (e) => qty = e,
              decoration: InputDecoration(labelText: "Qty"),
            ),
            TextFormField(
              onSaved: (e) => harga = e,
              decoration: InputDecoration(labelText: "Harga"),
            ),
            DateDropDown(
              labelText: labeltext,
              valueText: DateFormat.yMd().format(tgl),
              valueStyle: valueStyle,
              onPressed: () {
                _selectedDate(context);
              },
            ),
            MaterialButton(
                onPressed: () {
                  check();
                },
                child: Text("Submit")),
          ],
        ),
      ),
    );
  }
}
