import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/notification_service.dart';

class NotificationDemoWidget extends StatefulWidget {
  const NotificationDemoWidget({super.key});

  @override
  State<NotificationDemoWidget> createState() => _NotificationDemoWidgetState();
}

class _NotificationDemoWidgetState extends State<NotificationDemoWidget> {
  String? _fcmToken;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadFCMToken();
  }

  Future<void> _loadFCMToken() async {
    setState(() => _isLoading = true);
    
    // Get token from NotificationService
    final token = NotificationService().fcmToken;
    
    // Also try to get from SharedPreferences as fallback
    if (token == null) {
      final prefs = await SharedPreferences.getInstance();
      final storedToken = prefs.getString('fcm_token');
      setState(() {
        _fcmToken = storedToken;
        _isLoading = false;
      });
    } else {
      setState(() {
        _fcmToken = token;
        _isLoading = false;
      });
    }
  }

  void _copyTokenToClipboard() {
    if (_fcmToken != null) {
      // In a real app, you'd use a clipboard package
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('FCM Token copied to console (check debug output)'),
          duration: Duration(seconds: 2),
        ),
      );
      debugPrint('FCM Token: $_fcmToken');
    }
  }

  Future<void> _subscribeToGoalReminders() async {
    await NotificationService().subscribeToTopic('goal_reminders');
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Subscribed to Goal Reminders'),
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  Future<void> _subscribeToTransactionAlerts() async {
    await NotificationService().subscribeToTopic('transaction_alerts');
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Subscribed to Transaction Alerts'),
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  Future<void> _unsubscribeFromGoalReminders() async {
    await NotificationService().unsubscribeFromTopic('goal_reminders');
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Unsubscribed from Goal Reminders'),
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  Future<void> _clearAllNotifications() async {
    await NotificationService().clearAllNotifications();
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('All notifications cleared'),
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  Future<void> _sendTokenToBackend() async {
    // Example of how to send token to backend
    await NotificationService().sendTokenToBackend(
      userId: 'user_123', // Replace with actual user ID
      apiEndpoint: 'https://your-api.com', // Replace with your API endpoint
    );
    
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Token sent to backend (check console for details)'),
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Push Notification Demo',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            
            // FCM Token Section
            Card(
              color: Colors.grey[50],
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.token, color: Colors.blue[700]),
                        const SizedBox(width: 8),
                        Text(
                          'FCM Token',
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    if (_isLoading)
                      const Center(child: CircularProgressIndicator())
                    else if (_fcmToken != null)
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: Colors.grey[200],
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              '${_fcmToken!.substring(0, 50)}...',
                              style: const TextStyle(
                                fontFamily: 'monospace',
                                fontSize: 12,
                              ),
                            ),
                          ),
                          const SizedBox(height: 8),
                          ElevatedButton.icon(
                            onPressed: _copyTokenToClipboard,
                            icon: const Icon(Icons.copy, size: 16),
                            label: const Text('Copy to Console'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blue[100],
                              foregroundColor: Colors.blue[800],
                            ),
                          ),
                        ],
                      )
                    else
                      const Text('No FCM token available'),
                  ],
                ),
              ),
            ),
            
            const SizedBox(height: 16),
            
            // Topic Subscriptions
            Text(
              'Topic Subscriptions',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                ElevatedButton.icon(
                  onPressed: _subscribeToGoalReminders,
                  icon: const Icon(Icons.flag, size: 16),
                  label: const Text('Subscribe Goal Reminders'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green[100],
                    foregroundColor: Colors.green[800],
                  ),
                ),
                ElevatedButton.icon(
                  onPressed: _subscribeToTransactionAlerts,
                  icon: const Icon(Icons.receipt, size: 16),
                  label: const Text('Subscribe Transaction Alerts'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange[100],
                    foregroundColor: Colors.orange[800],
                  ),
                ),
                ElevatedButton.icon(
                  onPressed: _unsubscribeFromGoalReminders,
                  icon: const Icon(Icons.cancel, size: 16),
                  label: const Text('Unsubscribe Goals'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red[100],
                    foregroundColor: Colors.red[800],
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 16),
            
            // Backend Integration
            Text(
              'Backend Integration',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                ElevatedButton.icon(
                  onPressed: _sendTokenToBackend,
                  icon: const Icon(Icons.cloud_upload, size: 16),
                  label: const Text('Send Token to Backend'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.purple[100],
                    foregroundColor: Colors.purple[800],
                  ),
                ),
                ElevatedButton.icon(
                  onPressed: _clearAllNotifications,
                  icon: const Icon(Icons.clear_all, size: 16),
                  label: const Text('Clear Notifications'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.grey[100],
                    foregroundColor: Colors.grey[800],
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 16),
            
            // Instructions
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.amber[50],
                border: Border.all(color: Colors.amber[200]!),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.info, color: Colors.amber[700]),
                      const SizedBox(width: 8),
                      Text(
                        'Setup Instructions',
                        style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Colors.amber[700],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    '1. Set up Firebase project and add google-services.json\n'
                    '2. Copy the FCM token and use it in your backend\n'
                    '3. Test notifications from Firebase Console\n'
                    '4. Implement backend notification triggers\n'
                    '5. Customize notification handling in NotificationService',
                    style: TextStyle(fontSize: 12),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
} 