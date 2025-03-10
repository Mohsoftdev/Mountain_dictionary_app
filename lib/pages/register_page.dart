import 'package:flutter/material.dart';
import '../api_service.dart';
import 'dart:io';
import '../config.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  // Try both localhost and IP address
  final ApiService apiService = ApiService(baseUrl: Config.apiBaseUrl);
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isPasswordVisible = false;
  bool _isLoading = false;

  String _getHumanReadableError(String error) {
    print('Registration error: $error'); // Debug log
    
    if (error.toLowerCase().contains('connection refused') || 
        error.toLowerCase().contains('broken pipe') ||
        error.toLowerCase().contains('socketexception')) {
      return 'Unable to connect to the server. Please make sure:\n1. The server is running\n2. You are connected to the correct network\n3. The server address is correct';
    } else if (error.toLowerCase().contains('timeout')) {
      return 'Connection timed out. Please check your internet connection and try again.';
    } else if (error.toLowerCase().contains('network')) {
      return 'Network error. Please check your internet connection.';
    } else if (error.toLowerCase().contains('username is already taken')) {
      return 'This username is already taken. Please choose another.';
    } else if (error.toLowerCase().contains('email is already in use')) {
      return 'This email is already registered. Please use another email.';
    } else if (error.toLowerCase().contains('invalid email format')) {
      return 'Please enter a valid email address.';
    } else {
      return 'An error occurred: $error';
    }
  }

  Future<void> _register() async {
    // Validate inputs
    if (_usernameController.text.isEmpty || 
        _emailController.text.isEmpty || 
        _passwordController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please fill in all fields'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    // Basic email validation
    if (!_emailController.text.contains('@')) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please enter a valid email address'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    // Password length validation
    if (_passwordController.text.length < 8) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Password must be at least 8 characters long'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      print('Starting registration process...'); // Debug log
      print('Username: ${_usernameController.text}'); // Debug log
      print('Email: ${_emailController.text}'); // Debug log
      print('API Base URL: ${apiService.baseUrl}'); // Debug log
      
      final response = await apiService.post('api/user/register/', {
        'username': _usernameController.text,
        'email': _emailController.text,
        'password': _passwordController.text,
      }, requiresAuth: false);

      print('Registration response received: $response'); // Debug log

      if (response != null) {
        print('Registration successful, navigating to login...'); // Debug log
        // Show success message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Registration successful! Please login.'),
            backgroundColor: Colors.green,
          ),
        );
        // Navigate to login page
        Navigator.pushReplacementNamed(context, '/login');
      }
    } catch (e, stackTrace) {
      print('Registration error caught: $e'); // Debug log
      print('Stack trace: $stackTrace'); // Debug log
      String errorMessage = _getHumanReadableError(e.toString());
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            errorMessage,
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: Colors.red,
          duration: Duration(seconds: 6),
          action: SnackBarAction(
            label: 'Dismiss',
            textColor: Colors.white,
            onPressed: () {
              ScaffoldMessenger.of(context).hideCurrentSnackBar();
            },
          ),
        ),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Register'),
        backgroundColor: const Color(0xFF044D64),
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _usernameController,
              decoration: InputDecoration(
                labelText: 'Username',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.person),
              ),
              textInputAction: TextInputAction.next,
            ),
            SizedBox(height: 16),
            TextField(
              controller: _emailController,
              decoration: InputDecoration(
                labelText: 'Email',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.email),
              ),
              keyboardType: TextInputType.emailAddress,
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
              onSubmitted: (_) => _register(),
            ),
            SizedBox(height: 24),
            ElevatedButton(
              onPressed: _isLoading ? null : _register,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF044D64),
                foregroundColor: Colors.white,
                minimumSize: Size(double.infinity, 50),
              ),
              child: _isLoading
                  ? SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    )
                  : Text('Register'),
            ),
            SizedBox(height: 16),
            TextButton(
              onPressed: () {
                Navigator.pushReplacementNamed(context, '/login');
              },
              child: Text('Already have an account? Login'),
            ),
          ],
        ),
      ),
    );
  }
}