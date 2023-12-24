
import 'dart:io';

import 'package:flutter_sound/flutter_sound.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';


class AudioRecorder {
  final FlutterSoundPlayer _audioPlayer = FlutterSoundPlayer();
  final FlutterSoundRecorder _audioRecorder = FlutterSoundRecorder();

  bool _isRecording = false;
  String _filePath="";
  bool get isRecording => _isRecording;
  String get filePath => _filePath;

  get onProgress => _audioRecorder.onProgress;

  Future initRecorder() async {
    final status = await Permission.microphone.request();
    if (status != PermissionStatus.granted) {
      throw 'Microphone permission not granted';
    }
    await _audioRecorder.openRecorder();
    _audioRecorder.setSubscriptionDuration(
      const Duration(milliseconds:500),
    );
  }

  // StreamBuilder<RecordingDisposition> onProgressWidget() {
  //   return StreamBuilder<RecordingDisposition>(
  //     stream: _audioRecorder.onProgress,
  //     builder: (context, snapshot) {
  //       final duration = snapshot.hasData ? snapshot.data!.duration : Duration.zero;
  //       String twoDigits(int n) => n.toString().padLeft(2, '0');
  //       final twoDigitHours = twoDigits(duration.inHours.remainder(24));
  //       final twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
  //       final twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
  //
  //       return Text(
  //         '$twoDigitHours:$twoDigitMinutes:$twoDigitSeconds',
  //         style: const TextStyle(
  //           fontSize: 50,
  //           fontWeight: FontWeight.bold,
  //         ),
  //       );
  //     },
  //   );
  // }

  Future<String> _getFilePath() async {
      final Directory appDir = await getApplicationDocumentsDirectory();
      print('file path is : ${appDir.path}');
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      print('file path is : ${appDir.path}/audio_file_$timestamp.mp3');
      return '${appDir.path}/audio_file_$timestamp.mp3';
      // return '/home/johnc/Documents/app_dev/audio_file.mp3';
  }

  Future startRecording() async {
    // _filePath = await _getFilePath();

    // await _audioRecorder.openAudioSession();
    await _audioRecorder.startRecorder(
        toFile: 'audio'
      // toFile: _filePath,
      // codec: Codec.mp3,
    );
    _isRecording = true;
  }

  Future stopRecording() async {
    final path = await _audioRecorder.stopRecorder();
    final audioFile = File(path!);
    // await _audioRecorder.closeAudioSession();
    _isRecording = false;
  }

  Future playRecording(String filePath) async {
    await _audioPlayer.startPlayer(
      fromURI: filePath,
      codec: Codec.mp3,
    );
  }

  Future stopPlayback() async {
    await _audioPlayer.stopPlayer();
  }

  Future closeRecorder() async {
     await _audioRecorder.closeRecorder();
  }

  Future openRecorder() async {
    await _audioRecorder.openRecorder();
  }

  // Stream<RecordingDisposition>? onProgress() {
  //   Stream<RecordingDisposition>?  onprogressTmp = _audioRecorder.onProgress;
  //   return onprogressTmp;
  // }


  void setSubscriptionDuration(Duration duration) {
    _audioRecorder.setSubscriptionDuration(duration);
  }

}


