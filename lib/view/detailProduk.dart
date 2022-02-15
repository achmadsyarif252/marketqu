import 'package:flutter/material.dart';
import '../model/produkModel.dart';

class DetailProduk extends StatefulWidget {
  final ProdukModel model;

  DetailProduk(
    this.model,
  );

  @override
  DetailProdukState createState() => DetailProdukState();
}

class DetailProdukState extends State<DetailProduk> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: NestedScrollView(
          headerSliverBuilder: (BuildContext context, bool isInnerboxSelected) {
            return <Widget>[
              SliverAppBar(
                expandedHeight: 200,
                floating: false,
                pinned: true,
                flexibleSpace: FlexibleSpaceBar(
                  background: Hero(
                      tag: widget.model.id,
                      child: Image.network(
                        "http://192.168.0.140/marketq/upload/" +
                            widget.model.image,
                        fit: BoxFit.cover,
                      )),
                ),
              ),
            ];
          },
          body: Stack(
            children: <Widget>[
              Positioned(
                child: Column(
                  children: <Widget>[
                    Text(widget.model.namaProduk),
                    Text(widget.model.harga),
                  ],
                ),
                top: 30,
                right: 10,
                left: 10,
              ),
              Positioned(
                child: Container(
                  padding: EdgeInsets.all(16.0),
                  child: Material(
                    color: Colors.orange,
                    borderRadius: BorderRadius.circular(10.0),
                    child: MaterialButton(
                      onPressed: () {},
                      child: Text(
                        "Add Cart",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ),
                bottom: 10.0,
                left: 0.0,
                right: 0,
              ),
            ],
          )),
    );
  }
}
