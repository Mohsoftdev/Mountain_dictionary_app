import 'package:home_widget/home_widget.dart';
import 'dart:io';
import 'package:flutter/services.dart';

class WidgetHelper {
  static const String androidWidgetName = 'DictionaryWidgetProvider';
  static const String iOSWidgetName = 'DictionaryWidget'; // For future iOS support
  
  // These keys are used to store data for the widget
  static const String wordKey = 'word';
  static const String meaningKey = 'meaning';
  static const String exampleKey = 'example';
  
  static Future<void> initializeWidget() async {
    // No need to set app group ID for Android-only app
    // If iOS support is added later, add the group ID here
    // await HomeWidget.setAppGroupId('YOUR_APP_GROUP_ID');
    
    // Initialize with default content
    await updateWidget(
      word: "Mountain Dictionary", 
      arabicMeaning: "قاموس الجبل", 
      exampleSentence: "Your personal dictionary on your home screen"
    );
  }
  
  static Future<void> updateWidget({
    required String word,
    required String arabicMeaning,
    required String exampleSentence,
  }) async {
    try {
      print('Updating widget with: $word, $arabicMeaning, $exampleSentence');
      
      // Save the data using consistent keys
      await HomeWidget.saveWidgetData<String>(wordKey, word);
      await HomeWidget.saveWidgetData<String>(meaningKey, arabicMeaning);
      await HomeWidget.saveWidgetData<String>(exampleKey, exampleSentence);
      
      // Trigger widget update
      final result = await HomeWidget.updateWidget(
        androidName: androidWidgetName,
        iOSName: iOSWidgetName,
      );
      
      print('Widget update result: $result');
    } catch (e) {
      print('Error updating widget: $e');
    }
  }
} 