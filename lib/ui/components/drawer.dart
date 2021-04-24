import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:koukicons/profile2.dart';

class MyDrawer extends StatelessWidget {
  @override
  Drawer build(BuildContext context) {
    return Drawer(
      elevation: 24,
      child: Container(
        height: MediaQuery.of(context).size.height,
        child: Column(
          children: <Widget>[
            UserAccountsDrawerHeader(
              accountName: Text('Sugam Singh',
                  style: TextStyle( fontSize: 18)),
              accountEmail:
              Text('singhsugam065@gmail.com'),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(24),
                    bottomRight: Radius.circular(24),
                  ),
                  image: DecorationImage(
                    image: AssetImage('assets/default_news.jpg'),
                    fit: BoxFit.cover,
                    colorFilter: ColorFilter.mode(Colors.black54, BlendMode.darken),
                  )),
              currentAccountPicture: CircleAvatar(
                child: KoukiconsProfile2(),
                backgroundColor: Colors.transparent,
              ),
            ),
            SizedBox(height: 12),
            Text('News App', style: Theme.of(context).textTheme.headline6,),
            SizedBox(height: 4),
            Text('v1.0.0', style: Theme.of(context).textTheme.bodyText2),
            Spacer(),
            Text('Made with ❤️ by Sugam Singh', style: Theme.of(context).textTheme.headline6, ),
            SizedBox(height: 28),
          ],
        ),
      ),
    );
  }

}