import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:flutter/material.dart';
import 'package:flutter_feedme_app/utils/snackbar_util.dart';
import 'package:flutter_feedme_app/widgets/auth_flat_button_widget.dart';
import 'package:flutter_feedme_app/widgets/auth_text_input_widget.dart';

class SignupScreen extends StatefulWidget {
  @override
  _SignupScreenState createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  TextEditingController _nameController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _passwordConfirmController = TextEditingController();
  SnackBarUtil _snackBarUtil = SnackBarUtil();
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  auth.FirebaseAuth _firebaseAuth = auth.FirebaseAuth.instance;
  bool _isLoading = false;

  _signup() async {
    if (_passwordConfirmController.text.trim() !=
        _passwordController.text.trim()) {
      _snackBarUtil.sendSnack(_scaffoldKey, 'Passwords do not match!');
      return;
    }

    _snackBarUtil.sendSnack(_scaffoldKey, 'Creating your account...');
    setState(() {
      _isLoading = true;
    });
    try {
      auth.UserCredential _user =
          await _firebaseAuth.createUserWithEmailAndPassword(
              email: _emailController.text.trim(),
              password: _passwordController.text.trim());

      await _user.user.updateProfile(displayName: _nameController.text.trim());

      _snackBarUtil.sendSnack(
          _scaffoldKey, 'Your account has been created successfully.');
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
              size: 60.0,
              color: Colors.white,
            ),
          ),
          AuthTextInput(
            controller: _nameController,
            icon: Icons.person,
            hintText: "Enter your name",
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
          AuthTextInput(
            controller: _passwordConfirmController,
            icon: Icons.lock_open,
            hintText: "Re-enter your password",
            obscureText: true,
          ),
          AuthFlatButton(
            text: 'SIGNUP',
            onPressed: _isLoading == true
                ? null
                : () {
                    _signup();
                  },
            isLoading: _isLoading,
            mainButton: true,
          ),
          AuthFlatButton(
            text: 'Already have an Account? Login here.',
            onPressed: () => Navigator.of(context).pop(),
            isLoading: _isLoading,
            mainButton: false,
          ),
        ],
      )),
    );
  }
}
