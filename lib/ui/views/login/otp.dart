import 'package:flutter/material.dart';
// import 'package:flutter_verification_code_input/flutter_verification_code_input.dart';
import 'package:provider/provider.dart';
import 'package:provider_arc/core/constants/app_contstants.dart';
import 'package:provider_arc/core/models/userobj.dart';
import 'package:provider_arc/core/utils/pref_helper.dart';
import 'package:provider_arc/core/viewmodels/views/login_view_model.dart';
import 'package:provider_arc/ui/shared/app_colors.dart';
import 'package:provider_arc/ui/shared/text_styles.dart';
import 'package:provider_arc/ui/shared/ui_helpers.dart';
import 'package:provider_arc/ui/widgets/custom/mybutton.dart';
import 'package:provider_arc/ui/widgets/dummy.dart';

import '../base_widget.dart';

class VerifyOTPView extends StatefulWidget {
  VerifyOTPView({Key key}) : super(key: key);

  @override
  _PhoneInputPageState createState() {
    return _PhoneInputPageState();
  }
}

class _PhoneInputPageState extends State<VerifyOTPView> {
  bool isvalid = true;
  String otp = '';


  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void checkotp() async {
    if (Provider.of<UserObj>(context).verify == otp) {
      setState(() {
        isvalid = true;
      });
      UserObj userObj = Provider.of<UserObj>(context);
      SharedPreferenceHelper _sharedPrefsHelper = SharedPreferenceHelper();
      _sharedPrefsHelper.setLogin(true);
      _sharedPrefsHelper.setUserId(userObj.iddriver);
      int num = await _sharedPrefsHelper.numAccess;
      num++;
      _sharedPrefsHelper.setNumAccess(num);

      Navigator.of(context).pushNamed(RoutePaths.Addcar);
    } else {
      setState(() {
        isvalid = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return BaseWidget<LoginViewModel>(
        model: LoginViewModel(authenticationService: Provider.of(context)),
        builder: (context, model, child) => Scaffold(
              body: Container(
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage(
                        "assets/images/bgblank.png",
                      ),
                      fit: BoxFit.fill,
                    ),
                  ),
                  padding: EdgeInsets.all(20.0),
                  //color: Colors.grey.shade800,
                  child: ListView(children: <Widget>[
                    Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text("Verify phone number", style: headerStyle.copyWith(color: Basic)),
                          Padding(
                              padding:
                                  const EdgeInsets.only(top: 26, bottom: 26),
                              child: Text(
                                  'Check your SMS messages. We have sent you the PIN')),
                          Provider.of<UserObj>(context) == null
                              ? Dummy()
                              : Text(
                                  'PIN ${Provider.of<UserObj>(context).verify}',
                                  style: TextStyle(color: Colors.red),
                                ),
                          /*Center(
                            child: VerificationCodeInput(
                            textStyle: TextStyle(color: Colors.white, fontSize: 32),
                              keyboardType: TextInputType.number,
                              length: 4,
                              onCompleted: (String value) {
                                print(value);
                                setState(() {
                                  otp = value;
                                });
                                checkotp();
                              },
                            ),
                          ),*/
                          UIHelper.verticalSpaceSmall,
                          isvalid
                              ? SizedBox(
                                  height: 0,
                                )
                              : Center(
                                  child: Text(
                                  'Invalid OTP !',
                                  style: TextStyle(color: Colors.red),
                                  textAlign: TextAlign.center,
                                )),
                          UIHelper.verticalSpaceSmall,
                          Row(
                            children: <Widget>[
                              Text("Didn't receive SMS? ",
                                  style: TextStyle(color: Colors.white)),
                              Text(
                                "Resend Code",
                                style: TextStyle(color: PrimaryColor),
                              )
                            ],
                          ),
                          UIHelper.verticalSpaceMedium,
                          MyButton(
                            caption: 'VERIFY',
                            fullsize: true,
                            onPressed: () => {checkotp()},
                          )
                        ])
                  ])),
            ));
  }
}
