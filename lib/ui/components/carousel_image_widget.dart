import 'dart:io';

import 'package:apitest_app/models/article_model.dart';
import 'package:apitest_app/models/news_headline_model.dart';
import 'package:apitest_app/ui/activities/news_details.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';

class CarouselImageWidget extends StatefulWidget {
  final Articles article;
  final int index;
  final String imageLink;

  const CarouselImageWidget({Key key, this.article, this.index, this.imageLink})
      : super(key: key);

  @override
  _CarouselImageWidgetState createState() =>
      _CarouselImageWidgetState(this.article);
}

class _CarouselImageWidgetState extends State<CarouselImageWidget> {
  final Articles article;
  File cachedImage;

  _CarouselImageWidgetState(this.article);

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
    return Container(
      child: GestureDetector(
        onTap: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) {
            return NewsDetails(
              article: article,
              image: cachedImage,
            );
          }));
        },
        child: Container(
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                  color: Colors.blueGrey.shade300,
                  blurRadius: 14,
                  offset: Offset(2, 4))
            ],
          ),
          margin: EdgeInsets.all(5.0),
          child: ClipRRect(
              borderRadius: BorderRadius.all(Radius.circular(15.0)),
              child: Stack(
                children: <Widget>[
                  Image.network(
                    widget.imageLink,
                    fit: BoxFit.cover,
                    height: 200,
                    width: 1000.0,
                    filterQuality: FilterQuality.low,
                  ),
                  Positioned.fill(
                      child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Align(
                      alignment: Alignment.topLeft,
                      child: Container(
                        padding: EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.black54,
                        ),
                        child: Text(
                          (widget.index).toString(),
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  )),
                  Positioned(
                    bottom: 0.0,
                    left: 0.0,
                    right: 0.0,
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Color.fromARGB(200, 0, 0, 0),
                            Color.fromARGB(100, 0, 0, 0),
                            Color.fromARGB(0, 0, 0, 0)
                          ],
                          begin: Alignment.bottomCenter,
                          end: Alignment.topCenter,
                        ),
                      ),
                      padding: EdgeInsets.symmetric(
                          vertical: 10.0, horizontal: 20.0),
                      child: Text(
                        article.title ?? "",
                        maxLines: 2,
                        textAlign: TextAlign.start,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              )),
        ),
      ),
    );
  }
}
