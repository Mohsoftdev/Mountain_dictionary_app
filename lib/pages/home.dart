import 'package:flutter/material.dart';
import 'package:mountain_other/pages/add_word.dart';
import 'package:mountain_other/pages/dictionary.dart';
import 'package:mountain_other/pages/practice.dart';
import 'package:mountain_other/pages/login_page.dart';
import 'package:mountain_other/pages/register_page.dart';
import 'package:mountain_other/api_service.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  bool isLoggedIn = false;

  @override
  void initState() {
    super.initState();
    _checkLoginStatus();
  }

  Future<void> _checkLoginStatus() async {
    final ApiService apiService = ApiService(baseUrl: 'http://127.0.0.1:8000/');
    final token = await apiService.getToken();
    setState(() {
      isLoggedIn = token != null;
    });
  }

  Future<void> _checkTokenAndNavigate(BuildContext context, Widget page) async {
    final ApiService apiService = ApiService(baseUrl: 'http://127.0.0.1:8000/');
    final token = await apiService.getToken();

    if (token == null) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) =>  LoginPage()),
      );
    } else {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => page),
      );
    }
  }

  Future<void> _logout(BuildContext context) async {
    final ApiService apiService = ApiService(baseUrl: 'http://127.0.0.1:8000/');
    await apiService.removeToken();
    setState(() {
      isLoggedIn = false;
    });
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) =>  LoginPage()),
    );
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
          isLoggedIn
              ? Builder(
                  builder: (context) => IconButton(
                    icon: const Icon(Icons.menu),
                    onPressed: () {
                      Scaffold.of(context).openEndDrawer();
                    },
                  ),
                )
              : Row(
                  children: [
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>  LoginPage()),
                        );
                      },
                      child: const Text(
                        'Login',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const RegisterPage()),
                        );
                      },
                      child: const Text(
                        'Register',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ],
                ),
        ],
      ),
      endDrawer: Drawer(
        backgroundColor: const Color(0xFF044D64),
        child: SingleChildScrollView(
          // Background color for the whole sidebar
          child: Column(
            crossAxisAlignment:
                CrossAxisAlignment.start, // Align content to the center
            children: [
              ListTile(
                title: const Text('Mountain',
                    style: TextStyle(color: Colors.white)),
              ),
              
              ListTile(
                leading: const Icon(Icons.home, color: Colors.white,),
                title:
                    const Text('Home', style: TextStyle(color: Colors.white)),
              ),
              ListTile(
                leading: const Icon(Icons.summarize_outlined, color: Colors.white,),
                title:
                    const Text('Summary', style: TextStyle(color: Colors.white)),
              ),
              Divider(),
              ListTile(
                leading: const Icon(Icons.logout, color: Colors.white,),
                title: isLoggedIn
                    ? TextButton(
                      
                        onPressed: () => _logout(context),
                        child: const Text(
                          'Logout',
                          style: TextStyle(color: Colors.white),
                        ),
                      )
                    : Column(
                        children: [
                          TextButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>  LoginPage()),
                              );
                            },
                            child: const Text(
                              'Login',
                              style: TextStyle(color: Colors.black),
                            ),
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const RegisterPage()),
                              );
                            },
                            child: const Text(
                              'Register',
                              style: TextStyle(color: Colors.black),
                            ),
                          ),
                        ],
                      ),
              ),
            ],
          ),
        ),
      ),
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
                  onTap: () =>
                      _checkTokenAndNavigate(context, const AddWordPage()),
                  child: _pageButton(context, Icons.add, "New"),
                ),
                GestureDetector(
                  onTap: () =>
                      _checkTokenAndNavigate(context, const Dictionary()),
                  child: _pageButton(context, Icons.book, "Dictionary"),
                ),
                GestureDetector(
                  onTap: () =>
                      _checkTokenAndNavigate(context, const Practice()),
                  child: _pageButton(context, Icons.edit, "Practice"),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: [
                _statCard(context, "Total", "243", 0xFFFFC9AE, 0xFFFFEFE7,
                    0xFFFF9A68),
                _statCard(context, "Practice", "23", 0xFFFFC6F2, 0xFFFDEBF9,
                    0xFFFF8AE4),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class TextIconButton {}

Widget _statCard(BuildContext context, String header, String number,
    int headerColor, int backgroundColor, int strokeColor) {
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
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(15)),
              border: Border.all(color: Color(strokeColor), width: 3)),
          alignment: Alignment.center,
          child: Text(header, style: const TextStyle(color: Colors.white)),
        ),
        Expanded(
          child: Center(
            child: Text(
              '$number words',
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
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
      color: const Color(0xFF01A5CE),
      borderRadius: BorderRadius.circular(25),
    ),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(icon, size: 46, color: Colors.white),
        const SizedBox(height: 10),
        Text(
          text,
          style: const TextStyle(
              fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
        ),
      ],
    ),
  );
}
