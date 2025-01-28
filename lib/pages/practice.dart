import 'package:flutter/material.dart';

class Practice extends StatelessWidget {
  const Practice({super.key});

  @override
  Widget build(BuildContext context) {
    var words = [
      'inexorably',
      'absurdities',
      'convoluted',
      'turmoil',
      'unreconciled',
      'hinge',
      'strand'
    ];
    var content = {
      "first sentence": {
        "before":
            'As the story progressed, the protagonist found themselves caught in a',
        "blank": 'first word',
        "after": 'of emotions, unable to escape the '
      },
      "second sentence": {
        "before": '',
        "blank": 'second word',
        "after": 'march of time. The plot, though'
      },
      "Third sentence": {
        "before": '',
        "blank": 'second word',
        "after": 'and difficult to follow, seemed to'
      },
      "fourth sentence": {
        "before": '',
        "blank": 'second word',
        "after": 'on a single'
      },
      "fifth sentence": {
        "before": 'second text before',
        "blank": 'second word',
        "after": 'of truth hidden within the chaos. Despite their efforts, the '
      },
      "sixth sentence": {
        "before": 'second text before',
        "blank": 'second word',
        "after": 'of the situation—bizarre and illogical—left them feeling'
      },
      "seventh sentence": {
        "before": '',
        "blank": 'second word',
        "after":
            ', torn between acceptance and resistance. The resolution, it seemed, was still far out of reach'
      }
    };
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Color(0xFF044D64),
          centerTitle: true,
          iconTheme: IconThemeData(color: Colors.white),
          title: Center(
            child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
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
            ]),
          ),
        ),
        endDrawer: Drawer(),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              LayoutBuilder(
                builder: (context, constraints) {
                  double widthFactor = constraints.maxWidth > 600 ? 0.3 : 0.7;
                  return Container(
                    width: MediaQuery.of(context).size.width * widthFactor,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Flexible(child: _levelButton('Easy')),
                        Flexible(child: _levelButton('Normal')),
                        Flexible(child: _levelButton('Hard'))
                      ],
                    ),
                  );
                },
              ),
              SizedBox(
                height: 20.0,
              ),
              Container(
                padding: const EdgeInsets.all(12.0),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.green),
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: Text(
                  words.join(' - '),
                  style: TextStyle(fontSize: 16),
                ),
              ),
              SizedBox(
                height: 20.0,
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  padding: const EdgeInsets.all(12.0),
                  decoration: BoxDecoration(
                    border: Border.all(color: Color(0xFF044D64)),
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  constraints: BoxConstraints(
                      maxWidth: MediaQuery.of(context).size.width * 1.0),
                  child: Wrap(
                    alignment: WrapAlignment.start,
                    runAlignment: WrapAlignment.start,
                    spacing: 8.0,
                    runSpacing: 8.0,
                    children: content.entries.map<Widget>((entry) {
                      return Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            '${entry.value['before']} ',
                            style: TextStyle(fontSize: 16),
                          ),
                          SizedBox(
                            width: 100,
                            child: TextField(),
                          ),
                          Text(
                            '${entry.value['after']}.',
                            style: TextStyle(fontSize: 16),
                          ),
                        ],
                      );
                    }).toList(),
                  ),
                ),
              ),
            ],
          ),
        ));
  }
}

Widget _levelButton(String level) {
  return Container(
    width: 100,
    height: 50,
    alignment: Alignment(0, 0),
    decoration: BoxDecoration(
      color: Color(0xFF01A5CE),
      borderRadius: BorderRadius.circular(10),
    ),
    child: Text(
      level,
      style: TextStyle(
          fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
    ),
  );
}
    // List<InlineSpan> paragraphSpans = content.entries.map((entry) {
    //   return TextSpan(
    //   children: [
    //     TextSpan(text: entry.value["before"]),
    //     WidgetSpan(
    //     child: TextField(
    //       decoration: InputDecoration(
    //         hintText: 'Enter text',
    //         border: OutlineInputBorder(),
    //       ),
    //     ),
    //     ),
    //     TextSpan(text: entry.value["after"]),
    //   ],
    //   );
    // }).toList();

    // Padding(
    //             padding: const EdgeInsets.all(16.0),
    //             child: Text(
    //               paragraphSpans.map((span) => span.toPlainText()).join(' '),
    //               style: TextStyle(fontSize: 16),
    //               textAlign: TextAlign.justify,
    //             ),
    //           ),

