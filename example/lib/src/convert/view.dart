import 'dart:io';

import 'package:example/src/helpes.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

class ConvertPage extends StatefulWidget {
  const ConvertPage({Key? key}) : super(key: key);

  @override
  State<ConvertPage> createState() => _ConvertPageState();
}

class _ConvertPageState extends State<ConvertPage> {
  String fileSelect = '';
  String outputFile = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Convert video to mp3'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextButton(
              onPressed: _onSelectFile,
              child: const Text('Select File'),
            ),
            Text(
              fileSelect.toString(),
              textAlign: TextAlign.center,
            ),
            const Divider(),
            TextButton(
              onPressed: _onConvert,
              child: const Text('Convert'),
            ),
            Text(
              outputFile,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _onSelectFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();

    if (result != null) {
      setState(() {
        fileSelect = result.paths.single!;
      });
    }
  }

  Future<void> _onConvert() async {
    // final Directory root = await AppHelper.getRoot('audio_cutter');
    // final outPath = "${root.path}/convert${DateTime.now().millisecondsSinceEpoch}.mp3";
    //
    // var cmd = "-i $fileSelect -q:a 0 -map a $outPath";
    // var t = await FFmpegKit.execute(cmd);
    // print("code result: ${await t.getReturnCode()}");
  }
}
