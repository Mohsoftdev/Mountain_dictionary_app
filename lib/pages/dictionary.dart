import 'package:flutter/material.dart';

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
      body: Center(
        child: Text('Dictionary'),
        
      ),
    );
  }
}