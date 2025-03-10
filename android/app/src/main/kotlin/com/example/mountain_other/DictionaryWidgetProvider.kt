package com.example.mountain_other

import android.appwidget.AppWidgetManager
import android.appwidget.AppWidgetProvider
import android.content.Context
import android.widget.RemoteViews
import android.content.Intent
import android.app.PendingIntent
import android.net.Uri
import android.util.Log

// Import home_widget package's helper
import es.antonborri.home_widget.HomeWidgetPlugin

class DictionaryWidgetProvider : AppWidgetProvider() {
    companion object {
        private const val TAG = "DictionaryWidgetProvider"
        
        // Keys for accessing shared preferences (must match those in WidgetHelper.dart)
        private const val WORD_KEY = "word"
        private const val MEANING_KEY = "meaning"
        private const val EXAMPLE_KEY = "example"
    }

    override fun onUpdate(context: Context, appWidgetManager: AppWidgetManager, appWidgetIds: IntArray) {
        Log.d(TAG, "onUpdate called with ${appWidgetIds.size} widgets")
        
        // Update each widget
        for (appWidgetId in appWidgetIds) {
            updateAppWidget(context, appWidgetManager, appWidgetId)
        }
    }

    private fun updateAppWidget(context: Context, appWidgetManager: AppWidgetManager, appWidgetId: Int) {
        try {
            // Get data from SharedPreferences via HomeWidgetPlugin
            val widgetData = HomeWidgetPlugin.getData(context)
            
            // Create remote views
            val views = RemoteViews(context.packageName, R.layout.widget_layout)
            
            // Get our data with fallback values
            val word = widgetData.getString(WORD_KEY, "Mountain Dictionary")
            val meaning = widgetData.getString(MEANING_KEY, "قاموس الجبل")
            val example = widgetData.getString(EXAMPLE_KEY, "Add words to see them here")
            
            Log.d(TAG, "Widget data: word=$word, meaning=$meaning, example=$example")
            
            // Set the text views with our data
            views.setTextViewText(R.id.wordTextView, word)
            views.setTextViewText(R.id.arabicMeaningTextView, meaning)
            views.setTextViewText(R.id.exampleSentenceTextView, example)
            
            // Create an Intent to launch the app when widget is clicked
            val intent = Intent(context, MainActivity::class.java).apply {
                action = "es.antonborri.home_widget.action.LAUNCH"
                data = Uri.parse("homewidget://dictionary")
            }
            
            val pendingIntent = PendingIntent.getActivity(
                context,
                0,
                intent,
                PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE
            )
            
            // Set click listener on the widget
            views.setOnClickPendingIntent(R.id.widget_container, pendingIntent)
            
            // Update the widget
            appWidgetManager.updateAppWidget(appWidgetId, views)
            Log.d(TAG, "Widget $appWidgetId updated")
        } catch (e: Exception) {
            Log.e(TAG, "Error updating widget: ${e.message}")
            e.printStackTrace()
            
            // Try fallback in case of error
            try {
                val fallbackViews = RemoteViews(context.packageName, R.layout.widget_layout)
                fallbackViews.setTextViewText(R.id.wordTextView, "Dictionary")
                fallbackViews.setTextViewText(R.id.arabicMeaningTextView, "قاموس")
                fallbackViews.setTextViewText(R.id.exampleSentenceTextView, "Tap to open app")
                appWidgetManager.updateAppWidget(appWidgetId, fallbackViews)
            } catch (fallbackError: Exception) {
                Log.e(TAG, "Fallback failed: ${fallbackError.message}")
            }
        }
    }
}