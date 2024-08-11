
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:damtrade/main.dart';
import 'home.dart';
import 'stock_alart_page.dart';

class HistoryOfContent extends StatelessWidget {
  HistoryOfContent({super.key});
  Timer? _timer;
  Timer? _alertCheckTimer;

  List<double> plAmount = [];
  List<String> orderType = [];

  void initState() {
    StockAlertService().initializeNotifications();
    _startCheckingAlerts(); // Start checking alerts

  }

  void dispose() {
    _timer?.cancel();
    _alertCheckTimer?.cancel();
  }

  void _startCheckingAlerts() {
      _alertCheckTimer = Timer.periodic(Duration(seconds: 30), (timer) async {
      var stockAlerts = watchlist!.stockAlertStore[userId]!.value;
      await StockAlertService().checkForAlerts(stockAlerts);
      
    });
  }


  @override
  Widget build(BuildContext context) {
    double investedAmount = 0.0;
    double currentValue = 0.0;
    double profitLoss = 0.0;
    double profitLossPercentage = 0;

    if (watchlist!.history.isNotEmpty) {
      int i = 0;
      plAmount = [];
      orderType = [];
      for (Map<String, dynamic> item in watchlist!.history[userId]!) {
        investedAmount += item["investedAmount"];
        
        plAmount.add(item['plAmount']);
        profitLoss += item['plAmount'];
        currentValue += item['currentPrice'] * item["quantity"];
        orderType.add(item["orderType"]);
        i += 1;
      }
      
      if(profitLoss != 0.0){
          profitLossPercentage = (profitLoss / investedAmount) * 100;
      }
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
            "History",
            style: TextStyle(
              color: Colors.green.shade600,
              fontWeight: FontWeight.bold,
            ),
          ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color.fromARGB(255, 0, 0, 0)),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Column(
        children: [
          if (watchlist!.history.isNotEmpty)
            _buildPortfolioSummary(
                investedAmount, currentValue, profitLoss, profitLossPercentage),
          _buildHoldingsList(watchlist!.history[userId]!),
        ],
      ),
    );
  }

  Widget _buildPortfolioSummary(double invested, double current,
      double profitLoss, double profitLossPercentage) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 8),
          Container(
            decoration: BoxDecoration(
              color: (profitLoss>=0) ? Color.fromARGB(255, 208, 241, 210):Color.fromARGB(255, 247, 219, 217) ,
              borderRadius: BorderRadius.circular(10),
            ),
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildSummaryRow("Invested", invested),
                const SizedBox(height: 8),
                _buildSummaryRow("Current", current),
                const SizedBox(height: 8),
                _buildSummaryRow("P&L", profitLoss,
                    isProfit: profitLoss >= 0, percentage: profitLossPercentage),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryRow(String label, double value,
      {bool isProfit = false, double? percentage}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 18),
        ),
        RichText(
          text: TextSpan(
            children: [
              ((label != "Invested") & (label != "Current"))
                  ? TextSpan(
                      text: "₹ ${value.toStringAsFixed(2)}",
                      style: TextStyle(
                          fontSize: 18,
                          color: isProfit ? Colors.green : Colors.red,
                          fontWeight: FontWeight.bold),
                          
                    )
                  : TextSpan(
                      text: "₹ ${value.toStringAsFixed(2)}",
                      style: TextStyle(fontSize: 18, color: Colors.black)),
              if (percentage != null)
                TextSpan(
                  text: " (${percentage.toStringAsFixed(2)}%)",
                  style: TextStyle(
                      fontSize: 16,
                      color: isProfit ? Colors.green : Colors.red,fontWeight: FontWeight.bold),
                ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildHoldingsList(List<Map<String, dynamic>> holdings) {
    return Expanded(
      child: ListView.builder(
        itemCount: holdings.length,
        itemBuilder: (context, index) {
          final holding = holdings[index];
          final isProfit = plAmount[index] >= 0;

          return Card(
            color: isProfit ? const Color.fromARGB(255, 235, 255, 235) : const Color.fromARGB(255, 255, 237, 236),
            elevation: 5,
            margin: EdgeInsets.all(16.0),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "${holding['name']} (${holding['exchange_name']})",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                  ),
                  const SizedBox(height: 8),
                  Text("Quantity: ${holding['quantity']}"),
                  Text("Average Price: ₹${holding['averagePrice']}"),
                  Text("Invested Amount: ₹${holding['investedAmount']}"),
                  Text("Current Price: ₹${holding['currentPrice']}"),
                  Text(
                    "P&L: ${isProfit ? '+' : '-'}₹${plAmount[index].toStringAsFixed(2)}",
                    style: TextStyle(
                      color: isProfit ? Colors.green : Colors.red,
                      fontSize: 16,
                    ),
                  ),
                 
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
