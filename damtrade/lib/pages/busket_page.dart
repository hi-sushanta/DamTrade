import 'package:damtrade/main.dart';
import 'package:damtrade/pages/home.dart';
import 'package:flutter/material.dart';

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
  @override
  Widget build(BuildContext context) {
    // Sample data for demonstration
    double investedAmount = 0.0;
    double currentValue = 0.0;
    double profitLoss = 0.0;
    double profitLossPercentage = 0;
    if (watchlist!.protfollio.isNotEmpty){
          for (Map<String,dynamic> item in watchlist!.protfollio[userId]!){
                  investedAmount += item["investedAmount"];
                  currentValue += item['currentPrice'] * item["quantity"];
          }

          profitLoss = currentValue - investedAmount;
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
              TextSpan(
                text: "₹ ${value.toStringAsFixed(2)}",
                style: TextStyle(
                    fontSize: 18, color: isProfit ? Colors.green : Colors.red),
              ),
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
          final isProfit = holding['plAmount'] >= 0;

          return ListTile(
            contentPadding: EdgeInsets.all(16.0),
            title: Text(
              holding['name'],
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Qty: ${holding['quantity']} • Avg: ${holding['averagePrice']}"),
                Text("Invested: ₹${holding['investedAmount']}"),
              ],
            ),
            trailing: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  isProfit
                      ? "+₹${holding['plAmount']}"
                      : "-₹${holding['plAmount'].abs()}",
                  style: TextStyle(
                    color: isProfit ? Colors.green : Colors.red,
                    fontSize: 16,
                  ),
                ),
                Text(
                  "LTP: ₹${holding['currentPrice']}",
                  style: TextStyle(color: Colors.grey, fontSize: 14),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
