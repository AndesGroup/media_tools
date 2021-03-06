import 'dart:io';

import 'package:example/src/helpes.dart';
import 'package:ffmpeg_kit_flutter_full/ffmpeg_kit.dart';
import 'package:ffmpeg_kit_flutter_full/return_code.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:media_tools/media_tools.dart';

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
              onPressed: _onConcatAudio,
              child: const Text('Concat Audio'),
            ),
            TextButton(
              onPressed: _onConcatVideo,
              child: const Text('Concat Video'),
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
    FilePickerResult? result =
        await FilePicker.platform.pickFiles(allowMultiple: true);

    if (result != null) {
      setState(() {
        fileSelect = result.paths.map((e) => e!).toList();
      });
      print("join: ${fileSelect.join('|')}");
    }
  }

  Future<void> _onConcatAudio() async {
    bool s = true;
    try {
      final output =
          await AudioTools.concatAudio(fileSelect.map((e) => File(e)).toList());
      setState(() => outputFile = output.path);
    } catch (e) {
      s = false;
    }
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(s ? "Success" : "Error"),
        ),
      );
    return;
    final Directory root = await AppHelper.getRoot('audio_cutter');
    final outPath =
        "${root.path}/output${DateTime.now().millisecondsSinceEpoch}.mp3";

    var cmd = "-i \"concat:${fileSelect.join('|')}\" -acodec copy $outPath";
    var result = await FFmpegKit.execute(cmd);
    bool success = ReturnCode.isSuccess(await result.getReturnCode());
    if (success) {
      setState(() => outputFile = outPath);
    }
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(success ? "Success" : "Error"),
        ),
      );
  }

  Future<void> _onConcatVideo() async {
    bool s = true;
    try {
      final output =
          await VideoTools.concatVideo(fileSelect.map((e) => File(e)).toList());
      setState(() => outputFile = output.path);
    } catch (e) {
      s = false;
    }
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(s ? "Success" : "Error"),
        ),
      );
  }
}
