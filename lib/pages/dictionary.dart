import 'package:flutter/material.dart';

final List<Map<String, dynamic>> wordsAndSentences = [
  {
    'word': 'Inexorably',
    'sentences': [
      'Time marches on inexorably, indifferent to the lives it touches.',
      'The glacier moved inexorably, carving out valleys over millennia.',
      'Despite their efforts, the team was inexorably drawn into the conflict.',
      'The inexorably rising tide threatened to engulf the small island.',
      'She felt inexorably pulled towards her destiny, unable to change her path.'
    ]
  },
  {
    'word': 'Absurdities',
    'sentences': [
      'The play was filled with absurdities that left the audience in stitches.',
      'He couldn’t believe the absurdities he encountered in the bureaucratic process.',
      'The novel’s plot was a series of absurdities that defied logic.',
      'They laughed at the absurdities of life, finding humor in the chaos.',
      'The absurdities of the situation made it difficult to take seriously.'
    ]
  },
  {
    'word': 'Convoluted',
    'sentences': [
      'The instructions were so convoluted that no one could follow them.',
      'Her explanation was convoluted, leaving everyone more confused than before.',
      'The plot of the movie was convoluted, with twists and turns that were hard to follow.',
      'He presented a convoluted argument that was difficult to understand.',
      'The convoluted design of the machine made it prone to breaking down.'
    ]
  },
  {
    'word': 'Turmoil',
    'sentences': [
      'The country was in turmoil after the sudden resignation of the president.',
      'Her mind was in turmoil as she tried to make a difficult decision.',
      'The financial markets were in turmoil following the unexpected announcement.',
      'The family faced emotional turmoil after the loss of their loved one.',
      'The city was in turmoil, with protests and unrest in the streets.'
    ]
  },
  {
    'word': 'Unreconciled',
    'sentences': [
      'The two friends remained unreconciled after their argument.',
      'He felt unreconciled with his past, unable to move forward.',
      'The unreconciled differences between the parties led to a stalemate.',
      'She was unreconciled with her decision, constantly second-guessing herself.',
      'The unreconciled accounts caused discrepancies in the financial report.'
    ]
  },
  {
    'word': 'Hinge',
    'sentences': [
      'The door creaked on its rusty hinge.',
      'The success of the project seemed to hinge on their ability to secure funding.',
      'His argument hinged on a single piece of evidence.',
      'The outcome of the game hinged on the final play.',
      'The entire plan hinged on perfect timing.'
    ]
  },
  {
    'word': 'Strand',
    'sentences': [
      'She found a single strand of hair on her sweater.',
      'The boat was stranded on the beach after the tide went out.',
      'He felt like a strand of seaweed, drifting aimlessly in the water.',
      'The story had multiple strands that eventually came together.',
      'She carefully wove each strand into the intricate design.'
    ]
  }
];

class Dictionary extends StatelessWidget {
  const Dictionary({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF044D64),
        centerTitle: true,
        iconTheme: IconThemeData(color: Colors.white),
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
                child: Text(
                  "Mountain",
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
              )
            ],
          ),
        ),
      ),
      endDrawer: Drawer(),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton(
              onPressed: () {
                // Add word functionality
              },
              child: Text('Add word'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF044D64),
                foregroundColor: Colors.white,
              ),
            ),
            ),
            Expanded(
              child: ListView.builder(
              itemCount: wordsAndSentences.length,
              itemBuilder: (context, index) {
                final wordData = wordsAndSentences[index];
                return Container(
                color: Color(0xFFFAFAFA), // Background color for the word row
                margin: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
                child: ExpansionTile(
                  title: InkWell(
                  onTap: () {
                    // Handle the click event to change the background color
                    // For example, you can show a snackbar or navigate to another page
                  },
                  child: Container(
                    decoration: BoxDecoration(
                    color: Color(0xFFFAFAFA), // Initial background color
                    border: Border.all(color: Color(0xFFE0E0E0)),
                    borderRadius: BorderRadius.circular(10) // Border color
                    ),
                    padding: const EdgeInsets.all(8.0),
                    child: Text(wordData['word']),
                  ),
                  ),
                  children: wordData['sentences'].asMap().entries.map<Widget>((entry) {
                  int idx = entry.key + 1;
                  String sentence = entry.value;
                  return Container(
                    margin: const EdgeInsets.all(10),
                    color: Color(0xFFFAFAFA), // Background color for the sentences section
                    child: ListTile(
                    leading: Text('$idx.'),
                    title: Text(sentence),
                    ),
                  );
                  }).toList(),
                ),
                );
              },
              ),
            ),
        ],
      ),
    );
  }
}
