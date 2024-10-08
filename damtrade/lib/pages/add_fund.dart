import 'package:flutter/material.dart';
import '../main.dart';
import 'home.dart';

class InputPage extends StatelessWidget {
  final TextEditingController _controller = TextEditingController();

  InputPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Add Funds',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Color(0xFF66BB6A), // A vibrant green color
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFA5D6A7), Color(0xFF66BB6A)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Card(
              elevation: 8,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Text(
                      'Enter Amount',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF388E3C), // Darker green for text
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: _controller,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        labelText: 'Amount',
                        hintText: 'Enter amount',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton(
                      onPressed: () {
                        try{
                          if (_controller.text.isNotEmpty){
                            if (double.tryParse(_controller.text)! > 0.0){
                              double amount = double.tryParse(_controller.text)!;
                              watchlist!.addFund(userId, amount);
                              Navigator.pop(context, true);
                            } else{
                              ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(content: Text('Amount must be greater than zero.',style: TextStyle(color:Color.fromARGB(255, 255, 254, 254)),),backgroundColor: Color(0xFF388E3C),));
                            }
                          } else{
                            ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text("Amount Is Empty!",style: TextStyle(color:Color.fromARGB(255, 255, 254, 254)),),backgroundColor: Color(0xFF388E3C)));
                          }
                        }catch(e){
                           ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Invelid Value Entered.',style: TextStyle(color:Color.fromARGB(255, 255, 254, 254)),),backgroundColor: Color(0xFF388E3C)));
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.transparent,
                        elevation: 0,
                        padding: EdgeInsets.zero,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: Ink(
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [Color(0xFF66BB6A), Color(0xFF43A047)],
                            begin: Alignment.centerLeft,
                            end: Alignment.centerRight,
                          ),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Container(
                          padding: EdgeInsets.symmetric(vertical: 15),
                          alignment: Alignment.center,
                          child: const Text(
                            'Submit',
                            style: TextStyle(fontSize: 18, color: Colors.white),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
