import 'package:flutter/material.dart';
class InputField extends StatelessWidget {
  const InputField({
    
    required this.InputController,
    this.keyboardtype,
    required this.hintText,
    required this.icon,
  });

  final TextEditingController? InputController;
  final String? hintText;
  final Widget icon;
  final TextInputType? keyboardtype;


  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      
      child: TextField(
        controller:  InputController,
        keyboardType: keyboardtype,
        decoration: InputDecoration(
          hintText: hintText,
          suffixIcon: icon,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(6)
          )
        ),
      ),
    );
  }
}