import 'package:fluttertube/screens/landingPage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:video_player/video_player.dart';

class CheckOtp extends StatefulWidget {
  const CheckOtp({required this.verficationID});
  final String verficationID;

  @override
  State<CheckOtp> createState() => _CheckOtpState(verficationID);
}

class _CheckOtpState extends State<CheckOtp> {
  _CheckOtpState(this.verficationID);
  TextEditingController? otp=TextEditingController();
  FirebaseAuth auth=FirebaseAuth.instance;
  final String verficationID;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
                      Padding(
                padding: const EdgeInsets.all(10.0),
                child: TextField(
                  controller:  otp,
                  keyboardType: TextInputType.phone,
                  decoration: InputDecoration(
                    hintText: "Enter the OTP ",
                    suffixIcon: Icon(Icons.phone),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(6)
                    )
                  ),
                ),
              ),
              SizedBox(height: 20,),
              ElevatedButton(onPressed: () async{
                try{
                  PhoneAuthCredential credential = PhoneAuthProvider.credential(
                    verificationId: verficationID, 
                    smsCode: otp!.text.toString() );
    
                   await auth.signInWithCredential(credential).then((value){
                    Navigator.push(context, MaterialPageRoute(builder:(context)=> HomePage()));
                   });
                }catch(e){
    
                }
              }
              , child: Text("Submit")),
        ],
      ),
    );
  }
}