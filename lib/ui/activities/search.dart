import 'package:apitest_app/network_services/api_response.dart';
import 'package:apitest_app/network_services/network_helper.dart';
import 'package:apitest_app/ui/components/base_fetch_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class SearchPage extends StatefulWidget {
  static const String id = 'search_news';

  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  TextEditingController _searchController = TextEditingController();
  Future<ApiResponse> _searchResult;

  Widget searchWidget() {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
            color: Colors.grey.shade200,
            borderRadius: BorderRadius.circular(18),
            boxShadow: [
              BoxShadow(
                color: Colors.blueGrey.shade200,
                offset: Offset(4, 0),
                blurRadius: 14,
              )
            ]),
        child: ListTile(
          leading: IconButton(
            icon: Icon(Icons.arrow_back_outlined),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          title: TextFormField(
            autovalidateMode: AutovalidateMode.onUserInteraction,
            controller: _searchController,
            // onFieldSubmitted: (v) {
            //   if (v.trim().isNotEmpty) handleSearch(v);
            // },
            onChanged: (val) {
              if (val.trim().isNotEmpty) handleSearch(val);
            },
            validator: (v) {
              if (v.trim().isEmpty) {
                return 'Can not search empty query';
              }
              return null;
            },
            onSaved: handleSearch,
            keyboardType: TextInputType.url,
            decoration: InputDecoration(
              border: InputBorder.none,
              hintText: 'Search for news, topic...',
              hintStyle: Theme.of(context).textTheme.bodyText2,
            ),
          ),
          trailing: IconButton(
            icon: Icon(
              Icons.clear,
            ),
            onPressed: () {
              WidgetsBinding.instance
                  .addPostFrameCallback((_) => _searchController.clear());
            },
          ),
        ),
      ),
    );
  }

  handleSearch(v) {
    NetworkHelper networkHelper = NetworkHelper();
    Future<ApiResponse> query = networkHelper.searchNews(v);
    setState(() {
      _searchResult = query;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          SizedBox(height: 30),
          searchWidget(),
          _searchResult != null
              ? Expanded(
                  child: Container(
                      child: BaseFetchBuilder(
                    future: _searchResult,
                    onTryAgain: () {
                      setState(() {});
                    },
                  )),
                )
              : Container(),
        ],
      ),
    );
  }
}
