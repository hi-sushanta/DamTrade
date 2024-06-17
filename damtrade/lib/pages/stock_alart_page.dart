import 'package:flutter/material.dart';
import 'watch_list_info.dart';
import 'package:damtrade/main.dart';
import 'home.dart';

class StockAlertPage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    // Start updating prices when this page is opened
    watchlist!.startUpdatingPrices(userId);

    return Scaffold(
      appBar: AppBar(
        title: Text('Stock Alerts'),
        backgroundColor: Colors.teal,
      ),
      body: ValueListenableBuilder<List<StockAlertStore>>(
        valueListenable: watchlist!.stockAlertStore[userId]!,
        builder: (context, stockAlerts, _) {
          return stockAlerts.isNotEmpty ? Padding(
            padding: const EdgeInsets.all(8.0),
            child: ListView.builder(
              itemCount: stockAlerts.length,
              itemBuilder: (context, index) {
                final alert = stockAlerts[index];
                return StockAlertCard(alert: alert);
              },
            ),
          ) : const Center(
            child: Text("Your Alert Page Is Empty, Please add."),
          );
        },
      ),
    );
  }
}

class StockAlertCard extends StatelessWidget {
  final StockAlertStore alert;

  StockAlertCard({required this.alert});

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
                SizedBox(
                  width: 20,
                  height: 20,
                  child: CustomPaint(
                    painter: ProgressIndicatorPainter(
                      progress: (alert.currentPrice / alert.alertPrice).clamp(0.0, 1.0),
                      isPositive: isPositive,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class ProgressIndicatorPainter extends CustomPainter {
  final double progress;
  final bool isPositive;

  ProgressIndicatorPainter({required this.progress, required this.isPositive});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = isPositive ? Colors.green : Colors.red
      ..strokeWidth = 4.0
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    canvas.drawArc(
      Rect.fromLTWH(0, 0, size.width, size.height),
      -3.14 / 2,
      2 * 3.14 * progress,
      false,
      paint,
    );
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
