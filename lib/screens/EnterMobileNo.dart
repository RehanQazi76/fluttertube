import 'package:fluttertube/screens/otp.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../widgets/InputField.dart';


class EnterNumber extends StatefulWidget {
  const EnterNumber({super.key});

  @override
  State<EnterNumber> createState() => _EnterNumberState();
}

class _EnterNumberState extends State<EnterNumber> {
  FirebaseAuth auth=FirebaseAuth.instance;
  TextEditingController? number=TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Welcome to the app",
            style: TextStyle(
                  fontSize: 60,
                  fontWeight: FontWeight.w300,
                  
                ),
                textAlign:TextAlign.center,),
            SizedBox(height: 10,),
            InputField(
              InputController: number,
               keyboardtype:TextInputType.phone,
               hintText: "Enter phone Number",
                icon: Icon(Icons.phone),
                ),
            SizedBox(height: 20,),
            ElevatedButton(onPressed: ()async{
              // print(number!.text.toString());
              await FirebaseAuth.instance.verifyPhoneNumber(
                phoneNumber: "+91${number!.text.toString()}",
                verificationCompleted: (PhoneAuthCredential credential) async{
                  // Sign the user in (or link) with the auto-generated credential
                  print("object");
                  await auth.signInWithCredential(credential);
                },
                verificationFailed: (FirebaseAuthException e) {
                  if (e.code == 'invalid-phone-number') {
                    print('The provided phone number is not valid.');
                  }
                },
                codeSent: (String verificationId, int? resendToken) async{
                  // Update the UI - wait for the user to enter the SMS code
                  // String smsCode = 'xxxx';
                  Navigator.push(context, MaterialPageRoute(builder: (context)=>CheckOtp(verficationID: verificationId)));

                  // Create a PhoneAuthCredential with the code
                  
              
                  // Sign the user in (or link) with the credential
                  //
                },
                codeAutoRetrievalTimeout: (String verificationId) {},
              );
            }
            , child: Text("Validate phone number")),
        ]),
      ),
    );
  }
}
