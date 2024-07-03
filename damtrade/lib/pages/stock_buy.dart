import 'package:damtrade/main.dart';
import 'package:damtrade/pages/home.dart';
import 'package:damtrade/pages/json_service.dart';
import 'package:damtrade/pages/stock_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_swipe_button/flutter_swipe_button.dart';

class StockBuyPage extends StatefulWidget {
  final String stockName;
  final double livePrice;
  final String exchangeName;
  final String instrumentKey;
  StockBuyPage({
    required this.stockName,
    required this.exchangeName,
    required this.livePrice,
    required this.instrumentKey
  });

  @override
  _StockBuyPageState createState() => _StockBuyPageState();
}

class _StockBuyPageState extends State<StockBuyPage> {
  final TextEditingController _quantityController = TextEditingController(text: '1');
  final TextEditingController _priceController = TextEditingController();
  final UpstoxService _upstoxService = UpstoxService(JsonService());


  @override
  void initState() {
    super.initState();
    setQuantity();
    _updatePrice();
    _quantityController.addListener(_updatePrice);
  }

  void setQuantity() async {
        Map<String,String> data = await _upstoxService.fetchStockData(widget.instrumentKey, widget.stockName, widget.instrumentKey.split("|")[0]);
      
      setState(() {
        _quantityController.text = (widget.instrumentKey.split("|")[0] == "NSE_EQ") ? '1' : "${data['defaultQuanity']}";
      });
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
    try{
      if ((_quantityController.text.isNotEmpty)){
        if (int.tryParse(_quantityController.text)! > 0){
            
            if (watchlist!.amountHave[userId]!.value > double.parse(_priceController.text)){

                watchlist!.addProtfolio(userId, widget.stockName,widget.exchangeName,widget.instrumentKey,"Buy", int.tryParse(_quantityController.text)!, widget.livePrice, double.parse(_priceController.text)
                                        ,widget.livePrice,0);
                watchlist!.decrasePrice(userId, double.parse(_priceController.text));
                Navigator.pop(context);

            } else{
              ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Not Enough Money Have In Your Wallet!',style: TextStyle(color:Colors.black),),backgroundColor: Color.fromARGB(255, 165, 247, 24),),
              );
            }
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Quantity must be greater than zero.',style: TextStyle(color:Colors.black),),backgroundColor: Color.fromARGB(255, 165, 247, 24),),
        );
        }
      } else{
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Please Fill The Input Box",style: TextStyle(color:Colors.black),),backgroundColor: Color.fromARGB(255, 165, 247, 24),),
        );
      }

    } catch(e){
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Invalid Value Entered.',style: TextStyle(color:Colors.black),),backgroundColor: Color.fromARGB(255, 165, 247, 24),),
        );
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
