// filepath: /C:/app_development/flutter/mountain_other/lib/pages/add_word.dart
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:mountain_other/api_service.dart';

class AddWordPage extends StatefulWidget {
  const AddWordPage({super.key});

  @override
  _AddWordPageState createState() => _AddWordPageState();
}

class _AddWordPageState extends State<AddWordPage> {
  final TextEditingController _wordController = TextEditingController();
  final ApiService _apiService = ApiService(baseUrl: 'http://172.20.10.3:8000/');
  List<String> _meanings = [];
  String? _selectedMeaning;

  void _fetchMeanings() async {
    try {
      final meanings = await _apiService.fetchWordNetMeanings(_wordController.text);
      setState(() {
        _meanings = meanings;
        _selectedMeaning = meanings.isNotEmpty ? meanings[0] : null;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to fetch meanings: $e')));
    }
  }

  void _addWord() async {
    try {
      await _apiService.post('/api/dictionary/', {
        'word': _wordController.text,
        'meaning': _selectedMeaning,
      });
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Word added successfully')));
      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to add word: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add New Word'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _wordController,
              decoration: const InputDecoration(labelText: 'Word'),
              onChanged: (value) {
                if (value.isNotEmpty) {
                  _fetchMeanings();
                }
              },
            ),
            const SizedBox(height: 20),
            if (_meanings.isNotEmpty)
              DropdownButton<String>(
                value: _selectedMeaning,
                onChanged: (value) {
                  setState(() {
                    _selectedMeaning = value;
                  });
                },
                items: _meanings.map((meaning) {
                  return DropdownMenuItem<String>(
                    value: meaning,
                    child: Text(meaning),
                  );
                }).toList(),
              ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _addWord,
              child: const Text('Add Word'),
            ),
          ],
        ),
      ),
    );
  }
}