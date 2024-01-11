import 'package:fluttertube/screens/Displaydata.dart';
import 'package:fluttertube/screens/uploadData.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  
  final FirebaseFirestore _firestore =FirebaseFirestore.instance;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
      
        mainAxisAlignment: MainAxisAlignment.center,
        children:<Widget> [
        
            SizedBox(height: 30,width: double.infinity,),
          Center(
              child: Text(
                "Welcome to our app",
                style: TextStyle(
                  fontSize: 60,
                  fontWeight: FontWeight.w300,
                  
                ),
                textAlign:TextAlign.center,
              ),
            ),
          SizedBox(height: 30,width: double.infinity,),
          ElevatedButton(onPressed: (){
            Navigator.push(context, MaterialPageRoute(builder: (context)=>VideoDisplayPage()));
          }, child: Text("Lets Get Started"))

        ]),

      
    );
  }
}
