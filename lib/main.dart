// filepath: /C:/app_development/flutter/mountain_other/lib/main.dart
import 'package:flutter/material.dart';
import 'package:mountain_other/route_generator.dart';
import 'package:mountain_other/api_service.dart';
import 'package:mountain_other/widget_helper.dart';
import 'package:home_widget/home_widget.dart';
import 'package:mountain_other/config.dart';

void main() async {
  // Ensure Flutter is initialized
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize the home_widget package with default content
  await WidgetHelper.initializeWidget();
  
  // Register background callback for widget interactions
  HomeWidget.registerBackgroundCallback(backgroundCallback);
  
  // Run the app
  runApp(const MyApp());
  
  // Setup widget click listener
  setupWidgetClickListener();
}

// Called when the widget is interacted with from the background
Future<void> backgroundCallback(Uri? uri) async {
  if (uri != null) {
    print('Background callback received: ${uri.toString()}');
    await ApiService(baseUrl: Config.apiBaseUrl).updateWidget();
  }
}

// Handle widget clicks when the app is running
void setupWidgetClickListener() {
  HomeWidget.widgetClicked.listen((uri) async {
    print('Widget clicked: ${uri?.toString() ?? "null"}');
    
    // Refresh widget data when clicked
    try {
      await ApiService(baseUrl: Config.apiBaseUrl).updateWidget();
      print('Widget data refreshed after click');
    } catch (e) {
      print('Error refreshing widget after click: $e');
    }
  });
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Mountain Dictionary',
      initialRoute: '/',
      onGenerateRoute: RouteGenerator.generateRoute,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
    );
  }
}