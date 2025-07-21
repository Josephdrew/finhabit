import 'dart:convert';
import 'dart:io';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Top-level function for background message handling
@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  debugPrint('Handling a background message: ${message.messageId}');
  
  // You can handle background notifications here
  // For example, update local database, show notification, etc.
}

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin _localNotifications = 
      FlutterLocalNotificationsPlugin();

  bool _isInitialized = false;
  String? _fcmToken;

  // Initialize the notification service
  Future<void> initialize() async {
    if (_isInitialized) return;

    try {
      // Initialize Firebase
      await Firebase.initializeApp();

      // Set up background message handler
      FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);

      // Initialize local notifications
      await _initializeLocalNotifications();

      // Request permissions
      await _requestPermissions();

      // Get FCM token
      await _getFCMToken();

      // Set up message handlers
      _setupMessageHandlers();

      _isInitialized = true;
      debugPrint('NotificationService initialized successfully');
    } catch (e) {
      debugPrint('Error initializing NotificationService: $e');
    }
  }

  // Initialize local notifications
  Future<void> _initializeLocalNotifications() async {
    const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
    const iosSettings = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    const initSettings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    await _localNotifications.initialize(
      initSettings,
      onDidReceiveNotificationResponse: _onNotificationTapped,
    );

    // Create notification channel for Android
    if (Platform.isAndroid) {
      const androidChannel = AndroidNotificationChannel(
        'finhabit_notifications',
        'FinHabit Notifications',
        description: 'Financial habit and goal notifications',
        importance: Importance.high,
        playSound: true,
      );

      await _localNotifications
          .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>()
          ?.createNotificationChannel(androidChannel);
    }
  }

  // Request notification permissions
  Future<void> _requestPermissions() async {
    if (Platform.isIOS) {
      await _firebaseMessaging.requestPermission(
        alert: true,
        badge: true,
        sound: true,
        provisional: false,
      );
    }

    // For Android 13+ (API level 33+), request notification permission
    if (Platform.isAndroid) {
      await _localNotifications
          .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>()
          ?.requestNotificationsPermission();
    }
  }

  // Get FCM token
  Future<void> _getFCMToken() async {
    try {
      _fcmToken = await _firebaseMessaging.getToken();
      debugPrint('FCM Token: $_fcmToken');
      
      // Store token locally for backend registration
      if (_fcmToken != null) {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('fcm_token', _fcmToken!);
      }

      // Listen for token refresh
      _firebaseMessaging.onTokenRefresh.listen((newToken) {
        _fcmToken = newToken;
        debugPrint('FCM Token refreshed: $newToken');
        _saveTokenToPreferences(newToken);
        // TODO: Send new token to your backend
      });
    } catch (e) {
      debugPrint('Error getting FCM token: $e');
    }
  }

  // Save token to shared preferences
  Future<void> _saveTokenToPreferences(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('fcm_token', token);
  }

  // Set up message handlers
  void _setupMessageHandlers() {
    // Handle foreground messages
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      debugPrint('Received foreground message: ${message.notification?.title}');
      _showLocalNotification(message);
    });

    // Handle when app is opened from notification
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      debugPrint('App opened from notification: ${message.notification?.title}');
      _handleNotificationTap(message);
    });

    // Handle when app is launched from terminated state
    _firebaseMessaging.getInitialMessage().then((RemoteMessage? message) {
      if (message != null) {
        debugPrint('App launched from notification: ${message.notification?.title}');
        _handleNotificationTap(message);
      }
    });
  }

  // Show local notification for foreground messages
  Future<void> _showLocalNotification(RemoteMessage message) async {
    final notification = message.notification;
    if (notification == null) return;

    const androidDetails = AndroidNotificationDetails(
      'finhabit_notifications',
      'FinHabit Notifications',
      channelDescription: 'Financial habit and goal notifications',
      importance: Importance.high,
      priority: Priority.high,
      showWhen: true,
      icon: '@mipmap/ic_launcher',
    );

    const iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    const details = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    await _localNotifications.show(
      message.hashCode,
      notification.title,
      notification.body,
      details,
      payload: jsonEncode(message.data),
    );
  }

  // Handle notification tap
  void _onNotificationTapped(NotificationResponse response) {
    if (response.payload != null) {
      final data = jsonDecode(response.payload!);
      _handleNotificationData(data);
    }
  }

  // Handle notification tap from Firebase
  void _handleNotificationTap(RemoteMessage message) {
    _handleNotificationData(message.data);
  }

  // Handle notification data and navigation
  void _handleNotificationData(Map<String, dynamic> data) {
    debugPrint('Handling notification data: $data');
    
    // Navigate based on notification type
    final type = data['type'];
    final screen = data['screen'];
    
    // You can implement navigation logic here
    // For example:
    // if (type == 'goal_reminder') {
    //   Navigator.pushNamed(context, '/goals');
    // } else if (type == 'transaction_alert') {
    //   Navigator.pushNamed(context, '/transactions');
    // }
  }

  // Get the current FCM token
  String? get fcmToken => _fcmToken;

  // Subscribe to a topic (useful for broadcast notifications)
  Future<void> subscribeToTopic(String topic) async {
    try {
      await _firebaseMessaging.subscribeToTopic(topic);
      debugPrint('Subscribed to topic: $topic');
    } catch (e) {
      debugPrint('Error subscribing to topic $topic: $e');
    }
  }

  // Unsubscribe from a topic
  Future<void> unsubscribeFromTopic(String topic) async {
    try {
      await _firebaseMessaging.unsubscribeFromTopic(topic);
      debugPrint('Unsubscribed from topic: $topic');
    } catch (e) {
      debugPrint('Error unsubscribing from topic $topic: $e');
    }
  }

  // Send token to backend (call this after user login)
  Future<void> sendTokenToBackend({
    required String userId,
    required String apiEndpoint,
  }) async {
    if (_fcmToken == null) return;

    try {
      // TODO: Replace with your actual backend API call
      /*
      final response = await http.post(
        Uri.parse('$apiEndpoint/users/$userId/fcm-token'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'fcm_token': _fcmToken,
          'platform': Platform.isAndroid ? 'android' : 'ios',
          'timestamp': DateTime.now().toIso8601String(),
        }),
      );

      if (response.statusCode == 200) {
        debugPrint('FCM token sent to backend successfully');
      } else {
        debugPrint('Failed to send FCM token to backend: ${response.statusCode}');
      }
      */
      
      debugPrint('FCM token ready to send to backend: $_fcmToken');
    } catch (e) {
      debugPrint('Error sending FCM token to backend: $e');
    }
  }

  // Clear notifications
  Future<void> clearAllNotifications() async {
    await _localNotifications.cancelAll();
  }
} 