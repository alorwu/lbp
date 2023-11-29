import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';
import 'package:webfeed/domain/rss_feed.dart';

class RssFeedScreen extends StatefulWidget {
  @override
  RssFeedState createState() => RssFeedState();
}

class RssFeedState extends State<RssFeedScreen> {
  static const FEED_URL = "https://zapier.com/engine/rss/714473/lbp-cc"; //"https://hnrss.org/jobs";
  RssFeed? _feed;

  GlobalKey<RefreshIndicatorState>? _refreshKey;

  updateFeed(feed) {
    setState(() {
      _feed = feed;
    });
  }

  Future<void> openFeed(String url) async {
    if (await canLaunch(url)) {
      await launch(
        url,
        forceSafariVC: false,
        forceWebView: false,
      );
      return;
    }
  }

  load() async {
    loadFeed().then((result) {
      if (null == result || result.toString().isEmpty) return;
      updateFeed(result);
    });
  }

  Future<RssFeed> loadFeed() async {
    try {
      final client = http.Client();
      final response = await client.get(Uri.parse(FEED_URL));
      print(response.body);
      return RssFeed.parse(response.body);
    } catch (e) {
      throw e;
    }
  }

  @override
  void initState() {
    super.initState();
    _refreshKey = GlobalKey<RefreshIndicatorState>();
    load();
  }

  isFeedEmpty() {
    return null == _feed || null == _feed!.items;
  }

  body() {
    return isFeedEmpty()
        ? Center(
            child: CircularProgressIndicator(color: Colors.black),
          )
        : RefreshIndicator(
            child: list(), onRefresh: () => load(), key: _refreshKey);
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: AppBar(
        title: Text('Online information'),
        backgroundColor: Colors.black,
        // systemOverlayStyle: SystemUiOverlayStyle.dark,
        brightness: Brightness.dark,
      ),
      body: body(),
    );
  }

  list() {
    return Padding(
      padding: EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Expanded(
            flex: 3,
            child: Container(
              child: ListView.separated(
                itemCount: _feed!.items!.length,
                itemBuilder: (BuildContext context, int index) {
                  final item = _feed!.items![index];
                  return Container(
                    child: ListTile(
                      title: title(item.title),
                      subtitle: subtitle(item.description),
                      trailing: rightIcon(),
                      contentPadding: EdgeInsets.all(10.0),
                      onTap: () => openFeed(item.link!),
                    ),
                  );
                },
                separatorBuilder: (BuildContext context, int index) {
                  return Divider();
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  title(title) {
    return Text(
      title,
      style: TextStyle(
        fontSize: 16.0,
        fontWeight: FontWeight.w500,
      ),
      // maxLines: 3,
      overflow: TextOverflow.clip,
    );
  }

  subtitle(subtitle) {
    return Text(
      subtitle,
      style: TextStyle(fontSize: 15.0),
      maxLines: 3,
      overflow: TextOverflow.ellipsis,
    );
  }

  rightIcon() {
    return Icon(
      Icons.keyboard_arrow_right,
      color: Colors.grey,
      size: 30.0,
    );
  }

}
