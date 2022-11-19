import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:full_screen_image/full_screen_image.dart';
import 'package:image/image.dart' as ImageProcess;
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:kf_drawer/kf_drawer.dart';
import 'package:provider_arc/core/models/doc.dart';
import 'package:provider_arc/core/services/api.dart';
import 'package:provider_arc/ui/shared/text_styles.dart';
import 'package:provider_arc/ui/shared/ui_helpers.dart';
import 'package:provider_arc/ui/widgets/custom/mydialog.dart';
import 'package:provider_arc/ui/widgets/custom/mytitle.dart';
import 'package:provider_arc/ui/widgets/loading.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class DocView extends KFDrawerContent {
  @override
  _AddDocState createState() => _AddDocState();
}

class _AddDocState extends State<DocView> {
  File imageFile1;
  File imageFile2;
  Api api = Api();
  int type;
  DocObj doc1, doc2;
  bool loading = true;

  @override
  void initState() {
    super.initState();
    this.getData();
  }

  void getData() async {
    DocObj obj1 = await api.getDoc(1);
    DocObj obj2 = await api.getDoc(2);
    setState(() {
      doc1 = obj1;
      doc2 = obj2;
      loading = false;
    });
  }

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
    Alert(
      context: context,
      type: AlertType.none,
      title: "Select image source",
      //desc: "Flutter is more awesome with RFlutter Alert.",
      buttons: [
        DialogButton(
          child: Text(
            "Camera",
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
          onPressed: () => {getImage(1), Navigator.pop(context)},
          color: Colors.blue,
        ),
        DialogButton(
            child: Text(
              "Folder",
              style: TextStyle(color: Colors.white, fontSize: 20),
            ),
            onPressed: () => {getImage(2), Navigator.pop(context)},
            color: Colors.green)
      ],
    ).show();
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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: new AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          title: Text("Documents"),
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
            : Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                color: Colors.white,
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      MyH1(
                        text: "Document",
                      ),
                      UIHelper.verticalSpaceMedium,
                      Card(
                          child: Column(
                        children: [
                          SizedBox(
                            height: 80,
                            width: 80,
                            child: FullScreenWidget(
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(5),
                                child: Image.network(
                                  doc1.image,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          ),
                          ListTile(
                            title: Text("Licence"),
                            subtitle: doc1.status == 0
                                ? Text(
                                    "Pending",
                                    style: BoldStyle,
                                  )
                                : doc1.status == 1
                                    ? Text("Approved", style: BoldStyle)
                                    : Text("Deny", style: BoldStyle),
                          ),
                        ],
                      )),
                      UIHelper.verticalSpaceMedium,
                      Card(
                          child: Column(
                        children: [
                          SizedBox(
                            height: 80,
                            width: 80,
                            child: FullScreenWidget(
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(5),
                                child: Image.network(
                                  doc2.image,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          ),
                          ListTile(
                            title: Text("Vehicle Insurance"),
                            subtitle: doc2.status == 0
                                ? Text(
                                    "Pending",
                                    style: BoldStyle,
                                  )
                                : doc2.status == 1
                                    ? Text("Approved", style: BoldStyle)
                                    : Text("Deny", style: BoldStyle),
                          ),
                        ],
                      )),
                      Spacer(),
                      /*   MyButton(
                          caption: "Upload",
                          fullsize: true,
                          onPressed: () => upload()),*/
                    ])));
  }
}
