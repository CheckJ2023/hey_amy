import 'package:flutter/material.dart';
import 'package:hey_amy/screen/feature_box.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';

import '../model/pallete.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
// _HomePageState ceateState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final SpeechToText _speechToText = SpeechToText();
  bool _speechEnabled = false;
  late final String _lastWords;

  @override
  void initState() {
    super.initState();
    _initSpeech();
  }

  ///This has to happen only once per app
  Future<void> _initSpeech() async {
    _speechEnabled = await _speechToText.initialize();
    setState(() {});
  }

  /// Each time to start a speech recognition session
  void _startListening() async {
    await _speechToText.listen(onResult: _onSpeechResult);
    setState(() {});
  }

  /// Manually stop the active speech recognition session
  /// Note that there are also timeouts that each platform enforces
  /// and the SpeechToText plugin supports setting timeouts on the
  /// listen method.
  void _stopListening() async {
    await _speechToText.stop();
    setState(() {});
  }

  /// This is the callback that the SpeechToText plugin calls when
  /// the platform returns recognized words.
  void _onSpeechResult(SpeechRecognitionResult result) {
    setState(() {
      _lastWords = result.recognizedWords;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Pallete.whiteColor,
        title: const Text(
          'Hey Amy',
          style: Pallete.appTitleStyle,
        ),
        centerTitle: true,
        elevation: 0.0,
        leading: const Icon(Icons.menu, color: Pallete.mainFontColor),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            //Assistant image
            Stack(
              children: [
                Center(
                    child: Container(
                  height: 120,
                  width: 120,
                  margin: const EdgeInsets.only(top: 4),
                  decoration: const BoxDecoration(
                      color: Pallete.assistantCircleColor,
                      shape: BoxShape.circle),
                )),
                Container(
                  height: 123,
                  decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      image: DecorationImage(
                        image: AssetImage(
                          '../assets/virtualAssistant.png',
                        ),
                      )),
                ),
              ],
            ),
            //Chat bubble
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 10,
              ),
              margin: const EdgeInsets.symmetric(horizontal: 40).copyWith(
                top: 30,
              ),
              decoration: BoxDecoration(
                border: Border.all(
                  color: Pallete.borderColor,
                ),
                borderRadius: BorderRadius.circular(20.0).copyWith(
                  topLeft: Radius.zero,
                ),
              ),
              child: const Padding(
                padding: EdgeInsets.symmetric(vertical: 10.0),
                child: Text(
                  'Good Morning, what task can I do for you?',
                  style: TextStyle(
                    color: Pallete.mainFontColor,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            Container(
              //top space
              padding: const EdgeInsets.all(10),
              alignment: Alignment.centerLeft,
              //left space
              margin: const EdgeInsets.only(top: 10, left: 22),
              child: const Text(
                'Here are a few features',
                style: TextStyle(
                  color: Pallete.mainFontColor,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            //Features list
            const Column(
              children: [
                FeatureBox(
                  color: Pallete.firstSuggestionBoxColor,
                  headerText: 'ChatGPT',
                  descriptionText:
                      'A smarter way to stay organized and informed with CharGPT.',
                ),
                FeatureBox(
                  color: Pallete.secondSuggestionBoxColor,
                  headerText: 'Dall-E',
                  descriptionText:
                      'Get inspired and stay creative with your personal assistant powered by Dall-E.',
                ),
                FeatureBox(
                  color: Pallete.thirdSuggestionBoxColor,
                  headerText: 'Smart Voice Assistant',
                  descriptionText:
                      'Get the best of both worlds with a voice assistant powered Dall-E and ChatGPT.',
                ),
              ],
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Pallete.firstSuggestionBoxColor,
        onPressed: () async {
          if (await _speechToText.hasPermission &&
              _speechToText.isNotListening) {
            _startListening();
          } else if (_speechToText.isListening) {
            _stopListening();
          // } else {
          //   _initSpeech();
          }
        },
        child: const Icon(
          Icons.mic,
          color: Pallete.blackColor,
        ),
      ),
    );
  }
}
