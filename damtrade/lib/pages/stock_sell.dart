import 'dart:async';

import 'package:damtrade/pages/get_optionData.dart';
import 'package:damtrade/pages/json_service.dart';
import 'package:damtrade/pages/stock_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_swipe_button/flutter_swipe_button.dart';
import 'home.dart';
import 'package:damtrade/main.dart';

class StockSellPage extends StatefulWidget {
  final String stockName;
  final String exchangeName;
  double livePrice;
  final String instrumentKey;
  final String instrumentType;
  String defaultQuantity;
  StockSellPage({
    required this.stockName,
    required this.exchangeName,
    required this.livePrice,
    required this.instrumentKey,
    required this.instrumentType,
    required this.defaultQuantity
  });

  @override
  _StockSellPageState createState() => _StockSellPageState();
}

class _StockSellPageState extends State<StockSellPage> {
  final TextEditingController _quantityController = TextEditingController(text: '1');
  final TextEditingController _priceController = TextEditingController();
  final UpstoxService _upstoxService = UpstoxService(JsonService());
  final GetOptionData getOptionData = GetOptionData();
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    setQuantity();
    _updatePrice();
    _quantityController.addListener(_updatePrice);
    _updateStockData().then((_) => _startFetchingStockData());
  }

  @override
  void dispose() {
    _quantityController.dispose();
    _priceController.dispose();
    _timer?.cancel();
    super.dispose();
  }

void _startFetchingStockData() async {
    _timer = Timer.periodic(Duration(seconds: 15), (timer) async {
      if (mounted) {
        await _updateStockData();
      } else {
        timer.cancel();
      }
    });
  }

  Future<void> _updateStockData() async{
    try{
      Map<String,String>data = {};

      if (widget.instrumentKey.contains('OPTIDX')){
        String type = widget.stockName.split(" ")[2];
        List dateList = widget.stockName.split(" ");
        String date = "${dateList[3]}-${dateList[4]}-${dateList[5]}";
        data = await getOptionData.fetchOptionData(widget.stockName.split(" ")[0], type, int.parse(widget.instrumentKey.split("+")[1]),date);
      } else{
         data = await _upstoxService.fetchStockData(widget.instrumentKey, widget.stockName, widget.instrumentKey.split("|")[0]);

      } 
      setState(() {
        widget.livePrice = double.parse(data['currentPrice']!);
        _updatePrice();
      });
    } catch(e){
      debugPrint("Error for Updating stock price $e");
    }
  }
  void _updatePrice() {
    final quantity = int.tryParse(_quantityController.text) ?? 1;
    final totalPrice = widget.livePrice * quantity;
    _priceController.text = totalPrice.toStringAsFixed(2);
  }
  void setQuantity() async {
      
      setState(() {
        _quantityController.text = widget.defaultQuantity;
      });
  }
  void _handleSwipeToSell() {
    // Implement your sell logic here.
    try{
    if (_quantityController.text.isNotEmpty) {
      int quantityToSell = int.tryParse(_quantityController.text)!;
      if (quantityToSell > 0) {
        // Add selling information to the portfolio
        if (watchlist!.amountHave[userId]!.value > double.parse(_priceController.text)){
              if(widget.instrumentKey.split("|")[0] == "NSE_FO"){
                  watchlist!.addProtfolio(userId, widget.stockName,widget.exchangeName,widget.instrumentKey, widget.instrumentType,"Sell", quantityToSell, widget.livePrice, double.parse(_priceController.text), widget.livePrice, 0,double.parse(widget.stockName.split(" ")[1]));
              } else{
                watchlist!.addProtfolio(userId, widget.stockName,widget.exchangeName,widget.instrumentKey, widget.instrumentType,"Sell", quantityToSell, widget.livePrice, double.parse(_priceController.text), widget.livePrice, 0,0);
              }
              watchlist!.decrasePrice(userId, double.parse(_priceController.text));
              Navigator.pop(context);

        } else{
          ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('not enough money have in your wallet',style: TextStyle(color:Color.fromARGB(255, 255, 255, 255)),),backgroundColor: Color.fromARGB(255, 247, 62, 11),));
        }
        // Navigate back to the home screen
      } else {
        // Show an error message for invalid quantity
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Quantity must be greater than zero.',style: TextStyle(color:Color.fromARGB(255, 255, 254, 254)),),backgroundColor: Color.fromARGB(255, 247, 62, 11),));
      }
    } else{
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please Fill The Input Box',style: TextStyle(color:Color.fromARGB(255, 255, 255, 255)),),backgroundColor: Color.fromARGB(255, 247, 62, 11),));
    }
    } catch(e){
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Invalid Value Entered.',style: TextStyle(color:Color.fromARGB(255, 255, 255, 255)),),backgroundColor: Color.fromARGB(255, 247, 62, 11),));
    } 
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(widget.stockName),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: _buildOrderForm(),
            ),
          ),
          _buildSwipeToSellButton(),
        ],
      ),
    );
  }

  Widget _buildOrderForm() {
    return Column(
      children: [
        _buildInputField("Quantity", _quantityController, TextInputType.number),
        _buildInputField("Total Price", _priceController, TextInputType.number, enabled: false),
      ],
    );
  }

  Widget _buildInputField(String label, TextEditingController controller, TextInputType keyboardType, {bool enabled = true}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(),
        ),
        keyboardType: keyboardType,
        enabled: enabled,
      ),
    );
  }

  Widget _buildSwipeToSellButton() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16.0),
      child: SwipeButton.expand(
        activeTrackColor: Colors.red,
        thumb: Icon(Icons.double_arrow, color: Colors.white),
        activeThumbColor: const Color.fromARGB(255, 251, 119, 119),
        onSwipe: _handleSwipeToSell,
        borderRadius: BorderRadius.circular(30.0),
        height: 60.0,
        child: const Text(
          "SWIPE TO SELL",
          style: TextStyle(fontSize: 16, color: Colors.white),
        ),
      ),
    );
  }
}
