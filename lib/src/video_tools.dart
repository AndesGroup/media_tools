import 'dart:io';

import 'package:ffmpeg_kit_flutter_full/ffmpeg_kit.dart';
import 'package:ffmpeg_kit_flutter_full/ffprobe_kit.dart';
import 'package:ffmpeg_kit_flutter_full/return_code.dart';
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';

class VideoTools {
  /// Convert a Video file to Audio file, throw exception when error
  static Future<File> convertVideoToAudio(File fileVideo) async {
    Directory appDocDir = await getTemporaryDirectory();
    String outPath =
        '${appDocDir.path}/converted-${DateTime.now().millisecondsSinceEpoch}.mp3';

    String cmd = '-y -i ${fileVideo.path} -b:a 128K $outPath';

    final session = await FFmpegKit.execute(cmd);
    final returnCode = await session.getReturnCode();
    if (ReturnCode.isSuccess(returnCode)) {
      // SUCCESS
      return File(outPath);
    } else if (ReturnCode.isCancel(returnCode)) {
      // CANCEL
      throw Exception(await session.getAllLogsAsString());
    } else {
      // ERROR
      throw Exception(await session.getAllLogsAsString());
    }
  }

  /// Cut Video from [start] to [end], throw exception when error
  static Future<File> cutVideo(
      File fileVideo, Duration start, Duration end) async {
    Directory appDocDir = await getTemporaryDirectory();
    String outPath =
        '${appDocDir.path}/cut-${DateTime.now().millisecondsSinceEpoch}.${fileVideo.path.split('.')[1]}';

    String cmd =
        '-y -ss $start -to $end  -i ${fileVideo.path} -c copy $outPath';

    final session = await FFmpegKit.execute(cmd);
    final returnCode = await session.getReturnCode();
    if (ReturnCode.isSuccess(returnCode)) {
      // SUCCESS
      return File(outPath);
    } else if (ReturnCode.isCancel(returnCode)) {
      // CANCEL
      throw Exception(await session.getAllLogsAsString());
    } else {
      // ERROR
      throw Exception(await session.getAllLogsAsString());
    }
  }

  /// Get duration of Video file, throw Exception when error
  static Future<Duration> getDuration(File file) async {
    String query =
        '-i ${file.path} -v quiet -show_entries format=duration -hide_banner -of default=noprint_wrappers=1:nokey=1';

    final session = await FFprobeKit.execute(query);
    final returnCode = await session.getReturnCode();
    if (ReturnCode.isSuccess(returnCode)) {
      try {
        double duration = double.parse(await session.getLogsAsString());

        return Duration(
            seconds: duration.toInt(),
            milliseconds: (duration % 1.0 * 1000).toInt());
      } catch (e) {
        if (kDebugMode) {
          print(e);
        }
        throw Exception(e);
      }
    } else if (ReturnCode.isCancel(returnCode)) {
      throw Exception(await session.getLogsAsString());
    } else {
      throw Exception(await session.getLogsAsString());
    }
  }
}
