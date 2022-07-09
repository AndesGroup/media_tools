import 'dart:io';

import 'package:path_provider/path_provider.dart';

class AppHelper{
  static Future<Directory> getRoot(String folder) async {
    final Directory dir = await getTemporaryDirectory();
    Directory root = Directory("${dir.path}/$folder");
    if (!(await root.exists())) {
      root.create();
    }
    return root;
  }
}