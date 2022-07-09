import 'dart:io';

import 'package:example/src/helpes.dart';
import 'package:ffmpeg_kit_flutter/ffmpeg_kit.dart';
import 'package:ffmpeg_kit_flutter/log.dart';
import 'package:ffmpeg_kit_flutter/session.dart';
import 'package:ffmpeg_kit_flutter/statistics.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

class ConcatPage extends StatefulWidget {
  const ConcatPage({Key? key}) : super(key: key);

  @override
  State<ConcatPage> createState() => _ConcatPageState();
}

class _ConcatPageState extends State<ConcatPage> {
  List<String> fileSelect = [];
  String outputFile = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Concat'),
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
              onPressed: _onConcat,
              child: const Text('Concat'),
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
    FilePickerResult? result = await FilePicker.platform.pickFiles(allowMultiple: true);

    if (result != null) {
      setState(() {
        fileSelect = result.paths.map((e) => e!).toList();
      });
      print("join: ${fileSelect.join('|')}");
    }
  }

  Future<void> _onConcat() async {
    final Directory root = await AppHelper.getRoot('audio_cutter');
    final outPath = "${root.path}/output${DateTime.now().millisecondsSinceEpoch}.mp3";

    var cmd = "-i \"concat:${fileSelect.join('|')}\" -acodec copy $outPath";
    var t = await FFmpegKit.execute(cmd);
    print("code result: ${await t.getReturnCode()}");
  }
}
