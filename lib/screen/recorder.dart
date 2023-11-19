import 'package:flutter/material.dart';
import 'package:hey_amy/services/audio_recorder.dart';


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
    setState(() {});
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            //StreamBuilder and valueListener is for UI Listening to
            //values change with async or sync way. The values change,
            // relevant UI change, too.
            _audioRecorder.onProgressWidget(),

            const SizedBox(height: 10),
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
                // use getter to obtaining value of file path from AudioRecorder class
                await _audioRecorder.playRecording(_audioRecorder.filePath);
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
