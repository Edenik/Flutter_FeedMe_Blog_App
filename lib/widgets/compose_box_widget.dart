import 'package:flutter/material.dart';

class ComposeBox extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.blue.withOpacity(0.1),
      padding: const EdgeInsets.only(right: 16.0, top: 6.0, bottom: 12.0),
      margin: const EdgeInsets.only(bottom: 10.0),
      child: Row(
        children: <Widget>[
          Expanded(
            child: Container(
              margin: const EdgeInsets.only(left: 16.0, top: 16.0),
              padding:
                  const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(40.0),
                border: Border.all(width: 1.0, color: Colors.blue),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 10.0),
                child: Text('Write something here ... '),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 15.0, left: 10.0),
            child: Icon(
              Icons.send,
              color: Colors.blue,
            ),
          )
        ],
      ),
    );
  }
}
