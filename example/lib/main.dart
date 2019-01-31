import 'package:barcode_lib/barcode_lib.dart';
import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "QR code demo",
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: BarcodeLib(),
    );
  }
}
