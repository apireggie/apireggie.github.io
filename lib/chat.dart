import 'dart:convert';
import 'package:http/http.dart' as http;

Future<String> getChatResponse(String prompt) async {
  const apiKey = 'sk-...'; // put your OpenAI API key here
  final url = Uri.parse('https://api.openai.com/v1/chat/completions');

  final response = await http.post(
    url,
    headers: {
      'Authorization': 'Bearer $apiKey',
      'Content-Type': 'application/json',
    },
    body: jsonEncode({
      'model': 'gpt-4', // or gpt-4o
      'messages': [
        {
          'role': 'system',
          'content': 'You are a helpful assistant from AppRegin.'
        },
        {'role': 'user', 'content': prompt}
      ],
      'temperature': 0.7,
    }),
  );

  if (response.statusCode == 200) {
    final body = jsonDecode(response.body);
    return body['choices'][0]['message']['content'];
  } else {
    throw Exception('Failed to get ChatGPT response: ${response.body}');
  }
}
