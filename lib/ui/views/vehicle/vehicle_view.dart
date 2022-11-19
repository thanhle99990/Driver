import 'package:flutter/material.dart';
import 'package:kf_drawer/kf_drawer.dart';
import 'package:line_awesome_icons/line_awesome_icons.dart';
import 'package:provider_arc/ui/shared/app_colors.dart';
import 'package:provider_arc/ui/shared/text_styles.dart';
import 'package:provider_arc/ui/views/vehicle/vehicle_add.dart';

import '../../../core/models/vehicle.dart';

mixin VehicleView implements KFDrawerContent {
  @override
  _SelectDesPageState createState() {
    return _SelectDesPageState();
  }
}

class _SelectDesPageState extends State<VehicleView> {

  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            ListTile(
              leading: new IconButton(
                icon: new Icon(
                  Icons.arrow_back_ios,
                  color: Colors.black,
                ),
                onPressed: widget.onMenuPressed,
              ),
              title: Text('My Vehicle', style: TitleStyle),
              trailing: new IconButton(
                  icon: new Icon(
                    Icons.add,
                    color: PrimaryColor,
                  ),
                  onPressed: () => {
                        Navigator.of(context)
                            .push(
                          MaterialPageRoute(
                            builder: (context) => VehicleAddView(),
                          ),
                        )
                            .then((_) {
                          print('on back');
                          //model.vehicle_get();
                        })
                      }),
            ),
            /* Container(
                            //color: Colors.white,
                            child: Expanded(
                                child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: model.vehicles == null
                                  ? Dummy()
                                  : ListVehicle(
                                      model: model,
                                      vehicles: model.vehicles,
                                    ),
                            )),
                          ),*/
          ],
        ),
      ),
    );
  }
}

class ListVehicle extends StatelessWidget {
  final List<VehicleObj> vehicles;

  const ListVehicle({Key key, this.vehicles}) : super(key: key);

  Widget _buildItem(VehicleObj obj) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(24)),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              spreadRadius: 1,
              blurRadius: 1,
              offset: Offset(0, 3), // changes position of shadow
            ),
          ],
        ),
        child: Column(
          children: <Widget>[
            ListTile(
              leading: Image.asset(
                'assets/images/icocar.png',
              ),
              title: Text(
                obj.name,
                style: BoldStyle,
              ),
              subtitle: Text(obj.number),
              trailing: IconButton(
                onPressed: () {},
                icon: Icon(
                  LineAwesomeIcons.trash,
                  color: PrimaryColor,
                ),
              ),
            ),
            Divider(
              height: 1,
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: <Widget>[
                  Text(
                    "Type: ",
                    style: subHeaderStyle,
                  ),
                  Text(
                    "${obj.type}",
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: Text(
                      "|",
                      style: TextStyle(color: Colors.grey),
                    ),
                  ),
                  Text(
                    "Seat: ",
                    style: subHeaderStyle,
                  ),
                  Text(
                    "${obj.seat}",
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: vehicles.length,
        itemBuilder: (context, index) {
          return InkWell(onTap: () => {}, child: _buildItem(vehicles[index]));
        });
  }
}
