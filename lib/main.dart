import 'package:apitest_app/ui/activities/home.dart';
import 'package:apitest_app/ui/activities/news_details.dart';
import 'package:apitest_app/ui/activities/search.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    systemNavigationBarColor: Colors.white,
  ));
  runApp(Phoenix(
    child: NewsApp(),
  ),);
}

class NewsApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'News App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryTextTheme: TextTheme(
          headline6: TextStyle(
            fontWeight: FontWeight.w400,
            color: Colors.blueGrey[700],
          ),
        ),
        textTheme: TextTheme(
            bodyText2: TextStyle(
              color: Colors.blueGrey[700],
              fontWeight: FontWeight.w400,
            ),
            bodyText1: TextStyle(
              color: Colors.blueGrey[600],
              fontWeight: FontWeight.w300,
            ),
            headline6: TextStyle(
              color: Colors.blueGrey[700],
              fontWeight: FontWeight.bold,
              fontSize: 18,
            )),
        scaffoldBackgroundColor: Colors.white,
        appBarTheme: AppBarTheme(
            color: Colors.white,
            brightness: Brightness.light,
            elevation: 0,
            actionsIconTheme: IconTheme.of(context).copyWith(
              color: Colors.blueGrey[700],
            )),
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      routes: {
        HomePage.id: (context) => HomePage(),
        SearchPage.id: (context) => SearchPage(),
        NewsDetails.id: (context) => NewsDetails(),
      },
      initialRoute: HomePage.id,
    );
  }
}
