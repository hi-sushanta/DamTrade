import 'dart:io';

import 'package:damtrade/main.dart';
import 'package:damtrade/pages/home.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

class StockAlert extends StatefulWidget {
  final String stockName;
  final String exchangeName;
  final String currentPrice;
  final String instrumentKey;
  StockAlert({super.key, required this.stockName, required this.exchangeName,required this.instrumentKey, required this.currentPrice});
  
  @override
  _StockAlert createState() => _StockAlert();
}

class _StockAlert extends State<StockAlert>{
  
  final TextEditingController _priceController = TextEditingController();
  final FocusNode _focusNode = FocusNode();

  
  @override
  void initState(){
    super.initState();
    _requestNotificationPermissions();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _focusNode.requestFocus();
    });

  }

  @override
  void dispose(){
    super.dispose();
    _priceController.dispose();
    _focusNode.dispose();

  }
  Future<void> _requestNotificationPermissions() async {
    if (Platform.isAndroid && await Permission.notification.isDenied) {
      await Permission.notification.request();
    }
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Alert',style: TextStyle(color:Colors.green.shade600,fontWeight: FontWeight.bold)),
        // backgroundColor: Colors.green.shade700,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Set an alert price for ${widget.stockName}',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.green.shade900,
                ),
              ),
              SizedBox(height: 20),
              Text(
                'Enter the alert price below:',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey.shade600,
                ),
              ),
              SizedBox(height: 10),
              TextField(
                controller: _priceController,
                focusNode: _focusNode,
                keyboardType: TextInputType.number,
                style: TextStyle(fontSize: 18),
                decoration: InputDecoration(
                  labelText: 'Alert Price',
                  
                  labelStyle: TextStyle(color: Colors.green.shade800),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    borderSide: BorderSide(color: Colors.green.shade800),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    borderSide: BorderSide(color: Colors.green.shade600),
                  ),
                  prefixIcon: Icon(Icons.attach_money, color: Colors.green.shade800),
                ),
              ),
              SizedBox(height: 30),
              Center(
                child: ElevatedButton.icon(
                  icon: Icon(Icons.notifications_active, color: Colors.white),
                  label: Text(
                    'Set Alert',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(horizontal: 40.0, vertical: 15.0),
                    backgroundColor: Colors.green.shade800,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                  ),
                  onPressed: () {
                    // Implement the logic to save the alert
                    try{
                      final alertPrice = double.parse(_priceController.text);
                      if (alertPrice > 0.0){
                          watchlist!.setAlert(userId, widget.stockName,widget.exchangeName ,widget.instrumentKey,double.parse(widget.currentPrice),alertPrice);
                        // Use alertPrice to set the alert
                          // ...
                          Navigator.pop(context); // Close the page after setting the alert
                      } else{
                        ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Alert Price Must Be Grater Than 0',style: TextStyle(color:Color.fromARGB(255, 255, 255, 255)),),backgroundColor: Color.fromARGB(255, 247, 62, 11),));
                      }
                    } catch (e){
                               ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Invelid Value Enterd.',style: TextStyle(color:Color.fromARGB(255, 255, 255, 255)),),backgroundColor: Color.fromARGB(255, 247, 62, 11),));
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
