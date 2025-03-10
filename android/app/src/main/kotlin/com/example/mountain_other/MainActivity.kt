package com.example.mountain_other

import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugins.GeneratedPluginRegistrant
import android.util.Log

class MainActivity: FlutterActivity() {
    private val TAG = "MainActivity"
    
    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        Log.d(TAG, "Configuring Flutter engine")
        super.configureFlutterEngine(flutterEngine)
        
        // Let the plugin registrant handle registering our plugins
        GeneratedPluginRegistrant.registerWith(flutterEngine)
        Log.d(TAG, "Plugins registered")
    }
}
