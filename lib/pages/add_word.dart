// filepath: /C:/app_development/flutter/mountain_other/lib/pages/add_word.dart
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:mountain_other/api_service.dart';
import 'dart:async';

class AddWordPage extends StatefulWidget {
  const AddWordPage({super.key});

  @override
  _AddWordPageState createState() => _AddWordPageState();
}

class _AddWordPageState extends State<AddWordPage> {
  final TextEditingController _wordController = TextEditingController();
  final TextEditingController _meaningController = TextEditingController();
  final ApiService _apiService = ApiService(baseUrl: 'http://127.0.0.1:8000');
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

  void _onWordChanged(String value) {
    // Remove automatic search
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
    if (_wordController.text.isEmpty || _meaningController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter both word and meaning'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      print('Attempting to add word: ${_wordController.text}'); // Debug print
      print('With meaning: ${_meaningController.text}'); // Debug print

      final response = await _apiService.post('/api/dictionary/', {
        'word': _wordController.text.trim(),
        'meaning': _meaningController.text.trim(),
      });

      print('Add word response: $response'); // Debug print

      if (mounted) {
        // Show success dialog
        await showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Success'),
            content: const Text('Word added successfully!'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('OK'),
              ),
            ],
          ),
        );

        // Clear the form
        _wordController.clear();
        _meaningController.clear();
        setState(() {
          _selectedMeaning = null;
          _meanings = [];
        });

        // Return true to indicate success and update word count
        Navigator.pop(context, true);
      }
    } catch (e) {
      print('Error adding word: $e'); // Debug print
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(_getErrorMessage(e.toString())),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 4),
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
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
              onChanged: _onWordChanged,
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