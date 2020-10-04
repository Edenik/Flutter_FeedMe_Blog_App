import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';

class AuthFlatButton extends StatelessWidget {
  final bool isLoading;
  final Function onPressed;
  final bool mainButton;
  final String text;

  AuthFlatButton({
    @required this.text,
    @required this.isLoading,
    @required this.onPressed,
    @required this.mainButton,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 20.0),
      padding: const EdgeInsets.only(left: 20.0, right: 20.0),
      child: Row(
        children: <Widget>[
          Expanded(
            child: FlatButton(
              splashColor: Colors.white,
              color: mainButton ? Colors.white : Colors.blue,
              disabledColor: Colors.white.withOpacity(0.5),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30.0)),
              onPressed: onPressed,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  isLoading && mainButton
                      ? Padding(
                          padding: const EdgeInsets.symmetric(vertical: 6.0),
                          child: CircularProgressIndicator())
                      : Expanded(
                          child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 16.0),
                          child: Text(
                            text,
                            style: TextStyle(
                                color: mainButton ? Colors.blue : Colors.white),
                            textAlign: TextAlign.center,
                          ),
                        ))
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
