import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class NotificationHistoryPage extends StatefulWidget {
  const NotificationHistoryPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _NotificationPageState createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationHistoryPage> {
  final supabase = Supabase.instance.client;
  List<Map<String, dynamic>> notificationHistory = [];

  @override
  void initState() {
    super.initState();
    _fetchNotificationHistory();
  }

  Future<void> _fetchNotificationHistory() async {
    try {
      final response = await supabase
          .from('notification_history')
          .select()
          .order('time', ascending: false);
      setState(
        () {
          // ignore: unnecessary_cast
          notificationHistory = response as List<Map<String, dynamic>>;
        },
      );
    } catch (error) {
      // Handle errors gracefully, e.g., display an error message to the user
      print('Error fetching notification history: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Notification History',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: HexColor("#0066FF"),
      ),
      body: notificationHistory.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: notificationHistory.length,
              itemBuilder: (context, index) {
                final notification = notificationHistory[index];
                final date = notification['date'];
                final time = notification['time'];
                final label = notification['label'];

                return Container(
                  padding: const EdgeInsets.all(25),
                  margin: const EdgeInsets.symmetric(vertical: 8.0),
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        date,
                        style: const TextStyle(fontSize: 16.0),
                      ),
                      Text(
                        time,
                        style: const TextStyle(fontSize: 16.0),
                      ),
                      Text(
                        label,
                        style: const TextStyle(fontSize: 16.0),
                      ),
                    ],
                  ),
                );
              },
            ),
    );
  }
}
