import 'dart:io';

import 'package:apitest_app/models/article_model.dart';
import 'package:apitest_app/models/news_headline_model.dart';
import 'package:apitest_app/ui/components/bottom_title_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:intl/intl.dart';

class NewsDetails extends StatefulWidget {
  static const String id = 'news_details';

  final Articles article;
  final File image;

  const NewsDetails({Key key, this.article, this.image}) : super(key: key);

  @override
  _NewsDetailsState createState() => _NewsDetailsState(this.article);
}

class _NewsDetailsState extends State<NewsDetails> {
  final Articles article;
  String story = '';
  bool full = false;
  String btnText = 'Read More';

  _NewsDetailsState(this.article);

  _dateTimeFormatter() {
    var dateTime = DateTime.parse(article.publishedAt);
    DateFormat format = DateFormat('yyyy-MM-dd At H:m');
    return format.format(dateTime);
  }

  @override
  void initState() {
    story = article.description;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: TextButton(
        onPressed: () {
          if (full) {
            setState(() {
              story = article.description;
              btnText = 'Read More';
              full = false;
            });
          } else {
            setState(() {
              story = article.content;
              btnText = 'Read Less';
              full = true;
            });
          }
        },
        child: Text(
          btnText,
          style: TextStyle(fontSize: 18),
        ),
      ),
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            backgroundColor: Colors.black54,
            brightness: Brightness.dark,
            expandedHeight: MediaQuery.of(context).size.height / 2.8,
            floating: false,
            pinned: true,
            // title: new Text("News Details"),

            flexibleSpace: new FlexibleSpaceBar(
              // title:new Text("home"),
              background: new Stack(
                fit: StackFit.expand,
                children: <Widget>[
                  Hero(
                    tag: article.urlToImage ?? 'default${article.publishedAt}',
                    child: widget.image != null
                        ? Image.file(
                            widget.image,
                            fit: BoxFit.cover,
                          )
                        : Image.asset(
                            'assets/default_news.jpg',
                            fit: BoxFit.cover,
                          ),
                  ),
                  BottomTitle(
                    title: article.title,
                  )
                ],
              ),
            ),
          ),
          SliverList(
              delegate: SliverChildListDelegate([
            Container(
                padding: EdgeInsets.all(16),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        article.source.name ?? 'Internet',
                        style: Theme.of(context).textTheme.headline6,
                      ),
                      SizedBox(height: 4),
                      Text(
                        _dateTimeFormatter() ?? '',
                        style: Theme.of(context).textTheme.bodyText1,
                      ),
                      SizedBox(height: 14),
                      Text(
                        story ?? '',
                        style: Theme.of(context).textTheme.bodyText1,
                      ),
                    ],
                  ),
                )),
          ]))
        ],
      ),
    );
  }
}
