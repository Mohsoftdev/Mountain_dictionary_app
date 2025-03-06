// Example usage in a login screen
import 'package:flutter/material.dart';
import 'package:mountain_other/api_service.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final ApiService _apiService = ApiService(baseUrl: 'http://127.0.0.1:8000');
  bool _isPasswordVisible = false;

  String _getHumanReadableError(String error) {
    if (error.toLowerCase().contains('invalid credentials')) {
      return 'Incorrect username/email or password. Please try again.';
    } else if (error.toLowerCase().contains('connection refused')) {
      return 'Unable to connect to the server. Please check your internet connection.';
    } else if (error.toLowerCase().contains('timeout')) {
      return 'Connection timed out. Please try again.';
    } else if (error.toLowerCase().contains('network')) {
      return 'Network error. Please check your internet connection.';
    } else {
      return 'An error occurred. Please try again later.';
    }
  }

  void _login() async {
    if (_usernameController.text.isEmpty || _passwordController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please enter both username/email and password'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    try {
      await _apiService.login(_usernameController.text, _passwordController.text);
      // Navigate to the next screen and clear the navigation stack
      Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
    } catch (e) {
      // Handle login error with human-readable message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            _getHumanReadableError(e.toString()),
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: Colors.red,
          duration: Duration(seconds: 4),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login'),
        backgroundColor: const Color(0xFF044D64),
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _usernameController,
              decoration: InputDecoration(
                labelText: 'Username or Email',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.person),
              ),
              textInputAction: TextInputAction.next,
            ),
            SizedBox(height: 16),
            TextField(
              controller: _passwordController,
              decoration: InputDecoration(
                labelText: 'Password',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.lock),
                suffixIcon: IconButton(
                  icon: Icon(
                    _isPasswordVisible ? Icons.visibility : Icons.visibility_off,
                  ),
                  onPressed: () {
                    setState(() {
                      _isPasswordVisible = !_isPasswordVisible;
                    });
                  },
                ),
              ),
              obscureText: !_isPasswordVisible,
              textInputAction: TextInputAction.done,
              onSubmitted: (_) => _login(),
            ),
            SizedBox(height: 24),
            ElevatedButton(
              onPressed: _login,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF044D64),
                foregroundColor: Colors.white,
                minimumSize: Size(double.infinity, 50),
              ),
              child: Text('Login'),
            ),
            SizedBox(height: 16),
            TextButton(
              onPressed: () {
                Navigator.pushNamed(context, '/register');
              },
              child: Text('Don\'t have an account? Register'),
            ),
          ],
        ),
      ),
    );
  }
}