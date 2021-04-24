import 'package:apitest_app/network_services/api_response.dart';
import 'package:apitest_app/network_services/network_helper.dart';
import 'package:apitest_app/ui/activities/search.dart';
import 'package:apitest_app/ui/components/base_fetch_builder.dart';
import 'package:apitest_app/ui/components/custom_icon.dart';
import 'package:apitest_app/ui/components/drawer.dart';
import 'package:apitest_app/ui/components/highlight_carousel.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class HomePage extends StatefulWidget {
  static const String id = 'home';

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String country = 'in';
  String flag = '🇮🇳';
  bool _filtered = false;

  // List sourceIDs = ['google-news',"the-times-of-india",'usa-today', 'cnn', 'the-washington-post','cbs-news'];
  Map sourceIDs = {
    'google-news': 'Google News',
    'the-times-of-india': 'The Times of India',
    'usa-today': 'USA Today',
    'cnn': 'CNN',
    'the-washington-post': 'The Washington Post',
    'cbs-news': 'CBS News',
  };
  Map selectedSourceIDs = {};

  Future<ApiResponse> getHeadlines(String country) {
    NetworkHelper networkHelper = NetworkHelper();
    return networkHelper.getNewsHeadlines(country);
  }

  Future<ApiResponse> getNewsFromSources(List l) {
    NetworkHelper networkHelper = NetworkHelper();
    return networkHelper.getNewsFromSources(l);
  }

  setFlag(country) {
    switch (country) {
      case 'in':
        setState(() => flag = '🇮🇳');
        break;
      case 'us':
        setState(() => flag = '🇺🇸');
        break;
      case 'uk':
        setState(() => flag = '🇬🇧');
        break;
    }
  }

  bottomModalSheet() {
    showModalBottomSheet(
        elevation: 28,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        )),
        context: context,
        builder: (context) {
          Map localMap = Map.from(selectedSourceIDs);
          return StatefulBuilder(
            builder: (context, setModalState) => Container(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 8),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 8.0, horizontal: 14),
                      child: Text(
                        'Filter by Source',
                        style: Theme.of(context).textTheme.headline6,
                      ),
                    ),
                    Divider(
                      indent: 14,
                      endIndent: 24,
                      thickness: 0.5,
                      color: Colors.blueGrey,
                    ),
                    Column(
                      children: sourceIDs.keys.map((key) {
                        return CheckboxListTile(
                          title: Text(sourceIDs[key]),
                          value: localMap.containsKey(key),
                          onChanged: (v) {
                            setModalState(() {
                              localMap.containsKey(key)
                                  ? localMap.remove(key)
                                  : localMap[key] = true;
                            });
                          },
                        );
                      }).toList(),
                    ),
                    SizedBox(
                      width: double.infinity,
                      child: Center(
                        child: OutlinedButton(
                          onPressed: () {
                            setState(() {
                              selectedSourceIDs = localMap;
                              _filtered = true;
                            });
                            print('Selected');
                            print(selectedSourceIDs);
                            print(localMap);
                            Navigator.pop(context);
                          },
                          child: Text('Apply Filter'),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 32,
                    ),
                  ],
                ),
              ),
            ),
          );
        });
  }

  final k = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        key: k,
        drawer: MyDrawer(),
          floatingActionButton: FloatingActionButton(
            child: Icon(Icons.filter_list_alt),
            onPressed: () {
              bottomModalSheet();
            },
          ),
          appBar: AppBar(
            leading: IconButton(
              icon: Icon(
                CustomIcons.menu,
                color: Colors.blueGrey[700],
              ),
              onPressed: () {
                k.currentState.openDrawer();
              },
            ),
            title: Text('News'),
            actions: [
              IconButton(
                  icon: Icon(Icons.search),
                  onPressed: () {
                    Navigator.pushNamed(context, SearchPage.id);
                  }),
              PopupMenuButton(
                initialValue: country,
                // icon: Icon(Icons.location_on),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Center(
                      child: Row(
                    children: [
                      Text(flag),
                      Icon(
                        Icons.keyboard_arrow_down,
                        color: Colors.blueGrey[700],
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
                    country = v;
                    setFlag(v);
                  });
                },
                itemBuilder: (BuildContext context) {
                  return [
                    PopupMenuItem(
                      value: 'in',
                      child: Text('🇮🇳 India'),
                    ),
                    PopupMenuItem(
                      value: 'us',
                      child: Text('🇺🇸 USA'),
                    ),
                    PopupMenuItem(
                      value: 'gb',
                      child: Text('🇬🇧 UK'),
                    ),
                  ];
                },
              ),
            ],
          ),
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                  height: 280,
                  child: TopHighlightCarousel(
                    country: country,
                  )),
              Padding(
                padding: const EdgeInsets.only(left: 12.0, bottom: 8),
                child: Text(
                  'TOP HEADLINES',
                  style: Theme.of(context).textTheme.headline6,
                ),
              ),
              Expanded(
                child: Container(
                  child: _filtered && selectedSourceIDs.length != 0
                      ? BaseFetchBuilder(
                          future: getNewsFromSources(
                              selectedSourceIDs.keys.toList()),
                          onTryAgain: () {
                            setState(() {});
                          },
                        )
                      : BaseFetchBuilder(
                          future: getHeadlines(country),
                          onTryAgain: () {
                            setState(() {});
                          },
                        ),
                ),
              ),
            ],
          )),
    );
  }

  Future<bool> _onWillPop() {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
          title: Text(
            'Do you want to exit?',
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: new Text(
                'No',
              ),
            ),
            TextButton(
              onPressed: () {
                SystemNavigator.pop(animated: true);
              },
              child: Text('Yes'),
            ),
          ],
        );
      },
    );
  }
}
