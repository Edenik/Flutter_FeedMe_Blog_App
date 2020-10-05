import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:flutter_feedme_app/utils/snackbar_util.dart';

class CreatePostScreen extends StatefulWidget {
  @override
  _CreatePostScreenState createState() => _CreatePostScreenState();
}

class _CreatePostScreenState extends State<CreatePostScreen> {
  TextEditingController _postTextController = TextEditingController(text: '');
  GlobalKey<ScaffoldState> _key = GlobalKey<ScaffoldState>();
  SnackBarUtil _snackBarUtil = SnackBarUtil();
  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  auth.FirebaseAuth _firebaseAuth = auth.FirebaseAuth.instance;
  String _userUID;
  String _userDisplayName;
  bool _isLoading = false;

  _post() async {
    if (_postTextController.text.trim().length == 0) {
      _snackBarUtil.sendSnack(_key, "Please enter some text.");

      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      await _firestore.collection("posts").add({
        "text": _postTextController.text.trim(),
        "owner_name": _userDisplayName,
        "owner": _userUID,
        "created": DateTime.now(),
        "likes": {},
        "likes_count": 0,
        "comments_count": 0,
      });
      _snackBarUtil.sendSnack(_key, "Post created successfully.");

      Future.delayed(Duration(seconds: 1), () {
        Navigator.pop(context);
      });
    } catch (error) {
      print(error);
      _snackBarUtil.sendSnack(_key, error.toString());
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();

    _userUID = _firebaseAuth.currentUser.uid;
    _userDisplayName = _firebaseAuth.currentUser.displayName;
    print('$_userUID  $_userDisplayName');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _key,
      appBar: AppBar(
        title: Text('Compose New Post'),
      ),
      body: Container(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: <Widget>[
            Container(
              padding: const EdgeInsets.all(8.0),
              decoration: BoxDecoration(
                  border: Border.all(
                color: Colors.blue.withOpacity(0.2),
              )),
              child: TextField(
                controller: _postTextController,
                maxLines: 5,
                maxLength: 300,
                decoration: InputDecoration(
                  hintText: 'Write something here...',
                  border: InputBorder.none,
                ),
              ),
            ),
            Row(
              children: <Widget>[
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: FlatButton(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30.0)),
                      splashColor: Colors.blue,
                      color: Colors.blue,
                      disabledColor: Colors.blue.withOpacity(0.5),
                      onPressed: _isLoading ? null : () {},
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 8.0, horizontal: 8.0),
                            child: Text(
                              'Add Image',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                          Icon(
                            Icons.add_photo_alternate,
                            color: Colors.white,
                            size: 16.0,
                          )
                        ],
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: FlatButton(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30.0)),
                      splashColor: Colors.blue,
                      color: Colors.blue,
                      disabledColor: Colors.blue.withOpacity(0.5),
                      onPressed: _isLoading
                          ? null
                          : () {
                              _post();
                            },
                      child: _isLoading
                          ? Container(
                              height: 20.0,
                              width: 20.0,
                              child: CircularProgressIndicator(
                                strokeWidth: 2.0,
                                backgroundColor: Colors.white,
                              ),
                            )
                          : Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 8.0, horizontal: 8.0),
                                  child: Text(
                                    'Create Post',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                                Icon(
                                  Icons.send,
                                  color: Colors.white,
                                  size: 16.0,
                                )
                              ],
                            ),
                    ),
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
