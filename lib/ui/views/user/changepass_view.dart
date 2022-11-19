import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider_arc/core/constants/app_contstants.dart';
import 'package:provider_arc/core/models/response.dart';
import 'package:provider_arc/core/services/api.dart';
import 'package:provider_arc/ui/shared/text_styles.dart';
import 'package:provider_arc/ui/shared/ui_helpers.dart';
import 'package:provider_arc/ui/widgets/custom/mybutton.dart';
import 'package:provider_arc/ui/widgets/custom/mydialog.dart';
import 'package:provider_arc/ui/widgets/custom/mytextfield.dart';
import 'package:provider_arc/ui/widgets/loading.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ChangepassView extends StatefulWidget {
  @override
  _ChangepassViewState createState() => _ChangepassViewState();
}

class _ChangepassViewState extends State<ChangepassView> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  bool hidepass = true;
  final TextEditingController controllerPass2 = TextEditingController();
  final TextEditingController controllerPass1 = new TextEditingController();
  bool invalidPass2 = false;
  bool invalidPass1 = false;
  Api _api = Api();
  bool loading = false;

  _done() async {
    setState(() {
      controllerPass1.text.isEmpty ? invalidPass1 = true : invalidPass1 = false;
      controllerPass2.text.isEmpty ? invalidPass2 = true : invalidPass2 = false;
    });
    if (invalidPass1) return;
    if (invalidPass2) return;
    setState(() {
      loading = true;
    });
    if (controllerPass1.text.toString() == controllerPass2.text.toString()) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      int userId = prefs.getInt(KEYS.iddriver);
      ResponseObj responseObj =
          await _api.changePassword(controllerPass1.text);
      String msg = '';
      if (responseObj.code == 0) {
        msg = 'Change password successful';
      } else {
        msg = 'Error';
      }
      DialogUtils.showToastSuccess(msg);
      setState(() {
        loading = false;
      });
      //Navigator.pop(context);
    } else {
      _scaffoldKey.currentState.showSnackBar(SnackBar(
        content: Text('Two password input mismatch'),
        duration: Duration(seconds: 3),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey,
        appBar: new AppBar(
          title: new Text(
            'Change password',
            style: TitleStyle,
          ),
          backgroundColor: Colors.white,
          elevation: 0,
          leading: new IconButton(
            icon: new Icon(
              Icons.arrow_back_ios,
              color: Colors.black,
            ),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ),
        body: Builder(
          builder: (context) => Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                MyTextField(
                  name: "New password",
                  controllerText: controllerPass1,
                  invalid: invalidPass1,
                ),
                UIHelper.verticalSpaceSmall,
                MyTextField(
                  name: "Retype password",
                  controllerText: controllerPass2,
                  invalid: invalidPass2,
                ),
                UIHelper.verticalSpaceMedium,
                loading
                    ? Loading(
                        small: true,
                      )
                    : MyButton(
                        caption: 'DONE',
                        fullsize: true,
                        onPressed: () {
                          _done();
                        },
                      )
              ],
            ),
          ),
        ));
  }
}
