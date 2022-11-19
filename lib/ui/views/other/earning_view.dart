import 'package:flutter/material.dart';
import 'package:kf_drawer/kf_drawer.dart';
import 'package:provider_arc/core/models/report/earning.dart';
import 'package:provider_arc/core/services/api.dart';
import 'package:provider_arc/ui/shared/text_styles.dart';
import 'package:provider_arc/ui/widgets/loading.dart';

class EarningView extends KFDrawerContent {
  @override
  _CalendarPageState createState() => _CalendarPageState();
}

class _CalendarPageState extends State<EarningView> {
  Api api = Api();
  bool loading = true;
  List<EarningRpt> list = List<EarningRpt>();

  @override
  void initState() {
    super.initState();
    this.getData();
  }

  void getData() async {
    List<EarningRpt> tmp = await api.getEarning();
    setState(() {
      loading = false;
      list = tmp;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text("Earning",   style: TextStyle(color: Colors.black),),
        leading: new IconButton(
          icon: new Icon(
            Icons.arrow_back,
            color: Colors.black,
          ),
          onPressed: widget.onMenuPressed,
        ),
      ),
      body: loading
          ? Loading()
          : ListView.builder(
              itemCount: list.length,
              itemBuilder: (context, int) {
                EarningRpt obj = list[int];
                return ListTile(
                  title: Text(obj.date),
                  subtitle: Text("${obj.ride} Rides"),
                  trailing: Text(
                    "\$ ${obj.earning}",
                    style: BoldStyle,
                  ),
                );
              },
            ),
    );
  }
}
