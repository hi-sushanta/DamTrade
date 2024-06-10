import 'package:damtrade/main.dart';
import 'package:damtrade/pages/home.dart';
import 'package:flutter/material.dart';
import 'package:flutter_swipe_button/flutter_swipe_button.dart';

class StockBuyPage extends StatefulWidget {
  final String stockName;
  final double livePrice;

  StockBuyPage({
    required this.stockName,
    required this.livePrice,
  });

  @override
  _StockBuyPageState createState() => _StockBuyPageState();
}

class _StockBuyPageState extends State<StockBuyPage> {
  
  final TextEditingController _quantityController = TextEditingController(text: '1');
  final TextEditingController _priceController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _updatePrice();
    _quantityController.addListener(_updatePrice);
  }

  @override
  void dispose() {
    _quantityController.dispose();
    _priceController.dispose();
    super.dispose();
  }

  void _updatePrice() {
    final quantity = int.tryParse(_quantityController.text) ?? 1;
    final totalPrice = widget.livePrice * quantity;
    _priceController.text = totalPrice.toStringAsFixed(2);
  }

  void _handleSwipeToBuy() {
    // Implement your buy logic here.
    // For example, show a confirmation dialog or process the order.
    // Navigate back to the home screen.
    if (_quantityController.text.isNotEmpty){
      if (int.tryParse(_quantityController.text)! > 0){
        watchlist!.addProtfolio(userId, widget.stockName, int.tryParse(_quantityController.text)!, 10.15, 71.05,8.90,1.14,-8.75);
      }
    }
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
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
          _buildSwipeToBuyButton(),
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

  Widget _buildSwipeToBuyButton() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16.0),
      child: SwipeButton.expand(
        activeTrackColor: Colors.blue,
        thumb: Icon(Icons.double_arrow, color: Colors.white),
        activeThumbColor: const Color.fromARGB(255, 119, 251, 124),
        onSwipe: _handleSwipeToBuy,
        borderRadius: BorderRadius.circular(30.0),
        height: 60.0,
        child: Text(
          "SWIPE TO BUY",
          style: TextStyle(fontSize: 16, color: Colors.white),
        ),
      ),
    );
  }
}
