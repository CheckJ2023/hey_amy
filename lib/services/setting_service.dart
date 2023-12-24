import 'dart:async';
import 'dart:io';
import 'package:path_provider/path_provider.dart';

class SettingService {
  String _openAIAPIkey="";
  String get openAIAPIkey => _openAIAPIkey;

  //Create a reference to the file location
  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  //Write data to the file
  Future<File> get _localFile async {
    final path = await _localPath;
    return File('$path/openaiapikey.txt');
  }

  //Read data from the file
  Future<void> readAPIkey() async {
    try {
      final file = await _localFile;
      print('file = $_localFile');
      // Read the file
      _openAIAPIkey = await file.readAsString();
    } catch (e) {
      _openAIAPIkey = e.toString();
    }
  }

  //write data to file
  Future<File> writeAPIkey(String content) async {
    final file = await _localFile;
    // Write the file
    return file.writeAsString(content);
  }
}

