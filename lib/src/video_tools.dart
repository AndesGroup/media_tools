import 'dart:io';

import 'package:ffmpeg_kit_flutter_full/ffmpeg_kit.dart';
import 'package:ffmpeg_kit_flutter_full/return_code.dart';
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
}
