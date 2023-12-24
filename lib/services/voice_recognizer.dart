import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:hey_amy/services/openai_service.dart';
import 'package:hey_amy/services/setting_service.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:flutter/foundation.dart';



class VoiceRecognizer {
  final SpeechToText _speechToText = SpeechToText();
  final OpenAIService _openAIService = OpenAIService();

  final ValueNotifier<bool> isListeningNotifier = ValueNotifier<bool>(false);
  final ValueNotifier<bool> isNotListeningNotifier = ValueNotifier<bool>(false);
  final ValueNotifier<bool> speechEnabledNotifier = ValueNotifier<bool>(false);
  final ValueNotifier<String> lastWordsNotifier = ValueNotifier<String>('');
  final ValueNotifier<String> assistantAnswerNotifier = ValueNotifier<String>('');

  final ValueNotifier<bool> gptIsLoadingNotifier = ValueNotifier<bool>(false);
  final SettingService _settingService = SettingService();

  final _flutterTts = FlutterTts();
  bool _speechEnabled = false;
  bool _startCheckLastWords=false;
  bool _sttIsRunning=false;
  bool _sttIsNotRunning=true;
  bool _chatgptEnabled = false;
  bool _transcripterEnabled = false;
  String _lastWordsBk = "";
  String _lastWords = "";
  String _assistantAnswer = "";

  void iniSpeechToText() {
    _initSpeech(); //speech to text initialization method
    _initTextToSpeech(); //flutter tts initialization method
    _settingService.readAPIkey();
    print('iniSpeechToText');
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
    print('_initSpeech');
    updateNotifier();
    // setState(() {}); //this is moved to initilaiation in transcripter.
  }

  /// Each time to start a speech recognition session
  void _startListening() async {
    await _speechToText.listen(onResult: _onSpeechResult);
    print('_startListening');
    updateNotifier();
    // setState(() {});
  }

  /// Manually stop the active speech recognition session
  /// Note that there are also timeouts that each platform enforces
  /// and the SpeechToText plugin supports setting timeouts on the
  /// listen method.
  void _stopListening() async {
    await _speechToText.stop();
    print('_stopListening');
    updateNotifier();
    // setState(() {});
  }

  /// This is the callback that the SpeechToText plugin calls when
  /// the platform returns recognized words.
  void _onSpeechResult(SpeechRecognitionResult result) {
    // setState(() {
    _lastWords = result.recognizedWords;
    lastWordsNotifier.value = _lastWords;

    print('_onSpeechResult');
    print(_lastWords);
    updateNotifier();
    ///android: directly send the result to tts or gpt.
    ///not for web (not work) or ios (ios haven't tested).
    if (_speechToText.isNotListening) {
      if(_transcripterEnabled) {
        _transcripterEnabled=false;
        _startCheckLastWords ?
        lastWordsCheck() : assistantRepeat();
      }
      if(_chatgptEnabled) {
        _chatgptEnabled=false;
        _startCheckLastWords ?
        lastWordsCheckForChatGPT() : assistantRepeat();
      }
    }

    // });
  }

  Future<void> _systemSpeak(String content) async {
    await _flutterTts.speak(content);
  }

  // Future<void> _stopSystemSpeak() async {
  //   await _flutterTts.pause();
  // }

  void stopSpeechToText() async{
   await  _speechToText.stop();
   await _flutterTts.stop();
  }

  void updateNotifier() {
    isListeningNotifier.value = _speechToText.isListening;
    isNotListeningNotifier.value = _speechToText.isNotListening;
    print('listening: ${_speechToText.isListening}');
    print('notlistening: ${_speechToText.isNotListening}');
  }


  void voiceRecognizing() async {
    _transcripterEnabled = true;
    if (await _speechToText.hasPermission &&
        _speechToText.isNotListening) {
      // _startTts? _stopSystemSpeak():_startTts=true; //not working
      _startListening();
    } else if (_speechToText.isListening) {
      _stopListening();
      _startCheckLastWords?
        await lastWordsCheck():await assistantRepeat();

    } else {
      _initSpeech();
    }
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
      _lastWordsBk=_lastWords;
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
    _chatgptEnabled = true;

    if (await _speechToText.hasPermission &&
        _speechToText.isNotListening) {
      _startListening();
    }
    if (_speechToText.isListening) {
      _startCheckLastWords?
      await lastWordsCheckForChatGPT():await assistantRepeat();
      _stopListening();
    } else {
      _initSpeech();
    }
  }

  Future<void> lastWordsCheckForChatGPT() async {
    _startCheckLastWords = false;
    switch (_lastWords) {
      case 'Yes':
      case 'yes':
      case 'Yes.':
      case 'yes.':
      case '是':
      case '是的' :
        gptIsLoadingNotifier.value = true;
        // _lastWordsBk='你好，我是約翰';
        //Note:convert utf16 string(flutter default type) to utf8 string
        //After some tests i found web version don't need to convert to utf8
        //but the gpt will response utf8 chinese characters that must
        //be converted before send it to the flutter tts.

        final String utf8StringPrompt=_stringConverterUTF16toUTF8(_lastWordsBk);
        print(utf8StringPrompt);
        print(_stringConverterUTF8toUTF16(utf8StringPrompt));

        //Note:chatgpt
        // String utf8StringResponse = await _openAIService.chatGPTAPI(utf8StringPrompt);
         String utf8StringResponse = await _openAIService.chatGPTAPI(
             _lastWordsBk,
             _settingService.openAIAPIkey
         );

         //Note:The ChatGPT response chinese with utf8 string that must be
         //converted before using it.
         _assistantAnswer=_stringConverterUTF8toUTF16(utf8StringResponse);
         //Note: Clean the _lastWordsBk
         _lastWordsBk='';
        gptIsLoadingNotifier.value = false;
      default:
        _assistantAnswer ="Please try again.";
    }
    assistantAnswerNotifier.value = _assistantAnswer;
    _systemSpeak(_assistantAnswer);

  }

  _stringConverterUTF16toUTF8(String utf16String){
    List<int> utf8Bytes = utf8.encode(utf16String);
    String utf8String = String.fromCharCodes(utf8Bytes);
    // print(utf8String);
    return utf8String;
  }

  _stringConverterUTF8toUTF16(String utf8String){
    List<int> utf8Bytes = utf8String.codeUnits;
    final utf16String = utf8.decode(utf8Bytes);
    // String utf16String = String.fromCharCodes(utf8.decode(utf8Bytes));
    // print(utf16String);
    return utf16String;
  }
}
