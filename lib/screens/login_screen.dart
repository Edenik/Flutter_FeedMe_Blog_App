import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:flutter/material.dart';
import 'package:flutter_feedme_app/screens/feed_screen.dart';
import 'package:flutter_feedme_app/screens/signup_screen.dart';
import 'package:flutter_feedme_app/utils/snackbar_util.dart';
import 'package:flutter_feedme_app/widgets/auth_flat_button_widget.dart';
import 'package:flutter_feedme_app/widgets/auth_text_input_widget.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  SnackBarUtil _snackBarUtil = SnackBarUtil();
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  auth.FirebaseAuth _firebaseAuth = auth.FirebaseAuth.instance;

  bool _isLoading = false;

  _login() async {
    setState(() {
      _isLoading = true;
    });

    _snackBarUtil.sendSnack(_scaffoldKey, "Logging you in...");

    try {
      auth.UserCredential _user =
          await _firebaseAuth.signInWithEmailAndPassword(
              email: _emailController.text.trim(),
              password: _passwordController.text.trim());

      _snackBarUtil.sendSnack(_scaffoldKey, "Login Successful.");
      Navigator.push(context, MaterialPageRoute(builder: (ctx) {
        return FeedScreen();
      }));
      // print(_user.toString());
    } catch (error) {
      _snackBarUtil.sendSnack(
          _scaffoldKey, (error as auth.FirebaseException).message);
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Theme.of(context).primaryColor,
      body: Form(
          child: ListView(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(top: 72.0, bottom: 36.0),
            child: Icon(
              Icons.rss_feed,
              size: 180.0,
              color: Colors.white,
            ),
          ),
          AuthTextInput(
            controller: _emailController,
            icon: Icons.alternate_email,
            hintText: "Enter your email",
          ),
          AuthTextInput(
            controller: _passwordController,
            icon: Icons.lock_open,
            hintText: "Enter your password",
            obscureText: true,
          ),
          AuthFlatButton(
            text: 'LOGIN',
            onPressed: _isLoading == true
                ? null
                : () {
                    _login();
                  },
            isLoading: _isLoading,
            mainButton: true,
          ),
          AuthFlatButton(
            text: 'Don\'t have an Account? Create One.',
            onPressed: () => Navigator.of(context)
                .push(MaterialPageRoute(builder: (BuildContext ctx) {
              return SignupScreen();
            })),
            isLoading: _isLoading,
            mainButton: false,
          ),
        ],
      )),
    );
  }
}
