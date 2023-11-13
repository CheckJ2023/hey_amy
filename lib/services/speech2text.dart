import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:hey_amy/services/openaiservice.dart_bk';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';

import '../util/pallete.dart';

class Speech2text extends StatefulWidget {
  const Speech2text({super.key});

  @override
  State<Speech2text> createState() => _Speech2textState();
}

class _Speech2textState extends State<Speech2text> {
  final SpeechToText _speechToText = SpeechToText();
  bool _speechEnabled = false;
  String _lastWords="";
  final OpenAIService _openAIService=OpenAIService();
  final _flutterTts = FlutterTts();
  String? _generatedContent;
  String? _generatedImageUrl;

  @override
  void initState() {
    super.initState();

    _initSpeech();//speech to text initialization method
    _initTextToSpeech();//flutter tts initialization method
  }

  Future<void> _initTextToSpeech() async {
    //ios only: to set shared audio instance
    await _flutterTts.setSharedInstance(true);
    setState(() {});
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

  Future<void> _systemSpeak(String content) async {
    await _flutterTts.speak(content);
  }

  @override
  void dispose() {
    _speechToText.stop();
    _flutterTts.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        //remove the banner on the top right corner of screen

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
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 10.0),
                child: Text(
                  _generatedContent == null
                      ?'Good Morning, what task can I do for you?'
                      : _generatedContent!,
                  style: TextStyle(
                    color: Pallete.mainFontColor,
                    fontSize: _generatedContent == null ? 20: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
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
                  bottomRight: Radius.zero,
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 10.0),
                child: Text(
                  _lastWords.isNotEmpty//isNotEmpty or _speechToText.isListening seems like not work
                      ? _lastWords
                      : (_speechEnabled
                      ? 'Tap the microphone to start listening...'
                      : 'Speech not available'),
                  style: const TextStyle(
                    color: Pallete.mainFontColor,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            // Container(
            //   //top space
            //   padding: const EdgeInsets.all(10),
            //   alignment: Alignment.centerLeft,
            //   //left space
            //   margin: const EdgeInsets.only(top: 10, left: 22),
            //   child: const Text(
            //     'Here are a few features',
            //     style: TextStyle(
            //       color: Pallete.mainFontColor,
            //       fontSize: 20,
            //       fontWeight: FontWeight.bold,
            //     ),
            //   ),
            // ),
            // //Features list
            // const Column(
            //   children: [
            //     FeatureBox(
            //       color: Pallete.firstSuggestionBoxColor,
            //       headerText: 'ChatGPT',
            //       descriptionText:
            //           'A smarter way to stay organized and informed with CharGPT.',
            //     ),
            //     FeatureBox(
            //       color: Pallete.secondSuggestionBoxColor,
            //       headerText: 'Dall-E',
            //       descriptionText:
            //           'Get inspired and stay creative with your personal assistant powered by Dall-E.',
            //     ),
            //     FeatureBox(
            //       color: Pallete.thirdSuggestionBoxColor,
            //       headerText: 'Smart Voice Assistant',
            //       descriptionText:
            //           'Get the best of both worlds with a voice assistant powered Dall-E and ChatGPT.',
            //     ),
            //   ],
            // ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Pallete.firstSuggestionBoxColor,
        onPressed: () async {
          if (await _speechToText.hasPermission &&
              _speechToText.isNotListening) {
            // print('start listening');
            _startListening();
          } else if (_speechToText.isListening) {
            // print('stop listening');
            final speech = await _openAIService.isArtPromptAPI(_lastWords);
            if(speech.contains('https')){
              _generatedImageUrl = speech;
              _generatedContent = null;
              setState(() {});
            } else {
              _generatedImageUrl = null;
              _generatedContent = speech;
              setState(() {});
              await _systemSpeak(speech);
            }
            // print(speech);

            _stopListening();
            // } else {
            //   _initSpeech();
          }
        },
        child: Icon(
          _speechToText.isNotListening ? Icons.mic_off : Icons.mic,
          color: Pallete.blackColor,
        ),
      ),
    );
  }
}
