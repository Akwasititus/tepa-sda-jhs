import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:http/http.dart' as http;
import 'dart:convert';


class SpeechToAIPage extends StatefulWidget {
  @override
  _SpeechToAIPageState createState() => _SpeechToAIPageState();
}

class _SpeechToAIPageState extends State<SpeechToAIPage> {
  late stt.SpeechToText _speech;
  bool _isListening = false;
  String _spokenText = "Press the mic button and start speaking...";
  String _aiResponse = "AI's response will appear here.";
  final String _cohereApiKey = '4AfedG0FzDnfqTYODZPoxpqn3TlMijUbHNveG81J'; // Replace with your API key

  @override
  void initState() {
    super.initState();
    _speech = stt.SpeechToText();
  }

  Future<void> _listen() async {
    bool available = await _speech.initialize();
    if (available) {
      setState(() => _isListening = true);
      _speech.listen(onResult: (result) {
        setState(() {
          _spokenText = result.recognizedWords;
        });
      });
    }
  }

  void _stopListening() {
    _speech.stop();
    setState(() => _isListening = false);
  }

  Future<void> _getAIResponse(String question) async {
    const url = "https://api.cohere.ai/generate";
    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $_cohereApiKey',
    };
    final body = jsonEncode({
      "model": "command-xlarge-nightly", // Cohere's general-purpose language model
      "prompt": question,
      "max_tokens": 150,
      "temperature": 0.7,
    });

    try {
      final response = await http.post(Uri.parse(url), headers: headers, body: body);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          _aiResponse = data['text'].trim();
          print("*******************");
          print(_aiResponse);
          print("*******************");
        });
      } else {
        setState(() {
          _aiResponse = "Failed to fetch response from AI. Status: ${response.statusCode}";
        });
      }
    } catch (e) {
      setState(() {
        _aiResponse = "Error: $e";
        print(e);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Speech to AI'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text(
              "Your Speech:",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                _spokenText,
                style: TextStyle(fontSize: 16),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: _isListening ? _stopListening : _listen,
              icon: Icon(_isListening ? Icons.mic_off : Icons.mic),
              label: Text(_isListening ? "Stop Listening" : "Start Listening"),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => _getAIResponse(_spokenText),
              child: Text("Get AI Response"),
            ),
            SizedBox(height: 20),
            Text(
              "AI's Response:",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                _aiResponse,
                style: TextStyle(fontSize: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
