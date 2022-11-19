import 'package:flutter/material.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'package:kf_drawer/kf_drawer.dart';
import 'package:provider_arc/core/constants/app_contstants.dart';
import 'package:provider_arc/ui/shared/app_colors.dart';
import 'package:provider_arc/ui/shared/text_styles.dart';

class AgreementView extends KFDrawerContent {
  @override
  _AgreementViewState createState() => _AgreementViewState();
}

class _AgreementViewState extends State<AgreementView> {
  String link;

  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new MaterialApp(
      debugShowCheckedModeBanner: false,
      routes: {
        "/": (_) => SafeArea(
              child: new WebviewScaffold(
                url: KEYS.endpoint + '/public/pages/agreement.html',
                appBar: new AppBar(
                  backgroundColor: PrimaryColor,
                  title: new Text("User Terms and Agreement", style: TitleStyle,),
                  leading: new IconButton(
                    icon: new Icon(
                      Icons.arrow_back,
                      color: Colors.black,
                    ),
                    onPressed: widget.onMenuPressed,
                  ),
                ),
              ),
            ),
      },
    );
  }
}
