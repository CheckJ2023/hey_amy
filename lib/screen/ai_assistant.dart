import 'package:flutter/material.dart';
import 'package:hey_amy/screen/loading_animation.dart';

import 'package:hey_amy/model/pallete.dart';
import 'package:hey_amy/services/voice_recognizer.dart';


class AIAssistant extends StatefulWidget {
  const AIAssistant({super.key});

  @override
  State<AIAssistant> createState() => _AIAssistantState();
}

class _AIAssistantState extends State<AIAssistant> {
  final VoiceRecognizer _voiceRecognizer = VoiceRecognizer();
  final LoadingAnimation _loadingAnimation = const LoadingAnimation();
  bool _isMicButtonPressed = false;

  @override
  void initState() {
    super.initState();
    _voiceRecognizer.iniSpeechToText();
    print('initialization');
    setState(() {});
  }

  @override
  void dispose() {
    _voiceRecognizer.stopSpeechToText();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                          'assets/virtualAssistant.png',
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
                child: ValueListenableBuilder<bool>(
                  valueListenable: _voiceRecognizer.gptIsLoadingNotifier,
                  builder: (context, gptIsLoading, child) {
                    return gptIsLoading
                        ? _loadingAnimation
                        : ValueListenableBuilder<String>(
                            valueListenable:
                                _voiceRecognizer.assistantAnswerNotifier,
                            builder: (context, assistantAnswer, child) {
                              return Text(
                                assistantAnswer.isEmpty
                                    ? '...'
                                    : assistantAnswer,
                                style: TextStyle(
                                  color: Pallete.mainFontColor,
                                  fontSize: assistantAnswer.isEmpty ? 20 : 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              );
                            },
                          );
                  },
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
                child: ValueListenableBuilder<String>(
                  valueListenable: _voiceRecognizer.lastWordsNotifier,
                  builder: (context, lastWords, child) {
                    return ValueListenableBuilder<bool>(
                      valueListenable: _voiceRecognizer.speechEnabledNotifier,
                      builder: (context, speechEnabled, child) {
                        return Text(
                          lastWords
                                  .isNotEmpty //isNotEmpty or _speechToText.isListening seems like not work
                              ? lastWords
                              : (speechEnabled
                                  ? '...'
                                  : 'Speech not available'),
                          style: const TextStyle(
                            color: Pallete.mainFontColor,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        // backgroundColor: isListening
        //     ? Colors.red[200]
        //     : Pallete.firstSuggestionBoxColor,
        backgroundColor: Pallete.firstSuggestionBoxColor,
        onPressed: () {

          _isMicButtonPressed
              ? _isMicButtonPressed = false
              : _isMicButtonPressed = true;
          _voiceRecognizer.voiceRecognizingForChatGPT();
          setState(() {});
          print('FloatingActionButton');
          _voiceRecognizer.updateNotifier();
        },
        child: ValueListenableBuilder<bool>(
            valueListenable: _voiceRecognizer.isListeningNotifier,
            builder: (context, isListening, child) {
              return Icon(
                _isMicButtonPressed && isListening ? Icons.mic : Icons.mic_off,
                color: Pallete.blackColor,
              );
            }),
      ),
    );
  }
}
