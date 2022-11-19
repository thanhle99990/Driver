import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider_arc/core/constants/app_contstants.dart';
import 'package:provider_arc/ui/shared/ui_helpers.dart';
import 'package:provider_arc/ui/widgets/custom/mybutton.dart';
import 'package:provider_arc/ui/widgets/custom/mytitle.dart';
import 'package:provider_arc/ui/widgets/item/itemradiorow.dart';

class PaymementView extends StatefulWidget {
  @override
  _SelectDesPageState createState() {
    return _SelectDesPageState();
  }
}

class _SelectDesPageState extends State<PaymementView> {
  final myController1 = TextEditingController();
  int num = 0;
  RadioModelRow itemRowcash =
      RadioModelRow(true, 'assets/images/cash.png', 'Cash payment', 'Default');

  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: new AppBar(
        //title: new Text('Name here'),
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
      body: Container(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              MyTitle(title: 'Payment',),
              UIHelper.verticalSpaceSmall,
              RadioItemRow(
                item: itemRowcash,
                onPressed: () => {},
              ),
              Spacer(),
              MyButton(caption: 'ADD PAYMENT METHOD',
                fullsize: true,
                onPressed: () =>
                    Navigator.of(context).pushNamed(RoutePaths.AddPayment),),

            ],
          ),
        ),
      ),
    );
  }

}
