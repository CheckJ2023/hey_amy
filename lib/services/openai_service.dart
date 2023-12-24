import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:hey_amy/model/api_util.dart';

class OpenAIService {

  //the list of messages is for gpt continue a conversation remembering what we talk to it before.
  final List<Map<String,String>> _messages = [];

  Future<String> chatGPTAPI(String prompt, String openAIAPIkey) async {
    // return 'CHATGPT';
    //store whatever user said
    _messages.add({
      "role":"user",
      "content":prompt,
    });
    try {
      const endpoint = 'https://api.openai.com/v1/chat/completions';
      final headers = {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $openAIAPIkey',
      };
      final data = {
        "model": "gpt-3.5-turbo",
        "messages": _messages,
      };

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
      return 'Error in ChatGPTAPI method';
    } catch (e) {
      return e.toString();
    }
  }
}
