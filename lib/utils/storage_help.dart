import 'dart:io';
import 'dart:typed_data';

import 'package:offline_webview/utils/clipboard.dart';
import 'package:path_provider/path_provider.dart';

final storageHelper = StorageHelper();

class StorageHelper {
  Future<String> get localPath async {
    final dic = await getApplicationDocumentsDirectory();
    return dic.path;
  }

  Future<File> getLocalFile(String fileName) async {
    final path = await localPath;
    return File("$path/$fileName");
  }

  Future<File> writeTextToFile(String fileName, String text) async {
    final file = await getLocalFile(fileName);
    await clipboard.copy(text);
    return await file.writeAsString(text);
  }

  Future<File> writeBytesToFile(String fileName, Uint8List data) async {
    final file = await getLocalFile(fileName);
    return await file.writeAsBytes(data);
  }

  Future<String> readFromFile(String fileName) async {
    final file = await getLocalFile(fileName);
    return await file.readAsString();
  }
}