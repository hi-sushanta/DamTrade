
import 'package:flutter/material.dart';
import 'third.dart';
import 'AuthService.dart';
class SecondScreen extends StatelessWidget {
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
                    Navigator.push(context, MaterialPageRoute(
                      builder: (context) => AuthService().handleAuthState()));
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
                    MaterialPageRoute(builder: (context) => ThirdScreen()),);

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