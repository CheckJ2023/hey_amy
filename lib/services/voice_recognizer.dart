import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:hey_amy/services/openai_service.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:flutter/foundation.dart';



class VoiceRecognizer {
  final SpeechToText _speechToText = SpeechToText();
  final OpenAIService _openAIService = OpenAIService();
  final ValueNotifier<bool> isListeningNotifier = ValueNotifier<bool>(false);
  final ValueNotifier<bool> isNotListeningNotifier = ValueNotifier<bool>(false);
  // final ValueNotifier<bool> wordsConfirmedNotifier = ValueNotifier<bool>(false);
  final ValueNotifier<bool> speechEnabledNotifier = ValueNotifier<bool>(false);
  ValueNotifier<String> lastWordsNotifier = ValueNotifier<String>('');
  final ValueNotifier<String> assistantAnswerNotifier = ValueNotifier<String>(
      '');
  final _flutterTts = FlutterTts();
  bool _speechEnabled = false;
  bool _startCheckLastWords=false;
  bool _startTts=false;
  String _lastWords_bk = "";
  String _lastWords = "";
  String _assistantAnswer = "";

  // bool get isListening => _speechToText.isListening;
  // bool get isNotListening => _speechToText.isNotListening;
  // bool get speechEnabled => _speechEnabled;
  // String get lastWords => _lastWords;
  // String get assistantAnswer => _assistantAnswer;


  void iniSpeechToText() {
    _initSpeech(); //speech to text initialization method
    _initTextToSpeech(); //flutter tts initialization method
    // print('iniSpeechToText');
    // updateNotifier();
  }

  Future<void> _initTextToSpeech() async {
    //ios only: to set shared audio instance
    await _flutterTts.setSharedInstance(true);

    // setState(() {}); //this is moved to initilaiation in transcripter.
  }

  ///This has to happen only once per app
  Future<void> _initSpeech() async {
    _speechEnabled = await _speechToText.initialize();
    speechEnabledNotifier.value = _speechEnabled;
    // print('_initSpeech');
    updateNotifier();
    // setState(() {}); //this is moved to initilaiation in transcripter.
  }

  /// Each time to start a speech recognition session
  void _startListening() async {
    await _speechToText.listen(onResult: _onSpeechResult);
    // print('_startListening');
    updateNotifier();
    // setState(() {});
  }

  /// Manually stop the active speech recognition session
  /// Note that there are also timeouts that each platform enforces
  /// and the SpeechToText plugin supports setting timeouts on the
  /// listen method.
  void _stopListening() async {
    await _speechToText.stop();
    // print('_stopListening');
    updateNotifier();
    // setState(() {});
  }

  /// This is the callback that the SpeechToText plugin calls when
  /// the platform returns recognized words.
  void _onSpeechResult(SpeechRecognitionResult result) {
    // setState(() {
    _lastWords = result.recognizedWords;
    lastWordsNotifier.value = _lastWords;
    print(_lastWords);
    // print('_onSpeechResult');
    updateNotifier();
    // });
  }

  Future<void> _systemSpeak(String content) async {
    await _flutterTts.speak(content);
  }

  Future<void> _stopSystemSpeak() async {
    await _flutterTts.pause();
  }

  void stopSpeechToText() {
    _speechToText.stop();
    _flutterTts.stop();
  }

  void voiceRecognizing() async {

    if (await _speechToText.hasPermission &&
        _speechToText.isNotListening) {
      _startTts? _stopSystemSpeak():_startTts=true;
      _startListening();
    } else if (_speechToText.isListening) {
      _stopListening();
      _startCheckLastWords?
        await lastWordsCheck():await assistantRepeat();

    } else {
      _initSpeech();
    }
  }

  void updateNotifier() {
    isListeningNotifier.value = _speechToText.isListening;
    isNotListeningNotifier.value = _speechToText.isNotListening;
    // print('${_speechToText.isListening}');
    // print('${_speechToText.isNotListening}');
  }

  Future<void> assistantRepeat() async {
    if (_lastWords.isNotEmpty) {
      _assistantAnswer = "Did you say ? $_lastWords.";
      // _assistantAnswer = "你在說三小朋友";
    } else {
      _assistantAnswer = "Please talk.";
    }
    assistantAnswerNotifier.value = _assistantAnswer;
    _systemSpeak(_assistantAnswer);

    if (_lastWords.isNotEmpty) {
      _startCheckLastWords = true;
      _lastWords_bk=_lastWords;
      _lastWords = ''; //!!!Need to check if clean _lastWords is available
      //for restart the speech to text plugin
    }
  }

  Future<void> lastWordsCheck() async {
    _startCheckLastWords = false;
      switch (_lastWords) {
        case 'Yes':
        case 'yes':
        case 'Yes.':
        case 'yes.':
          _assistantAnswer ="OK";

        default:
          _assistantAnswer ="Please try again.";
    }
    assistantAnswerNotifier.value = _assistantAnswer;
    _systemSpeak(_assistantAnswer);
  }


  void voiceRecognizingForChatGPT() async {
    if (await _speechToText.hasPermission &&
        _speechToText.isNotListening) {
      _startListening();
    } else if (_speechToText.isListening) {
      _stopListening();
      _startCheckLastWords?
      await lastWordsCheckForChatGPT():await assistantRepeat();
    // } else {
    //   _initSpeech();
    }
  }
  Future<void> lastWordsCheckForChatGPT() async {
    _startCheckLastWords = false;
    switch (_lastWords) {
      case 'Yes':
      case 'yes':
      case 'Yes.':
      case 'yes.':
        _assistantAnswer = await _openAIService.chatGPTAPI(_lastWords_bk);
        _lastWords_bk='';
      default:
        _assistantAnswer ="Please try again.";
    }
    assistantAnswerNotifier.value = _assistantAnswer;
    _systemSpeak(_assistantAnswer);

  }
}
