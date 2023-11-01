import 'dart:convert';

import 'package:hey_amy/model/api_util.dart';
import 'package:http/http.dart' as http;


class OpenAIService {

  late final String _openAIAPIkey ;
  //the list of messages is for gpt continue a conversation remembering what we talk to it before.
  final List<Map<String,String>> _messages = [];


  Future<String> isArtPromptAPI(String prompt) async {
    print('start isartpromptapi');
    try {
    //how to hide the API key? use environment variables or configuration files to store and retrieve your API key securely.
    //Note that variables below are automatically determined type by dart
    const endpoint = 'https://api.openai.com/v1/audio/translations';
    // _openAIAPIkey=ApiUtil().getAPIkey();
    _openAIAPIkey=api_key;
    // prompt="yes";
    print(_openAIAPIkey);
    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $_openAIAPIkey',
    };
    final messages = [
      {
        'role': 'user',
        'content': 'Does this message want to generate an AI picture, image, art or anything similar? $prompt. Simply answer with a yes or no.',
      }
    ];
    final data = {
      "model": "gpt-3.5-turbo",
      "messages": messages,
    };
    //   'prompt' : message,
    //   'max_tokens':50,// Adjust as needed
    // };

      final response = await http.post(
        Uri.parse(endpoint),
        headers: headers,
        body: json.encode(data),
      );
      print('yay');
      print(response.body);
      if (response.statusCode == 200) {
         print('yay2');
        String content = jsonDecode(response.body)['choices'][0]['message']['content'];
        content = content.trim();

        switch(content) {
          case 'Yes':
          case 'yes':
          case 'Yes.':
          case 'yes.':
            final response = await dallEAPI(prompt);
            return response;
          default:
            final response = await chatGPTAPI(prompt);
            return response;
        }
      }
      // return 'AI';
      return 'An internal error occurred';
    } catch (e) {
      return e.toString();
    }
  }

  Future<String> chatGPTAPI(String prompt) async {
    // return 'CHATGPT';
    //store whatever user said
    _messages.add({
      "role":"user",
      "content":prompt,
    });
    try {
      const endpoint = 'https://api.openai.com/v1/audio/translations';
      _openAIAPIkey=api_key;
      // prompt="yes";
      print(_openAIAPIkey);
      final headers = {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $_openAIAPIkey',
      };
      final data = {
        "model": "gpt-3.5-turbo",
        "messages": _messages,
      };
      //   'prompt' : message,
      //   'max_tokens':50,// Adjust as needed
      // };

      final response = await http.post(
        Uri.parse(endpoint),
        headers: headers,
        body: json.encode(data),
      );

      print(response.body);
      if (response.statusCode == 200) {
        String content = jsonDecode(response.body)['choices'][0]['message']['content'];
        content = content.trim();
        _messages.add({
          "role":"user",
          "content":content,
        });
        return content;
      }
      // return 'AI';
      return 'An internal error occurred';
    } catch (e) {
      return e.toString();
    }
  }

  Future<String> dallEAPI(String Prompt) async {
    return 'DALL-E';
  }
}
