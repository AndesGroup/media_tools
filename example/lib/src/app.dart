import 'package:example/src/concat/view.dart';
import 'package:example/src/convert/view.dart';
import 'package:example/src/home/view.dart';
import 'package:flutter/material.dart';

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Media Tools Example',
      home: ConvertPage(),
    );
  }
}
