import 'dart:convert';

import 'package:apitest_app/models/article_model.dart';
import 'package:apitest_app/models/news_headline_model.dart';
import 'package:apitest_app/network_services/api_response.dart';
import 'package:apitest_app/network_services/network_helper.dart';
import 'package:apitest_app/ui/components/carousel_image_widget.dart';
import 'package:apitest_app/ui/components/no_data_widget.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

class TopHighlightCarousel extends StatefulWidget {
  final String country;

  const TopHighlightCarousel({Key key, this.country}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _TopHighlightCarouselState();
  }
}

class _TopHighlightCarouselState extends State<TopHighlightCarousel> {
  String category = 'Entertainment';
  bool changed = true;
  List<String> imgList = [];

  /// In case we got null image url, this will be the image link
  /// As of now, this is just a random image from Unsplash
  String defaultImageLink =
      'https://images.unsplash.com/photo-1520342868574-5fa380'
      '4e551c?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=6ff92c'
      'affcdd63681a35134a6770ed3b&auto=format&fit=crop&w=1951&q=80';

  Future<ApiResponse> getNewsHeadlinesWithCategory(String cat) {
    NetworkHelper networkHelper = NetworkHelper();
    return networkHelper.getNewsHeadlinesWithCategory(widget.country, cat);
  }

  List addImages(List<Articles> l) {
    imgList.clear();
    for (var i = 0; i < 10; i++) {
      imgList.add(l[i].urlToImage);
    }
    return imgList;
  }

  List convertImagePathsToWidgets(
      List<String> imgList, List<Articles> articles) {
    List imageSliders = imgList.map((item) {
      Articles article = articles[imgList.indexOf(item)];
      return CarouselImageWidget(
        article: article,
        index: imgList.indexOf(item) + 1,
        imageLink: item ?? defaultImageLink,
      );
    }).toList();
    return imageSliders;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            SizedBox(width: 4),
            Container(
              height: 0.5,
              width: 4,
              color: Colors.blueGrey[600],
            ),
            SizedBox(width: 4),
            Text(
              'TOP 10',
              style: Theme.of(context).textTheme.headline6,
            ),
            SizedBox(width: 8),
            Expanded(
              child: Container(
                height: 0.5,
                color: Colors.blueGrey[600],
              ),
            ),
            SizedBox(width: 8),
            PopupMenuButton(
              initialValue: category,
              // icon: Icon(Icons.location_on),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Center(
                    child: Row(
                  children: [
                    Text(
                      category,
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.blueGrey[600],
                      ),
                    ),
                    Icon(
                      Icons.keyboard_arrow_down,
                      color: Colors.blueGrey[600],
                      size: 18,
                    )
                  ],
                )),
              ),
              elevation: 36,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(22),
              ),
              onSelected: (String v) async {
                setState(() {
                  category = v;
                  changed = true;
                });
              },
              itemBuilder: (BuildContext context) {
                return [
                  PopupMenuItem(
                    value: 'Business',
                    child: Text('Business'),
                  ),
                  PopupMenuItem(
                    value: 'Technology',
                    child: Text('Technology'),
                  ),
                  PopupMenuItem(
                    value: 'Entertainment',
                    child: Text('Entertainment'),
                  ),
                ];
              },
            ),
          ],
        ),
        Expanded(
          child: FutureBuilder(
            future: getNewsHeadlinesWithCategory(category),
            builder: (context, snap) {
              if (snap.connectionState == ConnectionState.done &&
                  snap.hasData) {
                ApiResponse apiResponse = snap.data;
                if (apiResponse.apiError == null) {
                  NewsHeadline newsHeadline =
                      NewsHeadline.fromJson(jsonDecode(apiResponse.data));
                  if (newsHeadline.totalResults != 0 &&
                      newsHeadline.status == 'ok') {
                    List<Widget> imageSliders = convertImagePathsToWidgets(
                        addImages(newsHeadline.articles),
                        newsHeadline.articles);

                    return Container(
                        child: Column(
                      children: <Widget>[
                        Expanded(
                          child: CarouselSlider(
                            options: CarouselOptions(
                              autoPlay: true,
                              aspectRatio: 2.0,
                              enlargeCenterPage: true,
                            ),
                            items: imageSliders,
                          ),
                        ),
                      ],
                    ));
                  } else {
                    return NoDataWidget(
                      errorText: '',
                      showTryButton: false,
                    );
                  }
                } else {
                  bool toRebuild = apiResponse.apiError.error ==
                      'Connection Error: Check your network!';
                  return !toRebuild ? NoDataWidget(
                    errorText:
                        'Unexpected Exception: ${apiResponse.apiError.error}',
                    onTryAgain: () {
                      setState(() {});
                    },
                  ) : NoDataWidget(
                    showIcon: false,
                    showNoConnectionAnim: true,
                    rebuild: true,
                  );
                }
              }
              return Center(child: CircularProgressIndicator());
            },
          ),
        ),
      ],
    );
  }
}
