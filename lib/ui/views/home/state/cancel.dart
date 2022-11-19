import 'package:flutter/material.dart';
import 'package:mdi/mdi.dart';
import 'package:provider_arc/core/utils/device_utils.dart';
import 'package:provider_arc/core/viewmodels/views/map_view_model.dart';
import 'package:provider_arc/ui/shared/app_colors.dart';
import 'package:provider_arc/ui/shared/text_styles.dart';
import 'package:provider_arc/ui/widgets/custom/mybutton.dart';

class Cancel extends StatefulWidget {
  final MapViewModel model;

  const Cancel({Key key, this.model}) : super(key: key);

  @override
  _CancelState createState() => _CancelState(model);
}

class _CancelState extends State<Cancel> {
  final MapViewModel model;
  int select = 0;
  List<String> list = [
    'Rider is not here',
    'Wrong address shown',
    'Don\'t charge rider',
    'Don\'t charge rider',
    'Don\'t charge rider',
    'Don\'t charge rider'
  ];

  _CancelState(this.model);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      height: DeviceUtils.getScaledHeight(context, 1),
      child: Column(
        children: <Widget>[
          ListTile(
            leading: IconButton(
              onPressed: () {
                model.cancelNo();
              },
              icon: Icon(Icons.close),
            ),
            title: Text(
              "Cancel Ride",
              style: H2.copyWith(color: Dark),
              textAlign: TextAlign.center,
            ),
            trailing: Icon(
              Icons.close,
              color: Colors.transparent,
            ),
          ),
          Divider(
            height: 1,
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: ListView.builder(
                itemCount: list.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        select = index;
                      });
                    },
                    child: select == index
                        ? ListTile(
                            leading: Icon(Mdi.checkboxMarkedCircle,color: PrimaryColor,),
                            title: Text(list[index]))
                        : ListTile(
                            leading: Icon(Mdi.checkboxBlankCircleOutline),
                            title: Text(list[index])),
                  );
                },
              ),
            ),
          ),
          Spacer(),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: MyButton(
              caption: "Done",
              fullsize: true,
              onPressed: () {
                //model.cancelRide();
              },
            ),
          )
        ],
      ),
    );
  }
}
