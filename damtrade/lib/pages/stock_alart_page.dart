import 'package:damtrade/pages/json_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_ringtone_player/flutter_ringtone_player.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:permission_handler/permission_handler.dart'; // Ensure this import works
import 'watch_list_info.dart';
import 'package:damtrade/main.dart';
import 'home.dart';
import 'stock_service.dart';
import 'dart:async';
import 'dart:io';

class StockAlertPage extends StatefulWidget {
  @override
  _StockAlertPageState createState() => _StockAlertPageState();
}

class _StockAlertPageState extends State<StockAlertPage> {

  Timer? _alertCheckTimer;

  @override
  void initState() {
    super.initState();
    _requestNotificationPermissions();
    StockAlertService().initializeNotifications();
    _startCheckingAlerts();
    // _updateAlerts();
  }

  @override 
  void dispose(){
    _alertCheckTimer?.cancel();
    super.dispose();
  }

  Future<void> _requestNotificationPermissions() async {
    if (Platform.isAndroid && await Permission.notification.isDenied) {
      await Permission.notification.request();
    }
  }

  void _startCheckingAlerts() {
      _alertCheckTimer = Timer.periodic(Duration(seconds: 30), (timer) async {
      var stockAlerts = watchlist!.stockAlertStore[userId]!.value;
      if (mounted) {
          await StockAlertService().checkForAlerts(stockAlerts);

      } else {
        timer.cancel();
      }
      setState(() {
        
      });
    });
  }

  void _updateAlerts() async {
    var stockAlerts = watchlist!.stockAlertStore[userId]!.value;
    await StockAlertService().checkForAlerts(stockAlerts);
    setState(() {}); // Ensure UI updates after alert check
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Center(
          child:Text('Stock Alerts',
          style: TextStyle(color:Colors.green.shade600,fontWeight: FontWeight.bold),),
        ),
        // backgroundColor: Colors.lime,
      ),
      body: ValueListenableBuilder<List<StockAlertStore>>(
        valueListenable: watchlist!.stockAlertStore[userId]!,
        builder: (context, stockAlerts, _) {
          return stockAlerts.isNotEmpty
              ? Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ListView.builder(
                    itemCount: stockAlerts.length,
                    itemBuilder: (context, index) {
                      final alert = stockAlerts[index];
                      return StockAlertCard(
                        alert: alert,
                        onDelete: () {
                          watchlist!.removeAlartStock(userId, index);
                          _updateAlerts(); // Update alerts on delete
                        },
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
      color: Color.fromARGB(255, 235, 247, 212),
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
            Text(
              alert.stockName,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.teal[900],
              ),
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
                IconButton(
                  icon: Icon(Icons.delete, color: Colors.red),
                  onPressed: onDelete,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class StockAlertService {
  final UpstoxService _upstoxService = UpstoxService(JsonService());

  static final StockAlertService _singleton = StockAlertService._internal();
  factory StockAlertService() => _singleton;
  StockAlertService._internal();

  final _notifiedAlerts = <String>{}; // Track notified alerts
  FlutterLocalNotificationsPlugin? _flutterLocalNotificationsPlugin;

  void initializeNotifications() {
    _flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const InitializationSettings initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
    );

    _flutterLocalNotificationsPlugin!.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: _onNotificationResponse,
    );
  }

  Future<void> _onNotificationResponse(NotificationResponse response) async {
    // Handle notification tap here
  }

  Future<void> showNotification(StockAlertStore alert) async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      'stock_alerts_channel',
      'Stock Alerts',
      channelDescription: 'Notifications for stock alerts',
      importance: Importance.max,
      priority: Priority.high,
      ticker: 'ticker',
    );

    const NotificationDetails platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
    );

    await _flutterLocalNotificationsPlugin!.show(
      alert.stockName.hashCode,
      'Price Alert for ${alert.stockName}',
      'Current price is \$${alert.currentPrice.toStringAsFixed(2)}, Alert set at \$${alert.alertPrice.toStringAsFixed(2)}',
      platformChannelSpecifics,
    );

  }

  Future<void> checkForAlerts(List<StockAlertStore> alerts) async {
    List<StockAlertStore> alertsToRemove = [];
    int i = 0;
    List<int> removeAlertIndex = [];
    for (var alert in alerts) {
      var stockData = await _upstoxService.fetchStockData(alert.instrumentKey,alert.stockName,alert.instrumentKey.split("|")[0]);
      var latestPrice = double.parse(stockData['currentPrice']!); // Adjust based on actual key
      alert.currentPrice = latestPrice;
      if (latestPrice == alert.alertPrice) {
        _notifiedAlerts.add(alert.stockName);
        await showNotification(alert);
        alertsToRemove.add(alert); // Mark alert for removal
        watchlist!.removeAlartStock(userId, i);

      }
      i += 1;
    }

    // Remove alerts that have been notified
    for (var alert in alertsToRemove) {
      alerts.remove(alert);
    }

    // Ensure UI updates
    watchlist!.stockAlertStore[userId]!.value = alerts;
    watchlist!.stockAlertStore[userId]!.notifyListeners();
  }
}
