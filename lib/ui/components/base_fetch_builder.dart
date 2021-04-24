import 'dart:convert';

import 'package:apitest_app/models/news_headline_model.dart';
import 'package:apitest_app/network_services/api_response.dart';
import 'package:apitest_app/ui/components/no_data_widget.dart';
import 'package:flutter/material.dart';

import 'headline_card.dart';

class BaseFetchBuilder extends StatelessWidget {
  final Future<ApiResponse> future;
  final VoidCallback onTryAgain;

  const BaseFetchBuilder({Key key, this.future, this.onTryAgain})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: future,
      builder: (context, snap) {
        if (snap.connectionState == ConnectionState.done && snap.hasData) {
          ApiResponse apiResponse = snap.data;
          if (apiResponse.apiError == null) {
            NewsHeadline headlines =
                NewsHeadline.fromJson(jsonDecode(apiResponse.data));
            if (headlines.totalResults != 0 && headlines.status == 'ok') {
              return ListView.builder(
                  itemCount: headlines.articles.length,
                  itemBuilder: (context, i) {
                    return NewsHeadlineCard(
                      article: headlines.articles[i],
                    );
                  });
            } else {
              return NoDataWidget(
                errorText: '',
                showTryButton: false,
              );
            }
          } else {
            bool toRebuild = apiResponse.apiError.error ==
                'Connection Error: Check your network!';
            return NoDataWidget(
              errorText: '${apiResponse.apiError.error}',
              rebuild: toRebuild,
              onTryAgain: onTryAgain,
            );
          }
        }
        return Center(child: CircularProgressIndicator());
      },
    );
  }
}
