// filepath: /C:/app_development/flutter/mountain_other/lib/pages/add_word.dart
import 'dart:convert';
import 'package:flutter/material.dart';
import '../api_service.dart';
import 'dart:async';
import '../config.dart';

class AddWordPage extends StatefulWidget {
  const AddWordPage({super.key});

  @override
  _AddWordPageState createState() => _AddWordPageState();
}

class _AddWordPageState extends State<AddWordPage> {
  final TextEditingController _wordController = TextEditingController();
  final TextEditingController _meaningController = TextEditingController();
  final ApiService _apiService = ApiService(baseUrl: Config.apiBaseUrl);
  List<String> _meanings = [];
  String? _selectedMeaning;
  bool _isLoading = false;
  bool _isAdding = false;
  Timer? _debounceTimer;

  @override
  void dispose() {
    _wordController.dispose();
    _meaningController.dispose();
    _debounceTimer?.cancel();
    super.dispose();
  }

  void _fetchMeanings() async {
    if (_wordController.text.isEmpty) {
      setState(() {
        _meanings = [];
        _selectedMeaning = null;
      });
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final meanings = await _apiService.fetchWordNetMeanings(_wordController.text);
      setState(() {
        _meanings = meanings;
        _selectedMeaning = meanings.isNotEmpty ? meanings[0] : null;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to fetch meanings: $e'))
      );
    }
  }

  void _handleSearch() {
    if (_wordController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a word to search'))
      );
      return;
    }
    _fetchMeanings();
  }

  Future<void> _addWord() async {
    if (_wordController.text.trim().isEmpty || _meaningController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter both word and meaning'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    try {
      setState(() {
        _isAdding = true;
      });

      await _apiService.addWord(_wordController.text, _meaningController.text);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Word "${_wordController.text}" added successfully!',
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: Colors.green,
        ),
      );
      _wordController.clear();
      _meaningController.clear();
      setState(() {
        _selectedMeaning = null;
        _meanings = [];
      });

      await ApiService(baseUrl: Config.apiBaseUrl).updateWidget();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(_getErrorMessage(e.toString())),
          backgroundColor: Colors.red,
          duration: const Duration(seconds: 4),
        ),
      );
    } finally {
      setState(() {
        _isAdding = false;
      });
    }
  }

  String _getErrorMessage(String error) {
    if (error.contains('Word is already in your dictionary')) {
      return 'This word is already in your dictionary';
    } else if (error.contains('Invalid Word')) {
      return 'This word was not found in the dictionary';
    } else if (error.contains('Meaning does not match')) {
      return 'The meaning provided does not match the word';
    } else {
      return 'Failed to add word. Please try again.';
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
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _wordController,
              decoration: InputDecoration(
                labelText: 'Word',
                border: OutlineInputBorder(),
                suffixIcon: IconButton(
                  icon: Icon(Icons.search),
                  onPressed: _handleSearch,
                ),
              ),
              textInputAction: TextInputAction.search,
              onSubmitted: (_) => _handleSearch(),
            ),
            const SizedBox(height: 20),
            if (_isLoading)
              const Center(child: CircularProgressIndicator())
            else if (_meanings.isNotEmpty)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: _selectedMeaning,
                    isExpanded: true,
                    onChanged: (value) {
                      setState(() {
                        _selectedMeaning = value;
                        _meaningController.text = value ?? '';
                      });
                    },
                    items: _meanings.map((meaning) {
                      return DropdownMenuItem<String>(
                        value: meaning,
                        child: Text(meaning),
                      );
                    }).toList(),
                  ),
                ),
              ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _isAdding ? null : _addWord,
              child: _isAdding
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Text('Add Word'),
            ),
          ],
        ),
      ),
    );
  }
}