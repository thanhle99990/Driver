import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:provider_arc/core/models/rating.dart';
import 'package:provider_arc/core/viewmodels/views/map_view_model.dart';
import 'package:provider_arc/ui/shared/ui_helpers.dart';
import 'package:provider_arc/ui/widgets/custom/mybutton.dart';
import 'package:provider_arc/ui/widgets/custom/mycontainer.dart';
import 'package:provider_arc/ui/widgets/custom/mytitle.dart';

class Rating extends StatefulWidget {
  final MapViewModel model;

  const Rating({Key key, this.model}) : super(key: key);

  @override
  _RatingState createState() => _RatingState(model);
}

class _RatingState extends State<Rating> {
  final MapViewModel model;
  int rating = 0;

  _RatingState(this.model);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: <Widget>[
        MyContainer(
          child: Column(
            children: <Widget>[
              UIHelper.verticalSpaceMedium,
              MyH2(
                text: "How was your rider?",
              ),
              Padding(
                padding: const EdgeInsets.all(24.0),
                child: RatingBar(
                    initialRating: 3,
                    minRating: 1,
                    direction: Axis.horizontal,
                    allowHalfRating: true,
                    itemCount: 5,
                    itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
                    itemBuilder: (context, _) => Icon(
                          Icons.star,
                          color: Colors.amber,
                        ),
                    onRatingUpdate: (rating) {
                      setState(() {
                        this.rating = rating.toInt();
                      });
                    }),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: MyButton(
                  caption: "Submit",
                  fullsize: true,
                  onPressed: () {
                    RatingObj obj = RatingObj();
                    obj.fromcustomer = 0;
                    obj.idride = model.rideObj.idride;
                    obj.code = model.rideObj.code;
                    obj.idcustomer = model.rideObj.idcustomer;
                    obj.iddriver = model.rideObj.iddriver;
                    obj.rating = this.rating;
                    model.submitRating(obj);
                  },
                ),
              )
            ],
          ),
        )
      ],
    );
  }
}
