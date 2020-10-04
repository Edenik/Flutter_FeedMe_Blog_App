import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';

class AuthTextInput extends StatelessWidget {
  final TextEditingController controller;
  final bool obscureText;
  final String hintText;
  final IconData icon;
  AuthTextInput(
      {@required this.controller,
      @required this.hintText,
      @required this.icon,
      this.obscureText = false});
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
      padding: const EdgeInsets.all(4.0),
      decoration: BoxDecoration(
          border: Border.all(color: Colors.white.withOpacity(0.5), width: 1.0),
          borderRadius: BorderRadius.circular(20.0)),
      child: Row(
        children: <Widget>[
          Padding(
            padding:
                const EdgeInsets.symmetric(vertical: 10.0, horizontal: 15.0),
            child: Icon(
              icon,
              color: Colors.white,
            ),
          ),
          Container(
            height: 30.0,
            width: 1.0,
            color: Colors.white.withOpacity(0.5),
            margin: const EdgeInsets.only(right: 10.0),
          ),
          Expanded(
            child: TextFormField(
              controller: controller,
              obscureText: obscureText,
              style: TextStyle(color: Colors.white),
              decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: hintText,
                  hintStyle: TextStyle(
                    color: Colors.white.withOpacity(0.5),
                  )),
            ),
          ),
        ],
      ),
    );
  }
}
