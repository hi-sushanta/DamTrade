import 'package:damtrade/pages/home.dart';
import 'package:flutter/material.dart';
import '../main.dart';
import 'add_fund.dart';
import 'dart:async';
import 'stock_alart_page.dart';
import 'history_pages.dart';

class FundsPage extends StatefulWidget {
   @override
  _FundPageState createState() => _FundPageState();
}
  // FundsPage({super.key});


class _FundPageState extends State<FundsPage>{
  Timer? _alertCheckTimer;

  @override
  void initState(){
    super.initState();
    StockAlertService().initializeNotifications();
    _startCheckingAlerts(); // Start checking alerts
  }

  @override
  void dispose() {
    _alertCheckTimer?.cancel();
    super.dispose();

  }

  void _startCheckingAlerts() {
      _alertCheckTimer = Timer.periodic(Duration(seconds: 30), (timer) async {
      var stockAlerts = watchlist!.stockAlertStore[userId]!.value;
      await StockAlertService().checkForAlerts(stockAlerts);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 255, 255, 255), // Background color
      appBar: AppBar(
        title: Center(
          child: const Text(
          'Funds',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold
          ),
        ),
        ),
        backgroundColor: Color.fromARGB(255, 204, 248, 210),
        elevation: 0,
        centerTitle: true,
        
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            padding: EdgeInsets.symmetric(vertical: 16),
            color:  Color.fromARGB(255, 204, 248, 210), // Light blue color
            child: Column(
              children: [
                Text(
                  'Total available balance',
                  style: TextStyle(fontSize: 16, color: const Color.fromARGB(255, 52, 52, 52)),
                ),
                SizedBox(height: 4),
                ValueListenableBuilder<double>(
                  valueListenable: watchlist!.amountHave[userId]!,
                  builder: (context, value, child) {
                    return Text(
                      value.toStringAsFixed(2),
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: Colors.black
                      ),
                    );
                  },
                ),
                SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _buildActionButton(context,Icons.add, 'Add Money', Color(0xFF70E5A0)),
                    SizedBox(width: 16),
                    _buildActionButton(context,Icons.history, 'History', Color(0xFFFFAB91)),
                  ],
                ),
              ],
            ),
          ),
          SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Recent Transactions',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ),
          ),
            Expanded(
            child: ValueListenableBuilder<List<List>>(
              valueListenable: watchlist!.amountAddHistory[userId]!,
              builder: (context, history, child) {
                if (history.isNotEmpty) {
                  return ListView(
                    children: [
                      for (var item in history)
                        _buildTransactionItem(
                          icon: item[0],
                          label: item[1],
                          date: item[2],
                          amount: item[3].toString(),
                          color: item[4],
                        ),
                    ],
                  );
                } else {
                  return const Center(
                    child: Text(
                      "Hello you don't have any transaction",
                      style: TextStyle(color: Colors.white),
                    ),
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton(BuildContext context,IconData icon, String label, Color color) {
    
    return ElevatedButton(
        onPressed: () {
          if(label != 'History'){
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => InputPage(),
            ),
          );
          } else{
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => HistoryOfContent()),
            );
          }
            },
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.black, // Button background color
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
            side: BorderSide(color: color),
          ),
          padding: EdgeInsets.symmetric(vertical: 12, horizontal: 24),
        ),
        child: Column(
          children: [
            Icon(icon, color: color, size: 24),
            SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(color: color),
            ),
          ],
        ),
      );
  }

  Widget _buildTransactionItem({
    required IconData icon,
    required String label,
    required String date,
    required String amount,
    required Color color,
  }) {
    return ListTile(
      leading: Container(
        padding: EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: color.withOpacity(0.2),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(icon, color: color),
      ),
      title: Text(label, style: TextStyle(fontSize: 16, color:  Colors.black,fontWeight: FontWeight.bold)),
      subtitle: Text(date, style: TextStyle(color: const Color.fromARGB(255, 99, 99, 99))),
      trailing: Text(
        amount,
        style: TextStyle(
          color: color,
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
