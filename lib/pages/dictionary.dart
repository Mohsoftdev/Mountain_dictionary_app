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

  @override
  void initState() {
    super.initState();
    _wordsAndSentences = _fetchWordsAndSentences();
  }

  Future<List<Map<String, dynamic>>> _fetchWordsAndSentences() async {
    final ApiService apiService = ApiService(baseUrl: 'http://172.20.10.3:8000/');
    return await apiService.fetchWords();
  }

  Future<List<Map<String, dynamic>>> _fetchExampleSentences(int wordId, int level) async {
    final ApiService apiService = ApiService(baseUrl: 'http://172.20.10.3:8000/');
    return await apiService.fetchExampleSentences(wordId, level);
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
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _wordsAndSentences,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No words found'));
          } else {
            final wordsAndSentences = snapshot.data!;
            return ListView.builder(
              itemCount: wordsAndSentences.length,
              itemBuilder: (context, index) {
                final wordData = wordsAndSentences[index];
                return Container(
                  color: const Color(0xFFFAFAFA), // Background color for the word row
                  margin: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
                  child: ExpansionTile(
                    title: InkWell(
                      onTap: () {
                        // Handle the click event to change the background color
                        // For example, you can show a snackbar or navigate to another page
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: const Color(0xFFFAFAFA), // Initial background color
                          border: Border.all(color: const Color(0xFFE0E0E0)),
                          borderRadius: BorderRadius.circular(10), // Border color
                        ),
                        padding: const EdgeInsets.all(8.0),
                        child: Text(wordData['word']),
                      ),
                    ),
                    children: [
                      Container(
                        margin: const EdgeInsets.all(10),
                        color: const Color(0xFFFAFAFA), // Background color for the sentences section
                        child: ListTile(
                          leading: Text('Meaning:'),
                          title: Text(wordData['meaning']),
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.all(10),
                        color: const Color(0xFFFAFAFA), // Background color for the sentences section
                        child: ListTile(
                          leading: Text('Added at:'),
                          title: Text(wordData['added_at']),
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
                      FutureBuilder<List<Map<String, dynamic>>>(
                        future: _fetchExampleSentences(wordData['id'], _selectedLevel),
                        builder: (context, exampleSnapshot) {
                          if (exampleSnapshot.connectionState == ConnectionState.waiting) {
                            return const Center(child: CircularProgressIndicator());
                          } else if (exampleSnapshot.hasError) {
                            return Center(child: Text('Error: ${exampleSnapshot.error}'));
                          } else if (!exampleSnapshot.hasData || exampleSnapshot.data!.isEmpty) {
                            return const Center(child: Text('No example sentences found'));
                          } else {
                            final exampleSentences = exampleSnapshot.data!;
                            return Column(
                              children: exampleSentences.map<Widget>((entry) {
                                return Container(
                                  margin: const EdgeInsets.all(10),
                                  color: const Color(0xFFFAFAFA), // Background color for the sentences section
                                  child: ListTile(
                                    leading: Text('${entry['id']}.'), // Ensure 'id' is present in the response
                                    title: Text(entry['sentence']),
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
    );
  }
}