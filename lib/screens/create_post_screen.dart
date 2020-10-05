import 'dart:io';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:flutter_feedme_app/utils/snackbar_util.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';

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
  File _image;
  final picker = ImagePicker();

  _post() async {
    if (_postTextController.text.trim().length == 0) {
      _snackBarUtil.sendSnack(_key, "Please enter some text.");

      return;
    }

    setState(() {
      _isLoading = true;
    });

    DocumentReference ref;

    try {
      ref = await _firestore.collection("posts").add({
        "text": _postTextController.text.trim(),
        "owner_name": _userDisplayName,
        "owner": _userUID,
        "created": DateTime.now(),
        "likes": {},
        "likes_count": 0,
        "comments_count": 0,
      });

      if (_image != null) {
        _snackBarUtil.sendSnack(_key, "Uploadin image, please wait...");

        String _url = await _uploadImageAndGetURL(ref.id, _image);

        await ref.update({"image": _url});
      }

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

  _showModalBottomSheet() {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext ctx) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              ListTile(
                leading: Icon(Icons.camera_alt),
                title: Text('Camera'),
                onTap: () async {
                  PickedFile image = await picker.getImage(
                    source: ImageSource.camera,
                    maxHeight: 480,
                    maxWidth: 480,
                  );

                  setState(() {
                    _image = File(image.path);
                  });
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: Icon(Icons.photo_album),
                title: Text('Photo Album'),
                onTap: () async {
                  PickedFile image = await picker.getImage(
                    source: ImageSource.gallery,
                    maxHeight: 480,
                    maxWidth: 480,
                  );

                  setState(() {
                    _image = File(image.path);
                  });
                  Navigator.pop(context);
                },
              ),
            ],
          );
        });
  }

  Future<String> _uploadImageAndGetURL(String filenName, File file) async {
    FirebaseStorage _storage = FirebaseStorage.instance;
    StorageUploadTask _task = _storage
        .ref()
        .child(filenName)
        .putFile(file, StorageMetadata(contentType: 'image/png'));

    final _downloadURL = await (await _task.onComplete).ref.getDownloadURL();
    return _downloadURL;
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
                      onPressed: _isLoading
                          ? null
                          : () {
                              _showModalBottomSheet();
                            },
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
            ),
            _image == null
                ? SizedBox.shrink()
                : Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Stack(
                          children: <Widget>[
                            Container(
                              child: Image.file(
                                _image,
                                fit: BoxFit.cover,
                              ),
                              width: 150,
                              height: 150,
                            ),
                            Positioned(
                                top: 4.0,
                                right: 4.0,
                                child: IconButton(
                                    icon: Icon(Icons.close),
                                    color: Colors.white,
                                    onPressed: () {
                                      setState(() {
                                        _image = null;
                                      });
                                    })),
                          ],
                        ),
                      ],
                    ),
                  )
          ],
        ),
      ),
    );
  }
}
