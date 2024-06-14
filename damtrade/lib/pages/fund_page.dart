import 'package:damtrade/pages/home.dart';
import 'package:flutter/material.dart';
import '../main.dart';

class FundsPage extends StatelessWidget {


  FundsPage({super.key});



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black, // Background color
      appBar: AppBar(
        title: Text(
          'Funds',
          style: TextStyle(
            color: Colors.black,
            fontSize: 18,
          ),
        ),
        backgroundColor: Color(0xFF8ED2FC),
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
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
                Text(
                  '${watchlist!.amountHave[userId]}',
                  style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.black),
                ),
                SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _buildActionButton(Icons.add, 'Add Money', Color(0xFF70E5A0)),
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
              child:  (watchlist!.amountAddHistory[userId]!.isNotEmpty) ? 
                      ListView(
                        children: [
                          _buildTransactionItem(
                            icon: Icons.add,
                            label: 'Add Money',
                            date: '12 June, 2023',
                            amount: '+2,000',
                            color: Color(0xFF70E5A0),
                          ),
                          _buildTransactionItem(
                            icon: Icons.add,
                            label: 'Add Money',
                            date: '02 June, 2023',
                            amount: '+4,000',
                            color: Color(0xFF70E5A0),
                          ),
                          _buildTransactionItem(
                            icon: Icons.add,
                            label: 'Add Money',
                            date: '20 May, 2023',
                            amount: '+7,000',
                            color: Color(0xFF70E5A0),
                          ),
                          _buildTransactionItem(
                            icon: Icons.add,
                            label: 'Add Money',
                            date: '07 April, 2023',
                            amount: '+1,000',
                            color: Color(0xFF70E5A0),
                          ),
                          _buildTransactionItem(
                            icon: Icons.add,
                            label: 'Add Money',
                            date: '07 April, 2023',
                            amount: '+1,000',
                            color: Color(0xFF70E5A0),
                          ),
                          _buildTransactionItem(
                            icon: Icons.add,
                            label: 'Add Money',
                            date: '07 April, 2023',
                            amount: '+1,000',
                            color: Color(0xFF70E5A0),
                          ),
                          _buildTransactionItem(
                            icon: Icons.add,
                            label: 'Add Money',
                            date: '07 April, 2023',
                            amount: '+1,000',
                            color: Color(0xFF70E5A0),
                          ),
                          _buildTransactionItem(
                            icon: Icons.add,
                            label: 'Add Money',
                            date: '07 April, 2023',
                            amount: '+1,000',
                            color: Color(0xFF70E5A0),
                          ),
                          _buildTransactionItem(
                            icon: Icons.add,
                            label: 'Add Money',
                            date: '07 April, 2023',
                            amount: '+1,000',
                            color: Color(0xFF70E5A0),
                          ),
                        ],
                  )
                  :const Center(
                  child: Text("Hello you don't have any transaction"),
                  ),
              )
        ],
      ),
    );
  }

  Widget _buildActionButton(IconData icon, String label, Color color) {
    return ElevatedButton(
      onPressed: () {},
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
