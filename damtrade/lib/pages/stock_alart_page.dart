import 'package:flutter/material.dart';


class StockAlertPage extends StatelessWidget {
  final List<StockAlertStore> stockAlerts = [
  StockAlertStore(exchangeName: 'NYSE', stockName: 'AAPL', currentPrice: 150.00, alertPrice: 145.00),
  StockAlertStore(exchangeName: 'NASDAQ', stockName: 'GOOGL', currentPrice: 2800.00, alertPrice: 2750.00),
  StockAlertStore(exchangeName: 'NYSE', stockName: 'TSLA', currentPrice: 700.00, alertPrice: 680.00),
];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Stock Alerts'),
      ),
      body: ListView.builder(
        itemCount: stockAlerts.length,
        itemBuilder: (context, index) {
          final alert = stockAlerts[index];
          return Card(
            child: ListTile(
              title: Text(alert.stockName),
              subtitle: Text('Exchange: ${alert.exchangeName}'),
              trailing: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text('Current: \$${alert.currentPrice.toStringAsFixed(2)}'),
                  Text('Alert: \$${alert.alertPrice.toStringAsFixed(2)}'),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}


class StockAlertStore {
  final String exchangeName;
  final String stockName;
  final double currentPrice;
  final double alertPrice;

  StockAlertStore({
    required this.exchangeName,
    required this.stockName,
    required this.currentPrice,
    required this.alertPrice,
  });
}


