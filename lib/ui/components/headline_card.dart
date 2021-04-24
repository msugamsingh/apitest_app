import 'dart:io';

import 'package:apitest_app/models/article_model.dart';
import 'package:apitest_app/ui/activities/news_details.dart';
import 'package:apitest_app/ui/components/bottom_title_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:transparent_image/transparent_image.dart';

class NewsHeadlineCard extends StatefulWidget {
  final Articles article;

  const NewsHeadlineCard({Key key, this.article}) : super(key: key);

  @override
  _NewsHeadlineCardState createState() => _NewsHeadlineCardState();
}

class _NewsHeadlineCardState extends State<NewsHeadlineCard> {
  File cachedImage;

  String time() {
    var publishedAt =
        DateTime.parse(widget.article.publishedAt ?? DateTime.now());
    return timeago.format(publishedAt);
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      cachedImage = await DefaultCacheManager()
          .getSingleFile(widget.article.urlToImage ?? '');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: GestureDetector(
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => NewsDetails(
                        article: widget.article,
                        image: cachedImage,
                      )));
        },
        child: Container(
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(
                    color: Colors.blue.shade50,
                    blurRadius: 10,
                    spreadRadius: 4,
                    offset: Offset(2, 4))
              ]),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                      topRight: Radius.circular(24),
                      topLeft: Radius.circular(24)),
                ),
                child: Stack(
                  children: [
                    Center(
                      child: ClipRRect(
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(24),
                            topRight: Radius.circular(24)),
                        child: widget.article.urlToImage != null
                            ? Hero(
                                tag: widget.article.urlToImage ??
                                    'default${widget.article.publishedAt}',
                                child: FadeInImage.memoryNetwork(
                                  placeholder: kTransparentImage,
                                  image: widget.article.urlToImage,
                                  height: 200,
                                  width: double.infinity,
                                  fit: BoxFit.cover,
                                ),
                              )
                            : Hero(
                                tag: 'default${widget.article.publishedAt}',
                                child: Image.asset(
                                  'assets/default_news.jpg',
                                  fit: BoxFit.cover,
                                  width: double.infinity,
                                  height: 200,
                                )),
                      ),
                    ),
                    BottomTitle(title: widget.article.title),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  widget.article.description ?? '',
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.left,
                  style: Theme.of(context).textTheme.bodyText1,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      time(),
                      style: Theme.of(context).textTheme.bodyText2,
                    ),
                    Text(
                      widget.article.source.name ?? "",
                      style: Theme.of(context).textTheme.bodyText2,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
