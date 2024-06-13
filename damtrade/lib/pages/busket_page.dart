import 'package:flutter/material.dart';
import 'package:flutter_swipe_button/flutter_swipe_button.dart';
import 'dart:async';
import '../main.dart';
import 'stock_service.dart';
import 'home.dart';

class SecondPageContent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: _PortfolioPage(),
    );
  }
}

class _PortfolioPage extends StatefulWidget {
  @override
  _PortfolioPageState createState() => _PortfolioPageState();
}

class _PortfolioPageState extends State<_PortfolioPage> {
  Timer? _timer;
  List<Map<String, Map<String, String>>> stockData = [];
  List<double> plAmount = [];
  List<String> orderType = [];

  @override
  void initState() {
    super.initState();
    _updateStockData().then((_) => _startFetchingStockData());
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _startFetchingStockData() async {
    _timer = Timer.periodic(Duration(seconds: 30), (timer) async {
      await _updateStockData();
    });
  }

  Future<void> _updateStockData() async {
    List<Map<String, Map<String, String>>> updatedStockData = [];

    try {
      Map<String, Map<String, String>> stockInfo = {};
      for (var item in watchlist!.protfollio[userId]!) {
        String istock = item['name'];
        Map<String, String> data = await fetchStockData(istock);
        stockInfo[istock] = data;
      }
      updatedStockData.add(stockInfo);

      setState(() {
        stockData = updatedStockData;
      });
    } catch (e) {
      print('Error updating stock data: $e');
    }
  }

  void _handleSwipeAction(int index) {
    setState(() {
      watchlist!.protfollio[userId]!.removeAt(index);
      orderType = [];
      _updateStockData();
      _updateProfitLoss();
    });
  }
  void _updateProfitLoss() {
      double investedAmount = 0.0;
      double currentValue = 0.0;
      double profitLoss = 0.0;

      for (var item in watchlist!.protfollio[userId]!) {
        investedAmount += item['investedAmount'];
        currentValue += item['currentPrice'] * item['quantity'];
      }
      profitLoss = currentValue - investedAmount;
      setState(() {
        // No need to save these, just using for display
      });
  }


  @override
  Widget build(BuildContext context) {
    double investedAmount = 0.0;
    double currentValue = 0.0;
    double profitLoss = 0.0;
    double profitLossPercentage = 0;

    if (watchlist!.protfollio.isNotEmpty) {
      int i = 0;
      plAmount = [];
      for (Map<String, dynamic> item in watchlist!.protfollio[userId]!) {
        investedAmount += item["investedAmount"];
        if (stockData.isNotEmpty) {
          item["currentPrice"] =
              double.parse(stockData[0][item["name"]]!['currentPrice']!);
          if (item["orderType"] == "Buy") {
            plAmount.add((item['currentPrice'] * item['quantity']) -
                item["investedAmount"]);
            profitLoss += (item['currentPrice'] - item['investedAmount']);
          } else {
            plAmount.add(item["investedAmount"] -
                (item['currentPrice'] * item['quantity']));
            profitLoss += (item['investedAmount'] - item['currentPrice']);
          }
          watchlist!.protfollio[userId]![i]["currentPrice"] =
              item['currentPrice'];
          
          watchlist!.protfollio[userId]![i]['plAmount'] = plAmount[i];
        } else {
          plAmount.add(item['plAmount']);
        }
        currentValue += item['currentPrice'] * item["quantity"];
        orderType.add(item["orderType"]);
        i += 1;
      }
      profitLossPercentage = (profitLoss / investedAmount) * 100;
    }

    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Text(
            "Portfolio",
            style: TextStyle(
              color: Colors.green.shade600,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
      body: Column(
        children: [
          if (watchlist!.protfollio.isNotEmpty)
            _buildPortfolioSummary(
                investedAmount, currentValue, profitLoss, profitLossPercentage),
          _buildHoldingsList(watchlist!.protfollio[userId]!),
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
          Text(
            "Holdings",
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 8),
          Container(
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(10),
            ),
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildSummaryRow("Invested", invested),
                SizedBox(height: 8),
                _buildSummaryRow("Current", current),
                SizedBox(height: 8),
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
          style: TextStyle(fontSize: 18),
        ),
        RichText(
          text: TextSpan(
            children: [
              ((label != "Invested") & (label != "Current")) ?
                  TextSpan(
                    text: "₹ ${value.toStringAsFixed(2)}",
                    style: TextStyle(
                        fontSize: 18, color: isProfit ? Colors.green : Colors.red),
                  ): TextSpan(text: "₹ ${value.toStringAsFixed(2)}",
                    style: TextStyle(
                        fontSize: 18, color:Colors.black)),
              if (percentage != null)
                TextSpan(
                  text: " (${percentage.toStringAsFixed(2)}%)",
                  style: TextStyle(
                      fontSize: 16,
                      color: isProfit ? Colors.green : Colors.red),
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
            margin: EdgeInsets.all(16.0),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    holding['name'],
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                  ),
                  SizedBox(height: 8),
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
                  SizedBox(height: 8),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16.0),
                    child: SwipeButton.expand(
                      activeTrackColor:
                          orderType[index] == 'Buy' ? Colors.red : Colors.blue,
                      thumb: Icon(Icons.double_arrow, color: Colors.white),
                      activeThumbColor: orderType[index] == 'Buy'
                          ? Colors.red[300]
                          : Colors.blue[300],
                      onSwipe: () => _handleSwipeAction(index),
                      borderRadius: BorderRadius.circular(30.0),
                      height: 60.0,
                      child: Text(
                        orderType[index] == 'Buy'
                            ? "SWIPE TO SELL"
                            : "SWIPE TO BUY",
                        style: TextStyle(fontSize: 16, color: Colors.white),
                      ),
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
