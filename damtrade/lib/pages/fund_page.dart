import 'package:damtrade/pages/home.dart';
import 'package:flutter/material.dart';
import '../main.dart';
import 'add_fund.dart';

class FundsPage extends StatelessWidget {


  FundsPage({super.key});



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black, // Background color
      appBar: AppBar(
        title: const Text(
          'Funds',
          style: TextStyle(
            color: Colors.black,
            fontSize: 18,
          ),
        ),
        backgroundColor: Color(0xFF8ED2FC),
        elevation: 0,
        centerTitle: true,
        
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            padding: EdgeInsets.symmetric(vertical: 16),
            color: Color(0xFF8ED2FC), // Light blue color
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
                    // SizedBox(width: 16),
                    // _buildActionButton(Icons.remove, 'Withdraw', Color(0xFFFFAB91)),
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
                  color: Colors.white,
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
                          amount: item[3],
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
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => InputPage(),
        ),
      );
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
      title: Text(label, style: TextStyle(fontSize: 16, color: Colors.white)),
      subtitle: Text(date, style: TextStyle(color: Colors.grey)),
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
