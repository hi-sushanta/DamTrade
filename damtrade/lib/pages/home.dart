
import 'package:flutter/material.dart';


void main() => runApp(const Home());

class Home extends StatelessWidget {
  const Home({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MyHomePage(), // Replace with your actual class name
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
    //String? user = FirebaseAuth.instance.currentUser!.email ?? FirebaseAuth.instance.currentUser!.displayName;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Option 2: Setting Image height to full (with aspect ratio)
          Image.asset(
            'assets/sushanta.jpeg',
            fit: BoxFit.cover,
            height: double.infinity,
            width: double.infinity
          ),
          // Container for buttons with positioning
            Positioned(
                  child:Container(
                    margin:const EdgeInsets.only(bottom:20.0),
                  child: Align(
                    alignment: Alignment.bottomCenter,
                    widthFactor: 50.0,
                    child: ElevatedButton(
                      onPressed: () {
                    // Handle button 1 press
                     

                    },
                  child: const Text(
                    'Next',
                    style: TextStyle(color:Color.fromARGB(255, 0, 0, 0),
                    fontSize: 16)
                    ),

                   style: ElevatedButton.styleFrom(
                    fixedSize: Size(120.0, 55.0),
                backgroundColor: Color.fromARGB(255, 234, 234, 234), // Set button color
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0),
                ),
                ),
                  
                ),
                  ),
                  ),
            )
                
        ],  
      ),
    );
  }
}

