import 'package:flutter/material.dart';
import 'package:mountain_other/pages/dictionary.dart';

class Home extends StatelessWidget {
  const Home({super.key});

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
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Wrap(
              spacing: 10,
              runSpacing: 10,
              alignment: WrapAlignment.center,
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => const Dictionary()),
                    );
                  },
                  child: _pageButton(context, Icons.add, "New"),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => const Dictionary()),
                    );
                  },
                  child: _pageButton(context, Icons.book, "Dictionary"),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => const Dictionary()),
                    );
                  },
                    child: _pageButton(context, Icons.edit, "Practice"),
                ),
              ],
            ),
            SizedBox(height: 20),
            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: [
                _statCard(context, "Total", "243", 0xFFFFC9AE, 0xFFFFEFE7, 0xFFFF9A68),
                _statCard(context, "Practice", "23", 0xFFFFC6F2, 0xFFFDEBF9, 0xFFFF8AE4),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

Widget _statCard(BuildContext context, String header, String number, int headerColor, int backgroundColor, int strokeColor) {
  return Container(
    width: 150,
    height: 100,
    decoration: BoxDecoration(
      color: Color(backgroundColor),
      borderRadius: BorderRadius.circular(15),
    ),
    child: Column(
      children: [
        Container(
          height: 30,
          width: double.infinity,
          decoration: BoxDecoration(
            color: Color(headerColor),
            borderRadius: BorderRadius.vertical(top: Radius.circular(15)),
            border: Border.all(color: Color(strokeColor), width: 3)
          ),
          alignment: Alignment.center,
          child: Text(header, style: TextStyle(color: Colors.white)),
        ),
        Expanded(
          child: Center(
            child: Text(
              '$number words',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ],
    ),
  );
}


Widget _pageButton(BuildContext context, IconData icon, String text) {
  return Container(
    width: 150,
    height: 150,
    decoration: BoxDecoration(
      color: Color(0xFF01A5CE),
      borderRadius: BorderRadius.circular(25),
    ),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(icon, size: 46, color: Colors.white),
        SizedBox(height: 10),
        Text(
          text,
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold,color: Colors.white),
        ),
      ],
    ),
  );
}


