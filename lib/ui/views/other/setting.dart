import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:kf_drawer/kf_drawer.dart';
import 'package:provider/provider.dart';
import 'package:provider_arc/core/models/userobj.dart';
import 'package:provider_arc/core/services/api.dart';
import 'package:provider_arc/core/utils/pref_helper.dart';
import 'package:provider_arc/ui/shared/app_colors.dart';
import 'package:provider_arc/ui/shared/text_styles.dart';
import 'package:provider_arc/ui/shared/ui_helpers.dart';
import 'package:provider_arc/ui/widgets/custom/mybuttonfull.dart';
import 'package:provider_arc/ui/widgets/custom/mydialog.dart';

class SettingView extends KFDrawerContent {
  @override
  _SettingViewState createState() => _SettingViewState();
}

class _SettingViewState extends State<SettingView> {
  SharedPreferenceHelper sharedPreferenceHelper = SharedPreferenceHelper();
  int select;
  UserObj userObj;
  Api api = Api();

  void initState() {
    //super.initState();
    //getdata();
    userObj = Provider.of<UserObj>(context, listen: false);
    super.initState();
    select = userObj.accept;
  }

/*
  Future<void> getdata() async {
    select = await sharedPreferenceHelper.setting;
    setState(() {
      select;
    });
  }*/

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: new AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          title: Text(
            "Setting",
            style: TextStyle(color: Colors.black),
          ),
          leading: new IconButton(
            icon: new Icon(
              Icons.arrow_back,
              color: Colors.black,
            ),
            onPressed: widget.onMenuPressed,
          ),
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            UIHelper.verticalSpaceMedium,
            Padding(
              padding: const EdgeInsets.only(left: 32),
              child: Text(
                "Accepts gender",
                style: TitleStyle,
              ),
            ),
            UIHelper.verticalSpaceMedium,
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: Column(
                children: [
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        select = 0;
                      });
                      sharedPreferenceHelper.setSetting(select);
                    },
                    child: ListTile(
                      leading: select == 0
                          ? Icon(
                              Icons.stop_circle,
                              color: PrimaryColor,
                            )
                          : Icon(CupertinoIcons.circle),
                      title: Text("Only Female"),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        select = 1;
                      });
                      sharedPreferenceHelper.setSetting(select);
                    },
                    child: ListTile(
                      leading: select == 1
                          ? Icon(
                              Icons.stop_circle,
                              color: PrimaryColor,
                            )
                          : Icon(CupertinoIcons.circle),
                      title: Text("Only Male"),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        select = 2;
                      });
                      sharedPreferenceHelper.setSetting(select);
                    },
                    child: ListTile(
                      leading: select == 2
                          ? Icon(
                              Icons.stop_circle,
                              color: PrimaryColor,
                            )
                          : Icon(CupertinoIcons.circle),
                      title: Text("Both"),
                    ),
                  ),
                ],
              ),
            ),
            Spacer(),
            MyButtonFull(
              caption: "Submit",
              onPressed: () {
                //sharedPreferenceHelper.setSetting(select);
                //Navigator.pop(context);
                UserObj newUser = UserObj();
                newUser.accept = select;
                api.updateProfile(newUser);
                userObj.accept=select;

                DialogUtils.showToastSuccess("Save setting successful");
              },
            ),
          ],
        ));
  }
}
