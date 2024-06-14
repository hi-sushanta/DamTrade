import 'package:flutter/material.dart';
import 'package:flutter_swipe_button/flutter_swipe_button.dart';
import 'home.dart';
import 'package:damtrade/main.dart';

class StockSellPage extends StatefulWidget {
  final String stockName;
  final double livePrice;

  StockSellPage({
    required this.stockName,
    required this.livePrice,
  });

  @override
  _StockSellPageState createState() => _StockSellPageState();
}

class _StockSellPageState extends State<StockSellPage> {
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

  void _handleSwipeToSell() {
    // Implement your sell logic here.
    if (_quantityController.text.isNotEmpty) {
      int quantityToSell = int.tryParse(_quantityController.text) ?? 1;
      if (quantityToSell > 0) {
        // Add selling information to the portfolio
        if (watchlist!.amountHave[userId]! > double.parse(_priceController.text)){
              watchlist!.addProtfolio(userId, widget.stockName, "Sell", quantityToSell, widget.livePrice, double.parse(_priceController.text), widget.livePrice, 0);
              watchlist!.decrasePrice(userId, double.parse(_priceController.text));
        } else{
          debugPrint("not enough money have in your wallet");
        }
        // Navigate back to the home screen
        Navigator.pop(context);
      } else {
        // Show an error message for invalid quantity
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Quantity must be greater than zero.')),
        );
      }
    }
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
        child: Text(
          "SWIPE TO SELL",
          style: TextStyle(fontSize: 16, color: Colors.white),
        ),
      ),
    );
  }
}
