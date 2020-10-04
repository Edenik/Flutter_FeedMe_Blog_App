import 'package:flutter/material.dart';

class SnackBarUtil {
  sendSnack(GlobalKey<ScaffoldState> scaffoldKey, String message) {
    scaffoldKey.currentState.removeCurrentSnackBar();
    scaffoldKey.currentState.showSnackBar(
      SnackBar(
        content: Text(message),
      ),
    );
  }
}
