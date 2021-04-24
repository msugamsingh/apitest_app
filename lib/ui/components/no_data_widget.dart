import 'package:flutter/material.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:koukicons/doNotMix.dart';

class NoDataWidget extends StatelessWidget {
  final String errorText;
  final bool rebuild;
  final VoidCallback onTryAgain;
  final bool showTryButton;
  final bool showIcon;
  final bool showNoConnectionAnim;

  const NoDataWidget(
      {Key key,
      this.errorText = '',
      this.rebuild = false,
      this.showIcon = true,
      this.onTryAgain,
      this.showTryButton = true,
      this.showNoConnectionAnim = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        height: 300,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              showIcon ? KoukiconsDoNotMix() : SizedBox(),
              SizedBox(height: 8, width: double.infinity),
              showIcon
                  ? Text(
                      'No Data Available! ',
                      style: Theme.of(context).textTheme.headline6,
                    )
                  : SizedBox(),
              showNoConnectionAnim
                  ? Container(
                      height: 180,
                      width: 180,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(24),
                          boxShadow: [
                            BoxShadow(
                                color: Colors.blue.shade200,
                                blurRadius: 14,
                                offset: Offset(4, 4))
                          ],
                          image: DecorationImage(
                              image: AssetImage('assets/no_conf.gif'),
                              fit: BoxFit.cover)),
                    )
                  : SizedBox(),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(errorText,
                    style: Theme.of(context).textTheme.bodyText2),
              ),
              showTryButton
                  ? !rebuild
                      ? OutlinedButton(
                          onPressed: onTryAgain, child: Text('Try Again'))
                      : ElevatedButton(
                          onPressed: () {
                            Phoenix.rebirth(context);
                          },
                          style: ButtonStyle(
                              shape: MaterialStateProperty.all<CircleBorder>(
                            CircleBorder(),
                          )),
                          child: Icon(Icons.refresh_outlined),
                        )
                  : SizedBox(),
            ],
          ),
        ),
      ),
    );
  }
}
