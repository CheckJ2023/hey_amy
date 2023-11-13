import 'package:flutter/material.dart';
import 'package:flutter_sound/public/flutter_sound_recorder.dart';
import '../services/audio_recorder.dart';


class Recorder extends StatefulWidget {
  const Recorder({super.key});

  @override
  State<Recorder> createState() => _RecorderState();
}

class _RecorderState extends State<Recorder> {
  final AudioRecorder _audioRecorder = AudioRecorder();

  @override
  void initState() {
    super.initState();
    _audioRecorder.initRecorder();

  }

  @override
  void dispose() {
    _audioRecorder.closeRecorder();
    super.dispose();
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            //What is StreamBuilder
            StreamBuilder<RecordingDisposition>(
                stream: _audioRecorder.onProgress(),
                builder: (context,snapshot) {
                  final duration=snapshot.hasData
                      ? snapshot.data!.duration
                      :Duration.zero;
                  String twoDigits(int n) => n.toString().padLeft(2,'0');
                  final twoDigitHours=
                      twoDigits(duration.inHours.remainder(24));
                  final twoDigitMinutes =
                      twoDigits(duration.inMinutes.remainder(60));
                  final twoDigitSeconds =
                      twoDigits(duration.inSeconds.remainder(60));

                  return Text(
                      '$twoDigitHours:$twoDigitMinutes:$twoDigitSeconds'
                       ,style: const TextStyle(
                          fontSize:50,
                          fontWeight: FontWeight.bold,
                        )
                  );
                }
            ),
            const SizedBox(height:10),
            SizedBox(
              width: 100,
              height: 100,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                    elevation: 0,
                    backgroundColor: _audioRecorder.isRecording ?
                    Colors.red : Colors.black,
                    shape: const CircleBorder(),
                    // padding: EdgeInsets.all(16),
                    // fixedSize: 30.0 ,
                ),
                // child: Text(audioRecorder.isRecording
                //     ? 'Stop Recording'
                //     : 'Start Recording'),
                onPressed: () async {
                  if (_audioRecorder.isRecording) {
                    await _audioRecorder.stopRecording();
                    // _audioRecorder.isRecording=false;
                  } else {
                    await _audioRecorder.startRecording();
                    // _audioRecorder.isRecording=true;
                  }
                  setState(() {});
                },
                child: Icon(
                  _audioRecorder.isRecording ?
                      Icons.stop : Icons.mic,
                  size:70,
                  color: Colors.white,
                ),

              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                elevation: 0,
                backgroundColor: Colors.black,
              ),
              onPressed: () async {
                final filePath = await _audioRecorder.getFilePath(); // Replace with your audio file path
                await _audioRecorder.playRecording(filePath);
              },
              child: const Text('Play Recording'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                elevation: 0,
                backgroundColor: Colors.black,
              ),
              onPressed: () async {
                await _audioRecorder.stopPlayback();
              },
              child: const Text('Stop Playback'),
            ),
          ],
        ),
      ),
    );
  }
}
