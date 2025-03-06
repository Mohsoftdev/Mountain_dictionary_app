// filepath: /C:/app_development/flutter/mountain_other/lib/pages/dictionary.dart
import 'package:flutter/material.dart';
import 'package:mountain_other/api_service.dart';

class Dictionary extends StatefulWidget {
  const Dictionary({super.key});

  @override
  _DictionaryState createState() => _DictionaryState();
}

class _DictionaryState extends State<Dictionary> {
  late Future<List<Map<String, dynamic>>> _wordsAndSentences;
  int _selectedLevel = 5;
  final ApiService _apiService = ApiService(baseUrl: 'http://127.0.0.1:8000');

  @override
  void initState() {
    super.initState();
    _wordsAndSentences = _fetchWordsAndSentences();
  }

  Future<List<Map<String, dynamic>>> _fetchWordsAndSentences() async {
    try {
      return await _apiService.fetchWords();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to load words: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
      return [];
    }
  }

  Future<List<Map<String, dynamic>>> _fetchExampleSentences(int wordId, int level) async {
    try {
      return await _apiService.fetchExampleSentences(wordId, level);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to load example sentences: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
      return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF044D64),
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white),
        title: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                "assets/logo_mark_white.png",
                fit: BoxFit.contain,
                height: 28,
              ),
              Container(
                margin: const EdgeInsets.all(10.0),
                child: const Text(
                  "Mountain",
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
              )
            ],
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              Navigator.pushNamed(context, '/add_word');
            },
          ),
        ],
      ),
      endDrawer: const Drawer(),
      body: RefreshIndicator(
        onRefresh: () async {
          setState(() {
            _wordsAndSentences = _fetchWordsAndSentences();
          });
        },
        child: FutureBuilder<List<Map<String, dynamic>>>(
          future: _wordsAndSentences,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.error_outline, size: 48, color: Colors.red),
                    const SizedBox(height: 16),
                    Text(
                      'Error: ${snapshot.error}',
                      style: const TextStyle(color: Colors.red),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          _wordsAndSentences = _fetchWordsAndSentences();
                        });
                      },
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              );
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.library_books, size: 48, color: Colors.grey),
                    const SizedBox(height: 16),
                    const Text(
                      'No words found',
                      style: TextStyle(fontSize: 18),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Add your first word by tapping the + button',
                      style: TextStyle(color: Colors.grey),
                    ),
                  ],
                ),
              );
            } else {
              final wordsAndSentences = snapshot.data!;
              return ListView.builder(
                itemCount: wordsAndSentences.length,
                itemBuilder: (context, index) {
                  final wordData = wordsAndSentences[index];
                  return Container(
                    color: const Color(0xFFFAFAFA),
                    margin: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
                    child: ExpansionTile(
                      title: InkWell(
                        onTap: () {
                          // Handle the click event to change the background color
                          // For example, you can show a snackbar or navigate to another page
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            color: const Color(0xFFFAFAFA),
                            border: Border.all(color: const Color(0xFFE0E0E0)),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            wordData['word'],
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      children: [
                        Container(
                          margin: const EdgeInsets.all(10),
                          color: const Color(0xFFFAFAFA),
                          child: ListTile(
                            leading: const Icon(Icons.description, color: Colors.blue),
                            title: Text(wordData['meaning']),
                          ),
                        ),                        
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Sentences Difficulty Level',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Slider(
                                value: _selectedLevel.toDouble(),
                                min: 1,
                                max: 10,
                                divisions: 9,
                                label: _selectedLevel.toString(),
                                onChanged: (double value) {
                                  setState(() {
                                    _selectedLevel = value.toInt();
                                  });
                                },
                              ),
                            ],
                          ),
                        ),
                        FutureBuilder<List<Map<String, dynamic>>>(
                          future: _fetchExampleSentences(wordData['id'], _selectedLevel),
                          builder: (context, exampleSnapshot) {
                            if (exampleSnapshot.connectionState == ConnectionState.waiting) {
                              return const Center(child: CircularProgressIndicator());
                            } else if (exampleSnapshot.hasError) {
                              return Center(
                                child: Padding(
                                  padding: const EdgeInsets.all(16.0),
                                  child: Text(
                                    'Error loading examples: ${exampleSnapshot.error}',
                                    style: const TextStyle(color: Colors.red),
                                  ),
                                ),
                              );
                            } else if (!exampleSnapshot.hasData || exampleSnapshot.data!.isEmpty) {
                              return const Center(
                                child: Padding(
                                  padding: EdgeInsets.all(16.0),
                                  child: Text('No example sentences found'),
                                ),
                              );
                            } else {
                              final exampleSentences = exampleSnapshot.data!;
                              return Column(
                                children: exampleSentences.map<Widget>((entry) {
                                  final sentence = entry['sentence'];
                                  final word = wordData['word'];
                                  final wordIndex = sentence.toLowerCase().indexOf(word.toLowerCase());
                                  
                                  return Container(
                                    margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                    child: Row(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        const Text(
                                          '• ',
                                          style: TextStyle(
                                            fontSize: 16,
                                            color: Colors.grey,
                                          ),
                                        ),
                                        Expanded(
                                          child: RichText(
                                            text: TextSpan(
                                              style: const TextStyle(
                                                fontSize: 16,
                                                color: Colors.black,
                                              ),
                                              children: [
                                                TextSpan(
                                                  text: sentence.substring(0, wordIndex),
                                                ),
                                                TextSpan(
                                                  text: sentence.substring(wordIndex, wordIndex + word.length),
                                                  style: const TextStyle(
                                                    color: Colors.blue,
                                                    decoration: TextDecoration.underline,
                                                  ),
                                                ),
                                                TextSpan(
                                                  text: sentence.substring(wordIndex + word.length),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                }).toList(),
                              );
                            }
                          },
                        ),
                      ],
                    ),
                  );
                },
              );
            }
          },
        ),
      ),
    );
  }
}