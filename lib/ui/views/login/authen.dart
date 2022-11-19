import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:location/location.dart' as location;
import 'package:provider_arc/core/constants/app_contstants.dart';
import 'package:provider_arc/ui/shared/ui_helpers.dart';
import 'package:provider_arc/ui/widgets/custom/mybutton.dart';

// ignore: must_be_immutable
class AuthenView extends StatefulWidget {
  @override
  _AuthenViewState createState() => _AuthenViewState();
}

class _AuthenViewState extends State<AuthenView> {
  location.Location _location = location.Location();

  @override
  void initState() {
    super.initState();
    getLocation();
  }

  void getLocation() {
    _location.getLocation().then((data) async {
      print(data);
    });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: Stack(
        children: <Widget>[
          Center(
            child: new Image.asset(
              'assets/images/bg.png',
              width: size.width,
              height: size.height,
              fit: BoxFit.fill,
            ),
          ),
          Container(
            color: Colors.black45,
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: <Widget>[
                UIHelper.verticalSpaceLarge,
                Center(
                  child: Hero(
                    tag: 'imageHero',
                    child: new Image.asset(
                      'assets/icons/icon.png',
                      width: size.width / 4,
                      height: size.width / 4,
                      fit: BoxFit.fill,
                    ),
                  ),
                ),
                Spacer(),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: MyButton(
                      caption: "Sign in",
                      fullsize: true,
                      onPressed: () =>
                          Navigator.pushNamed(context, RoutePaths.Login)),
                ),
                UIHelper.verticalSpaceSmall,
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    FlatButton(
                      child: Text(
                        "Register",
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 18),
                      ),
                      onPressed: () {
                        Navigator.pushNamed(context, RoutePaths.Signup);
                      },
                    )
                  ],
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
