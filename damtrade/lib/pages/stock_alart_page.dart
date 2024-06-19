import 'package:flutter/material.dart';
import 'package:flutter_ringtone_player/flutter_ringtone_player.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'watch_list_info.dart';
import 'package:damtrade/main.dart';
import 'home.dart';

class StockAlertPage extends StatefulWidget {
  @override
  _StockAlertPageState createState() => _StockAlertPageState();
}

class _StockAlertPageState extends State<StockAlertPage> {
  Set<StockAlertStore> notifiedAlerts = {};
  FlutterLocalNotificationsPlugin? flutterLocalNotificationsPlugin;

  @override
  void initState() {
    super.initState();
    watchlist!.startUpdatingPrices(userId);
    initializeNotifications();
  }

  void initializeNotifications() {
    flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const InitializationSettings initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
    );

    flutterLocalNotificationsPlugin!.initialize(initializationSettings);
  }

  Future<void> showNotification(StockAlertStore alert) async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      'stock_alerts_channel',
      'Stock Alerts',
      importance: Importance.high,
      priority: Priority.high,
      playSound: true,
    );

    const NotificationDetails platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
    );

    await flutterLocalNotificationsPlugin!.show(
      0, // Notification ID
      'Stock Alert: ${alert.stockName}',
      'Current price \$${alert.currentPrice.toStringAsFixed(2)} has reached or exceeded your alert price \$${alert.alertPrice.toStringAsFixed(2)}',
      platformChannelSpecifics,
      payload: 'Stock Alert', // Payload can be used to pass additional information
    );
  }

  void checkAlerts(List<StockAlertStore> alerts) {
    // Create a list to hold indices of alerts to be removed
    List<int> indicesToRemove = [];
    int index = 0;

    for (var alert in alerts) {
      if (alert.currentPrice >= alert.alertPrice && !notifiedAlerts.contains(alert)) {
        print("Index: $index");
        FlutterRingtonePlayer().play(
          android: AndroidSounds.notification,
          ios: IosSounds.glass,
          looping: false,
          volume: 0.5,
          asAlarm: false,
        );

        notifiedAlerts.add(alert);
        showNotification(alert);
        
        // Add index to list of indices to remove later
        indicesToRemove.add(index);
      }
      index += 1;
    }

    // Remove alerts by index, from last to first to avoid index shifting issues
    for (var i = indicesToRemove.length - 1; i >= 0; i--) {
      watchlist!.removeAlartStock(userId, indicesToRemove[i]);
    }
  }

  void deleteAlert(StockAlertStore alert) {
    watchlist!.removeAlartStock(userId, watchlist!.stockAlertStore[userId]!.value.indexOf(alert));
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Stock Alerts'),
        backgroundColor: Colors.teal,
      ),
      body: ValueListenableBuilder<List<StockAlertStore>>(
        valueListenable: watchlist!.stockAlertStore[userId]!,
        builder: (context, stockAlerts, _) {
          // This ensures notifications only play when stock prices match the alert prices
          checkAlerts(stockAlerts);

          return stockAlerts.isNotEmpty
              ? Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ListView.builder(
                    itemCount: stockAlerts.length,
                    itemBuilder: (context, index) {
                      final alert = stockAlerts[index];
                      return StockAlertCard(
                        alert: alert,
                        onDelete: () => deleteAlert(alert),
                      );
                    },
                  ),
                )
              : const Center(
                  child: Text("Your Alert Page Is Empty, Please add."),
                );
        },
      ),
    );
  }
}


class StockAlertCard extends StatelessWidget {
  final StockAlertStore alert;
  final VoidCallback onDelete;

  StockAlertCard({required this.alert, required this.onDelete});

  @override
  Widget build(BuildContext context) {
    bool isPositive = alert.currentPrice >= alert.alertPrice;

    return Card(
      elevation: 5,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      margin: EdgeInsets.symmetric(vertical: 8.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  alert.stockName,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.teal[900],
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.delete, color: Colors.red),
                  onPressed: onDelete,
                ),
              ],
            ),
            SizedBox(height: 4),
            Text(
              'Exchange: ${alert.exchangeName}',
              style: TextStyle(
                fontSize: 16,
                color: Colors.teal[600],
              ),
            ),
            Divider(
              color: Colors.teal[200],
              height: 20,
              thickness: 1,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Current Price',
                      style: TextStyle(
                        color: Colors.teal[700],
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      '\$${alert.currentPrice.toStringAsFixed(2)}',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: isPositive ? Colors.green : Colors.red,
                      ),
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Alert Price',
                      style: TextStyle(
                        color: Colors.teal[700],
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      '\$${alert.alertPrice.toStringAsFixed(2)}',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.teal[800],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
