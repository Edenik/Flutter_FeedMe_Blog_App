import 'package:flutter/material.dart';
import 'package:flutter_feedme_app/screens/create_post_screen.dart';
import 'package:flutter_feedme_app/widgets/compose_box_widget.dart';

class FeedScreen extends StatefulWidget {
  @override
  _FeedScreenState createState() => _FeedScreenState();
}

class _FeedScreenState extends State<FeedScreen> {
  _navigateToCreatePostScreen() {
    Navigator.push(context, MaterialPageRoute(builder: (BuildContext ctx) {
      return CreatePostScreen();
    }));
  }

  _getItems() {
    List<Widget> _items = [];
    Widget _composeBox = GestureDetector(
      child: ComposeBox(),
      onTap: _navigateToCreatePostScreen,
    );
    _items.add(_composeBox);
    return _items;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Your Feed'),
        leading: Icon(Icons.rss_feed),
        actions: <Widget>[
          IconButton(icon: Icon(Icons.exit_to_app), onPressed: () {})
        ],
      ),
      body: ListView(
        children: _getItems(),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _navigateToCreatePostScreen,
        child: Icon(Icons.add),
      ),
    );
  }
}
