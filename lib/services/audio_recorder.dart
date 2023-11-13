
// import 'dart:io';

import 'package:flutter_sound/flutter_sound.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

class AudioRecorder {
  final FlutterSoundPlayer _audioPlayer = FlutterSoundPlayer();
  final FlutterSoundRecorder _audioRecorder = FlutterSoundRecorder();

  bool isRecording = false;


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

  Future<String> getFilePath() async {
      final appDir = await getApplicationDocumentsDirectory();
      // print('${appDir.path}');
      return '${appDir.path}/audio_file.mp3';

      // return '/home/johnc/Documents/app_dev/audio_file.mp3';


  }


  Future startRecording() async {
    final filePath = await getFilePath();
    // await _audioRecorder.openAudioSession();
    await _audioRecorder.startRecorder(
      toFile: filePath,
      codec: Codec.mp3,
    );
    isRecording = true;
  }

  Future stopRecording() async {
    await _audioRecorder.stopRecorder();
    // await _audioRecorder.closeAudioSession();
    isRecording = false;
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

  Stream<RecordingDisposition>? onProgress() {
    Stream<RecordingDisposition>?  onprogressTmp = _audioRecorder.onProgress;
    return onprogressTmp;
  }


  void setSubscriptionDuration(Duration duration) {
    _audioRecorder.setSubscriptionDuration(duration);
  }

}