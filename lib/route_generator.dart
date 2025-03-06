// filepath: /C:/app_development/flutter/mountain_other/lib/route_generator.dart
import 'package:flutter/material.dart';
import 'package:mountain_other/pages/home.dart';
import 'package:mountain_other/pages/login_page.dart';
import 'package:mountain_other/pages/register_page.dart';
import 'package:mountain_other/pages/dictionary.dart';
import 'package:mountain_other/pages/add_word.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/':
        return MaterialPageRoute(builder: (_) => const Home());
      case '/login':
        return MaterialPageRoute(builder: (_) => LoginPage());
      case '/register':
        return MaterialPageRoute(builder: (_) => const RegisterPage());
      case '/dictionary':
        return MaterialPageRoute(builder: (_) => const Dictionary());
      case '/add_word':
        return MaterialPageRoute(builder: (_) => const AddWordPage());
      default:
        return _errorRoute();
    }
  }

  static Route<dynamic> _errorRoute() {
    return MaterialPageRoute(builder: (_) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Error'),
        ),
        body: const Center(
          child: Text('ERROR: Route not found'),
        ),
      );
    });
  }
}