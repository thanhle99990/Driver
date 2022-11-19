import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class DialogUtils {
  static DialogUtils _instance = new DialogUtils.internal();

  DialogUtils.internal();

  factory DialogUtils() => _instance;

  static void showCustomDialog(BuildContext context,
      {@required String title,
      String okBtnText = "Ok",
      String cancelBtnText = "Cancel",
      @required Function okBtnFunction}) {
    showDialog(
        context: context,
        builder: (_) {
          return AlertDialog(
            title: Text(title),
            //content: /* Here add your custom widget  */,
            actions: <Widget>[
              FlatButton(
                  child: Text(cancelBtnText),
                  onPressed: () => Navigator.pop(context)),
              FlatButton(
                child: Text(okBtnText),
                onPressed: okBtnFunction,
              ),
            ],
          );
        });
  }

  static void showPickImage(BuildContext context,
      {@required Function camBtnFunction,
      @required Function folderBtnFunction}) {
    showDialog(
        context: context,
        builder: (_) {
          return AlertDialog(
            title: Text("Select Image source"),
            //content: /* Here add your custom widget  */,
            actions: <Widget>[
              FlatButton(
                child: Text("Camera"),
                onPressed: camBtnFunction,
              ),
              FlatButton(child: Text("Folder"), onPressed: folderBtnFunction)
            ],
          );
        });
  }

  static void showSimpleDialog(
    BuildContext context, {
    @required String title,
    String okBtnText = "Ok",
    //@required Function okBtnFunction
  }) {
    showDialog(
        context: context,
        builder: (_) {
          return AlertDialog(
            //title: Text(title),
            content: Text(title),
            actions: <Widget>[
              FlatButton(
                child: Text(okBtnText),
                onPressed: () => Navigator.pop(context),
              ),
            ],
          );
        });
  }

  static void showToast(String text) {
    Fluttertoast.showToast(
        msg: text,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0);
  }

  static void showToastSuccess(String text) {
    Fluttertoast.showToast(
        msg: text,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.green,
        textColor: Colors.white,
        fontSize: 16.0);
  }
}
