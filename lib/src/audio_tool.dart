import 'dart:io';

import 'package:ffmpeg_kit_flutter/ffmpeg_kit.dart';
import 'package:ffmpeg_kit_flutter/ffprobe_kit.dart';
import 'package:ffmpeg_kit_flutter/return_code.dart';
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';

class AudioTool {
  /// Get duration of audio file
  static Future<Duration?> getDuration(File file) async {
    String query =
        '-i ${file.path} -v quiet -show_entries format=duration -hide_banner -of default=noprint_wrappers=1:nokey=1';

    final session = await FFprobeKit.execute(query);
    final returnCode = await session.getReturnCode();
    if (ReturnCode.isSuccess(returnCode)) {
      try {
        double duration = double.parse(await session.getLogsAsString());

        return Duration(seconds: duration.toInt(), milliseconds: (duration % 1.0 * 1000).toInt());
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

  /// Return audio file path after cutting
  static Future<File> cutAudio(File file, double start, double end) async {
    if (start < 0 || end < 0) {
      throw ArgumentError('The starting and ending points cannot be negative');
    }
    if (start > end) {
      throw ArgumentError('The starting point cannot be greater than the ending point');
    }

    final Directory dir = await getTemporaryDirectory();
    final outPath = "${dir.path}/audio_cutter/output.mp3";
    final result = await File(outPath).create(recursive: true);

    var cmd =
        "-y -i \"${file.path}\" -vn -ss $start -to $end -ar 16k -ac 2 -b:a 96k -acodec copy $outPath";
    await FFmpegKit.execute(cmd);

    return result;
  }
}
