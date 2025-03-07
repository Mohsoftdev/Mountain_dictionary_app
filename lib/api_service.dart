// filepath: /C:/app_development/flutter/mountain_other/lib/api_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ApiService {
  final String baseUrl;

  ApiService({required this.baseUrl});

  Future<dynamic> get(String endpoint) async {
    try {
      final token = await getToken();
      if (token == null) {
        throw Exception('No token available');
      }

      final response = await http.get(
        Uri.parse('$baseUrl/${endpoint.startsWith('/') ? endpoint.substring(1) : endpoint}'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else if (response.statusCode == 401) {
        // Token expired, try to refresh
        await refreshToken();
        // Retry the request with new token
        return get(endpoint);
      } else {
        throw Exception('Failed to load data');
      }
    } catch (e) {
      print('GET request error: $e');
      rethrow;
    }
  }

  Future<dynamic> post(String endpoint, Map<String, dynamic> data, {bool requiresAuth = true}) async {
    try {
      Map<String, String> headers = {
        'Content-Type': 'application/json',
      };

      if (requiresAuth) {
        final token = await getToken();
        if (token == null) {
          throw Exception('No token available');
        }
        headers['Authorization'] = 'Bearer $token';
      }

      final response = await http.post(
        Uri.parse('$baseUrl/${endpoint.startsWith('/') ? endpoint.substring(1) : endpoint}'),
        headers: headers,
        body: json.encode(data),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return json.decode(response.body);
      } else if (response.statusCode == 401 && requiresAuth) {
        // Token expired, try to refresh
        await refreshToken();
        // Retry the request with new token
        return post(endpoint, data, requiresAuth: requiresAuth);
      } else {
        final errorBody = json.decode(response.body);
        throw Exception(errorBody['detail'] ?? 'Failed to post data: ${response.body}');
      }
    } catch (e) {
      print('POST request error: $e');
      rethrow;
    }
  }

  Future<void> saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('jwt_token', token);
  }

  Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('jwt_token');
  }

  Future<void> saveRefreshToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('refresh_token', token);
  }

  Future<String?> getRefreshToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('refresh_token');
  }

  Future<void> removeToken() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('jwt_token');
    await prefs.remove('refresh_token');
  }

  Future<void> refreshToken() async {
    try {
      final refreshToken = await getRefreshToken();
      if (refreshToken == null) {
        throw Exception('No refresh token available');
      }

      final response = await http.post(
        Uri.parse('$baseUrl/api/token/refresh/'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'refresh': refreshToken,
        }),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        await saveToken(data['access']);
      } else {
        // If refresh fails, remove tokens and throw error
        await removeToken();
        throw Exception('Failed to refresh token');
      }
    } catch (e) {
      await removeToken();
      rethrow;
    }
  }

  Future<void> login(String usernameOrEmail, String password) async {
    try {
      print('Making login request with: $usernameOrEmail'); // Debug print
      
      final response = await http.post(
        Uri.parse('$baseUrl/api/token/'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'username_or_email': usernameOrEmail, // Allow username or email
          'password': password,
        }),
      );
      
      print('Response status: ${response.statusCode}'); // Debug print
      print('Response body: ${response.body}'); // Debug print

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = jsonDecode(response.body);
        if (data['access'] != null) {
          await saveToken(data['access']);
          await saveRefreshToken(data['refresh']);
          print('Token saved successfully'); // Debug print
        }
      } else {
        throw Exception('Login failed: ${response.body}');
      }
    } catch (e) {
      print('Login error: $e'); // Debug print
      throw Exception(e.toString());
    }
  }

  Future<List<Map<String, dynamic>>> fetchWords() async {
    final data = await get('/api/dictionary/');
    return List<Map<String, dynamic>>.from(data.map((item) => {
      'id': item['id'],
      'user': item['user'],
      'word': item['word']['word'],
      'meaning': item['word']['meaning'],
      'added_at': item['added_at'],
    }));
  }

  Future<Map<String, dynamic>> fetchWordMeaning(String word) async {
    final data = await get('/api/meaning/$word/');
    return Map<String, dynamic>.from(data);
  }

  Future<List<Map<String, dynamic>>> fetchExampleSentences(int wordId, int level) async {
    final data = await post('/api/example_sentences/', {'word_id': wordId, 'level': level});
    return List<Map<String, dynamic>>.from(data);
  }

  Future<List<String>> fetchWordNetMeanings(String word) async {
    final data = await get('/api/meaning/$word/');
    return List<String>.from(data['meanings']);
  }
}