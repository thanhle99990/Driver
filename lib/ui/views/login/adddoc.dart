import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image/image.dart' as ImageProcess;
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider_arc/core/constants/app_contstants.dart';
import 'package:provider_arc/core/services/api.dart';
import 'package:provider_arc/ui/shared/app_colors.dart';
import 'package:provider_arc/ui/shared/ui_helpers.dart';
import 'package:provider_arc/ui/widgets/custom/mybutton.dart';
import 'package:provider_arc/ui/widgets/custom/mydialog.dart';
import 'package:provider_arc/ui/widgets/custom/mytitle.dart';
import 'package:provider_arc/ui/widgets/loading.dart';

class AddDoc extends StatefulWidget {
  @override
  _AddDocState createState() => _AddDocState();
}

class _AddDocState extends State<AddDoc> {
  File imageFile1;
  File imageFile2;
  Api api = Api();
  int type;
  bool loading = false;

  Future getImage(int chonloai) async {
    var image = await ImagePicker.pickImage(
        source: chonloai == 1 ? ImageSource.camera : ImageSource.gallery,
        maxWidth: 800.0,
        maxHeight: 800.0);

    if (image != null) {
      await _cropImage(image);
    }
  }

  /// Crop the image
  Future<Null> _cropImage(File image) async {
    File croppedImage = await ImageCropper.cropImage(
      aspectRatioPresets: [
        CropAspectRatioPreset.square,
      ],
      sourcePath: image.path,
      maxWidth: 300,
      maxHeight: 300,
    );
    if (croppedImage != null) {
      if (this.type == 1) {
        imageFile1 = croppedImage;
      } else {
        imageFile2 = croppedImage;
      }
      setState(() {});
    }
  }

  void select(int type) {
    setState(() {
      this.type = type;
    });
    DialogUtils.showPickImage(context, camBtnFunction: () {
      getImage(1);
      Navigator.pop(context);
    }, folderBtnFunction: () {
      getImage(2);
      Navigator.pop(context);
    });
  }

  void upload() async {
    if (imageFile1 == null) {
      DialogUtils.showToast("Please select Licence file");
      return;
    }
    if (imageFile2 == null) {
      DialogUtils.showToast("Please select Vehicle Insurance");
      return;
    }
    setState(() {
      this.loading = true;
    });
    if (imageFile1 != null) {
      final _imageFile1 = ImageProcess.decodeImage(
        imageFile1.readAsBytesSync(),
      );
      String base64Image = 'data:image/png;base64,' +
          base64Encode(ImageProcess.encodePng(_imageFile1));
      await api.uploadDocument(1, base64Image);
    }
    if (imageFile2 != null) {
      final _imageFile1 = ImageProcess.decodeImage(
        imageFile2.readAsBytesSync(),
      );
      String base64Image = 'data:image/png;base64,' +
          base64Encode(ImageProcess.encodePng(_imageFile1));

      await api.uploadDocument(2, base64Image);
    }
    setState(() {
      this.loading = false;
    });
    Navigator.pushNamed(context, RoutePaths.Letgo);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: new AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          title: Text("Documents"),
        ),
        body: Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            color: Colors.white,
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              MyH1(
                text: "Add Document",
              ),
              UIHelper.verticalSpaceMedium,
              Card(
                  child: ListTile(
                title: Text("Licence"),
                subtitle:
                    imageFile1 == null ? Text("Not upload") : Text("Ready"),
                trailing: IconButton(
                    icon: imageFile1 == null
                        ? Icon(Icons.camera_alt)
                        : Icon(
                            Icons.check_circle_outline,
                            color: PrimaryColor,
                          ),
                    onPressed: () => select(1)),
              )),
              UIHelper.verticalSpaceMedium,
              Card(
                  child: ListTile(
                title: Text("Vehicle Insurance"),
                subtitle:
                    imageFile2 == null ? Text("Not upload") : Text("Ready"),
                trailing: IconButton(
                    icon: imageFile2 == null
                        ? Icon(Icons.camera_alt)
                        : Icon(
                            Icons.check_circle_outline,
                            color: PrimaryColor,
                          ),
                    onPressed: () => select(2)),
              )),
              Spacer(),
              loading
                  ? Loading()
                  : MyButton(
                      caption: "Upload",
                      fullsize: true,
                      onPressed: () => upload()),
            ])));
  }
}
