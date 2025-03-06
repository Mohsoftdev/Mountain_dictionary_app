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
  final ApiService _apiService = ApiService(baseUrl: 'http://127.0.0.1:8000');
  List<String> _meanings = [];
  String? _selectedMeaning;
  bool _isLoading = false;
  bool _isAdding = false;
  Timer? _debounceTimer;

  @override
  void dispose() {
    _wordController.dispose();
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

  void _addWord() async {
    if (_wordController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a word'))
      );
      return;
    }

    if (_selectedMeaning == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a meaning'))
      );
      return;
    }

    setState(() {
      _isAdding = true;
    });

    // Show success dialog immediately
    _showSuccessDialog();

    try {
      await _apiService.post('/api/dictionary/', {
        'word': _wordController.text,
        'meaning': _selectedMeaning,
      });
    } catch (e) {
      if (mounted) {
        // If the API call fails, show error message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to add word: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isAdding = false;
        });
      }
    }
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        // Auto dismiss after 1.5 seconds
        Future.delayed(const Duration(milliseconds: 1500), () {
          if (mounted) {
            Navigator.of(context).pop(); // Close dialog
            Navigator.of(context).pop(); // Go back to previous screen
          }
        });

        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.lightGreen[50],
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.check_circle,
                  color: Colors.green,
                  size: 50,
                ),
                SizedBox(height: 20),
                Text(
                  'Word Added Successfully!',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.green[700],
                  ),
                ),
                SizedBox(height: 20),
                LinearProgressIndicator(
                  backgroundColor: Colors.green[100],
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.green),
                ),
              ],
            ),
          ),
        );
      },
    );
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