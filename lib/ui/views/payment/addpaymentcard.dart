import 'package:flutter/material.dart';
import 'package:provider_arc/ui/shared/ui_helpers.dart';
import 'package:provider_arc/ui/widgets/custom/mybutton.dart';
import 'package:provider_arc/ui/widgets/item/itemradio2.dart';




class Addpaymentcard extends StatefulWidget {
  @override
  _AddpaymentcardState createState() => _AddpaymentcardState();
}

class _AddpaymentcardState extends State<Addpaymentcard> {
  List<RadioModel2> _listtype = [
    RadioModel2(true, "Master", 'assets/images/master.png'),
    RadioModel2(false, "Visa", 'assets/images/visa.png'),
    RadioModel2(false, "Paypal", 'assets/images/paypal.png'),
  ];
  int selecttype = 0;
  bool hidepass = true;
  final TextEditingController controllerName = TextEditingController();
  final TextEditingController controllerCode = new TextEditingController();
  bool invalidMail = false;
  bool invalidPassword = false;

  _choicetype(int i) {
    debugPrint('choice $i');
    setState(() {
      selecttype = i;
      _listtype[0].isSelected = false;
      _listtype[1].isSelected = false;
      _listtype[2].isSelected = false;
      _listtype[i].isSelected = true;
    });
  }

  Widget _buildplacetype() {
    return Container(
        child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        RadioItem2(
          item: _listtype[0],
          onPressed: () => _choicetype(0),
        ),
        RadioItem2(
          item: _listtype[1],
          onPressed: () => _choicetype(1),
        ),
        RadioItem2(
          item: _listtype[2],
          onPressed: () => _choicetype(2),
        ),
      ],
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
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
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: (Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                'Add payment card',
                style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
              ),
              UIHelper.verticalSpaceSmall,
              _buildplacetype(),
              Text("NAME", style: TextStyle(color: Colors.grey)),
              UIHelper.verticalSpaceSmall,
              TextField(
                controller: controllerName,
                decoration: InputDecoration(
                    errorText: invalidMail ? 'Value Can\'t Be Empty' : null,
                    suffixIcon: GestureDetector(
                      onTap: () {
                        print("clear");
                        controllerName.clear();
                      },
                      child: Icon(
                        Icons.clear,
                        color: Colors.black26,
                      ),
                    ),
                    hintText: "Name",
                    hintStyle: TextStyle(color: Colors.black26),
                    border: OutlineInputBorder(
                      borderSide:
                          BorderSide(color: Colors.blueGrey, width: 5.0),
                      borderRadius: BorderRadius.all(Radius.circular(4.0)),
                    ),
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0)),
              ),
              UIHelper.verticalSpaceMedium,
              Text("CREDIT CARD NUMBER", style: TextStyle(color: Colors.grey)),
              UIHelper.verticalSpaceSmall,
              TextField(
                controller: controllerCode,
                obscureText: hidepass,
                decoration: InputDecoration(
                    errorText: invalidPassword ? 'Value Can\'t Be Empty' : null,
                    suffixIcon: GestureDetector(
                      onTap: () {
                        setState(() {
                          hidepass = !hidepass;
                        });
                      },
                      child: Icon(
                        Icons.remove_red_eye,
                        color: Colors.black26,
                      ),
                    ),
                    hintText: "Number",
                    hintStyle: TextStyle(color: Colors.black26),
                    border: OutlineInputBorder(
                      borderSide:
                          BorderSide(color: Colors.blueGrey, width: 5.0),
                      borderRadius: BorderRadius.all(Radius.circular(4.0)),
                    ),
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0)),
              ),
              UIHelper.verticalSpaceMedium,
              Row(
                children: <Widget>[
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text("Expired", style: TextStyle(color: Colors.grey)),
                        UIHelper.verticalSpaceSmall,
                        TextField(
                          controller: controllerName,
                          decoration: InputDecoration(
                              errorText: invalidMail
                                  ? 'Value Can\'t Be Empty'
                                  : null,
                              hintText: "MM/YYYY",
                              hintStyle: TextStyle(color: Colors.black26),
                              border: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: Colors.blueGrey, width: 5.0),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(4.0)),
                              ),
                              contentPadding: EdgeInsets.symmetric(
                                  horizontal: 20.0, vertical: 16.0)),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    width: 16,
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text("CVV", style: TextStyle(color: Colors.grey)),
                        UIHelper.verticalSpaceSmall,
                        TextField(
                          controller: controllerName,
                          decoration: InputDecoration(
                              errorText: invalidMail
                                  ? 'Value Can\'t Be Empty'
                                  : null,
                              hintText: "CVV",
                              hintStyle: TextStyle(color: Colors.black26),
                              border: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: Colors.blueGrey, width: 5.0),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(4.0)),
                              ),
                              contentPadding: EdgeInsets.symmetric(
                                  horizontal: 20.0, vertical: 16.0)),
                        ),
                      ],
                    ),
                  )
                ],
              ),
              UIHelper.verticalSpaceLarge,
              MyButton(
                caption: 'SAVE',
                fullsize: true,
                onPressed: () => Navigator.pop(context),
              ),
            ],
          )),
        ),
      ),
    );
  }
}
