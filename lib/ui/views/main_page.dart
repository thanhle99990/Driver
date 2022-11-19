import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:kf_drawer/kf_drawer.dart';
import 'package:provider/provider.dart';
import 'package:provider_arc/core/constants/app_contstants.dart';
import 'package:provider_arc/core/models/userobj.dart';
import 'package:provider_arc/core/utils/pref_helper.dart';
import 'package:provider_arc/ui/shared/app_colors.dart';
import 'package:provider_arc/ui/shared/ui_helpers.dart';
import 'package:provider_arc/ui/views/home/home_view.dart';
import 'package:provider_arc/ui/views/other/earning_view.dart';
import 'package:provider_arc/ui/views/other/notification_view.dart';
import 'package:provider_arc/ui/views/other/setting.dart';
import 'package:provider_arc/ui/views/other/webview2.dart';
import 'package:provider_arc/ui/views/profile/car_view.dart';
import 'package:provider_arc/ui/views/profile/doc_view.dart';
import 'package:provider_arc/ui/views/ride/history.dart';
import 'package:provider_arc/ui/widgets/dummy.dart';
import 'package:provider_arc/ui/widgets/my/star.dart';

class MainPage extends StatefulWidget {
  MainPage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MainWidgetState createState() => _MainWidgetState();
}

class _MainWidgetState extends State<MainPage> with TickerProviderStateMixin {
  KFDrawerController _drawerController;
  SharedPreferenceHelper sharedPreferenceHelper = SharedPreferenceHelper();

  //UserObj userObj;
  //double rating;

  @override
  void initState() {
    super.initState();
    //getData();
    _drawerController = KFDrawerController(
      initialPage: HomeView(),
      items: [
        KFDrawerItem.initWithPage(
          text: Text('HOME', style: TextStyle(color: Colors.white)),
          icon: Icon(Icons.home, color: Colors.white),
          page: HomeView(),
        ),
        KFDrawerItem.initWithPage(
          text: Text(
            'EARNING',
            style: TextStyle(color: Colors.white),
          ),
          icon: Icon(Icons.monetization_on_outlined, color: Colors.white),
          page: EarningView(),
        ),
        KFDrawerItem.initWithPage(
          text: Text(
            'HISTORY',
            style: TextStyle(color: Colors.white),
          ),
          icon: Icon(Icons.history, color: Colors.white),
          page: HistoryView(),
        ),
        KFDrawerItem.initWithPage(
          text: Text(
            'VEHICLE',
            style: TextStyle(color: Colors.white),
          ),
          icon: Icon(Icons.local_taxi, color: Colors.white),
          page: CarView(),
        ),
        KFDrawerItem.initWithPage(
          text: Text(
            'DOCUMENT',
            style: TextStyle(color: Colors.white),
          ),
          icon: Icon(FontAwesomeIcons.fileAlt, color: Colors.white),
          page: DocView(),
        ),
       /* KFDrawerItem.initWithPage(
          text: Text(
            'SETTING',
            style: TextStyle(color: Colors.white),
          ),
          icon: Icon(Icons.settings, color: Colors.white),
          page: SettingView(),
        ),*/
        KFDrawerItem.initWithPage(
          text: Text(
            'NOTIFICATION',
            style: TextStyle(color: Colors.white),
          ),
          icon: Icon(Icons.notifications_none_outlined, color: Colors.white),
          page: NotificationView(),
        ),

        /* KFDrawerItem.initWithPage(
          text: Text(
            'CHAT',
            style: TextStyle(color: Colors.white),
          ),
          icon: Icon(Icons.chat_outlined, color: Colors.white),
          page: AllUsersScreen(),
        ),*/
        /* KFDrawerItem.initWithPage(
          text: Text(
            'T & A',
            style: TextStyle(color: Colors.white),
          ),
          icon: Icon(Icons.insert_drive_file_outlined, color: Colors.white),
          page: WebViewPage('Terms and Agreement','/public/pages/agreement.html'),
        ),*/
        KFDrawerItem.initWithPage(
          text: Text(
            'PRIVACY & POLICY',
            style: TextStyle(color: Colors.white),
          ),
          icon: Icon(Icons.insert_drive_file_outlined, color: Colors.white),
          page: WebViewPage2('Privacy & Policy', '/public/pages/privacy.html'),
        ),
        /*KFDrawerItem.initWithPage(
          text: Text(
            'ABOUT',
            style: TextStyle(color: Colors.white),
          ),
          icon: Icon(Icons.info_outline, color: Colors.white),
          page: AboutPage(),
        ),*/
      ],
    );
  }

  /* Future<void> getData() async {
    Api api = Api();
    //rating = await api.getSumRating();
    //userObj = Provider.of<UserObj>(context);
    setState(() {
      rating;
      //userObj;
    });
  }
*/
  @override
  Widget build(BuildContext context) {
    UserObj userObj = Provider.of<UserObj>(context);
    return Scaffold(
      body: KFDrawer(
        controller: _drawerController,
        header: userObj == null
            ? Dummy()
            : SizedBox(
                height: 130,
                child: Align(
                  alignment: Alignment.topLeft,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 16),
                    child: GestureDetector(
                      onTap: () =>
                          {Navigator.pushNamed(context, RoutePaths.Profile)},
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Container(
                            decoration: new BoxDecoration(
                              shape: BoxShape.circle,
                              border: new Border.all(
                                color: Colors.white,
                                width: 2.0,
                              ),
                            ),
                            child: CircleAvatar(
                              radius: 32,
                              backgroundImage: NetworkImage(
                                userObj.profile,
                              ),
                            ),
                          ),
                          UIHelper.horizontalSpaceSmall,
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              UIHelper.verticalSpaceSmall,
                              Text(
                                userObj.name,
                                style: TextStyle(
                                    color: Colors.white, fontSize: 18),
                              ),
                              Star(
                                rating: userObj.rating,
                              )
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ),
        footer: KFDrawerItem(
          text: Text(
            'SIGN OUT',
            style: TextStyle(color: Colors.white),
          ),
          icon: Icon(
            Icons.input,
            color: Colors.white,
          ),
          onPressed: () {
            SharedPreferenceHelper _sharedPreferenceHelper =
                SharedPreferenceHelper();
            _sharedPreferenceHelper.setLogin(false);
            _sharedPreferenceHelper.setUserId(null);
            Navigator.popAndPushNamed(context, RoutePaths.Authen);
          },
        ),
        decoration: BoxDecoration(color: PrimaryColor),
      ),
    );
  }
}

// ignore: must_be_immutable
class BlankPage extends KFDrawerContent {
  @override
  _CalendarPageState createState() => _CalendarPageState();
}

class _CalendarPageState extends State<BlankPage> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Center(
        child: Column(
          children: <Widget>[
            Row(
              children: <Widget>[
                ClipRRect(
                  borderRadius: BorderRadius.all(Radius.circular(32.0)),
                  child: Material(
                    shadowColor: Colors.transparent,
                    color: Colors.transparent,
                    child: IconButton(
                      icon: Icon(
                        Icons.menu,
                        color: Colors.black,
                      ),
                      onPressed: widget.onMenuPressed,
                    ),
                  ),
                ),
              ],
            ),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text('Please comeback later'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
