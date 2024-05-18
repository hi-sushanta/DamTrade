import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'pages/second.dart';
import "pages/AuthService.dart";
import 'package:firebase_core/firebase_core.dart';


void main() async {
  // calling of runApp
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

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
            left: 30.0,
            bottom: 30.0, // Adjust spacing as needed
            width: 100,
            height:55.0,
            
            child: 
                ElevatedButton(
                  onPressed: () {
                    // Handle button 1 press
                    Navigator.push(context,
                    MaterialPageRoute(builder: (context) => AuthService().handleAuthState()));
                  },
                  child: const Text(
                    'Skip',
                    style: TextStyle(color:Color.fromARGB(255, 0, 0, 0),
                    fontSize: 16)
                    ),
                   style: ElevatedButton.styleFrom(
                backgroundColor: Color.fromARGB(255, 234, 234, 234), // Set button color
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0)
                )
              ),
                  
                ),
             ), // Add spacing between buttons
             Positioned(
              right:30.0,
              bottom:30.0,
              width: 120.0,
              height: 55.0,
              child:
                ElevatedButton(
                  onPressed: () {
                    // Handle button 2 press
                    Navigator.push(context,
                    MaterialPageRoute(builder: (context) => SecondScreen()));

                  },
                  child: Text(
                    'Next',
                    style: TextStyle(color: Color.fromARGB(225, 255, 255, 255),
                    fontSize: 16)
                    ),
                  style: ElevatedButton.styleFrom(
                  backgroundColor: Color.fromARGB(255, 0, 0, 0), // Set button color
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.0)
                  ),
              ),
                  
                ),

            ),
        ],  
      ),
    );
  }
}

