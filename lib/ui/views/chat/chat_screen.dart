import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

//import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:provider_arc/core/models/userobj.dart';
import 'package:provider_arc/core/services/api.dart';
import 'package:provider_arc/ui/views/chat/models/message.dart';
import 'package:provider_arc/ui/widgets/custom/mydialog.dart';

// ignore: must_be_immutable
class ChatScreen extends StatefulWidget {
  /* String name;
  String photoUrl;
  String receiverUid;
  ChatScreen({this.name, this.photoUrl, this.receiverUid});*/
  final UserObj userObj;

  const ChatScreen({Key key, this.userObj}) : super(key: key);

  _ChatScreenState createState() => _ChatScreenState(userObj);
/*@override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<UserObj>('userObj', userObj));
  }*/
}

class _ChatScreenState extends State<ChatScreen> {
  final Api api = Api();
  final UserObj userObj;
  Message _message;
  var _formKey = GlobalKey<FormState>();
  var map = Map<String, dynamic>();
  CollectionReference _collectionReference;

  DocumentReference _receiverDocumentReference;
  DocumentReference _senderDocumentReference;
  DocumentReference _documentReference;
  DocumentSnapshot documentSnapshot;
  FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  String _senderuid;
  var listItem;
  String receiverPhotoUrl, senderPhotoUrl, receiverName, senderName;
  StreamSubscription<DocumentSnapshot> subscription;
  File imageFile;

  StorageReference _storageReference;
  TextEditingController _messageController;

  _ChatScreenState(this.userObj);

  String choice = "Click Settings to make your selection";
  List<MyAction> listAction = <MyAction>[
    MyAction(name: 'Clear chat', index: 0),
  ];

  @override
  void initState() {
    super.initState();

    _messageController = TextEditingController();
    getUID().then((user) {
      setState(() {
        _senderuid = user.iddriver.toString();
        print("sender uid : $_senderuid");
        getSenderPhotoUrl(_senderuid).then((snapshot) {
          setState(() {
            senderPhotoUrl = snapshot[''];//photoUrl
            senderName = snapshot['name'];
          });
        });
        getReceiverPhotoUrl(userObj.iddriver.toString()).then((snapshot) {
          setState(() {
            receiverPhotoUrl = snapshot[''];//photoUrl
            receiverName = snapshot['name'];
          });
        });
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
    subscription?.cancel();
  }

  void addMessageToDb(Message message) async {
    print("Message : ${message.message}");
    map = message.toMap();

    print("Map : $map");
    _collectionReference = Firestore.instance
        .collection("messages")
        .document(message.senderUid)
        .collection(userObj.iddriver.toString());

    _collectionReference.add(map).whenComplete(() {
      print("Messages added to db");
    });

    _collectionReference = Firestore.instance
        .collection("messages")
        .document(userObj.iddriver.toString())
        .collection(message.senderUid);

    _collectionReference.add(map).whenComplete(() {
      print("Messages added to db");
    });

    _messageController.text = "";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(userObj.name),
          actions: <Widget>[
            PopupMenuButton(
              onSelected: (value) {
                print(value);
                choice = value.toString();
                clearChat();
              },
              itemBuilder: (BuildContext context) {
                return listAction.map((item) {
                  return PopupMenuItem(
                    value: item.index,
                    child: Text(item.name),
                  );
                }).toList();
              },
            ),
          ],
        ),
        body: Form(
          key: _formKey,
          child: _senderuid == null
              ? Container(
                  child: CircularProgressIndicator(),
                )
              : Column(
                  children: <Widget>[
                    //buildListLayout(),
                    chatMessagesListWidget(),
                    Divider(
                      height: 20.0,
                      color: Colors.black,
                    ),
                    chatInputWidget(),
                    SizedBox(
                      height: 10.0,
                    )
                  ],
                ),
        ));
  }

  Widget chatInputWidget() {
    return Container(
      height: 55.0,
      margin: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Row(
        children: <Widget>[
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 4.0),
            child: IconButton(
              splashColor: Colors.white,
              icon: Icon(
                Icons.camera_alt,
                color: Colors.black,
              ),
              onPressed: () {
                pickImage();
              },
            ),
          ),
          Flexible(
            child: TextFormField(
              // ignore: missing_return
              validator: (String input) {
                if (input.isEmpty) {
                  return "Please enter message";
                }
              },
              controller: _messageController,
              decoration: InputDecoration(
                  hintText: "Enter message...",
                  labelText: "Message",
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0))),
              onFieldSubmitted: (value) {
                _messageController.text = value;
              },
            ),
          ),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 4.0),
            child: IconButton(
              splashColor: Colors.white,
              icon: Icon(
                Icons.send,
                color: Colors.black,
              ),
              onPressed: () {
                if (_formKey.currentState.validate()) {
                  sendMessage();
                }
              },
            ),
          )
        ],
      ),
    );
  }

  Future<String> pickImage() async {
    var selectedImage =
        await ImagePicker.pickImage(source: ImageSource.gallery);
    setState(() {
      imageFile = selectedImage;
    });
    _storageReference = FirebaseStorage.instance
        .ref()
        .child('${DateTime.now().millisecondsSinceEpoch}');
    StorageUploadTask storageUploadTask = _storageReference.putFile(imageFile);
    var url = await (await storageUploadTask.onComplete).ref.getDownloadURL();

    print("URL: $url");
    uploadImageToDb(url);
    return url;
  }

  void uploadImageToDb(String downloadUrl) {
    _message = Message.withoutMessage(
        receiverUid: userObj.iddriver.toString(),
        senderUid: _senderuid,
        photoUrl: downloadUrl,
        timestamp: FieldValue.serverTimestamp(),
        type: 'image');
    var map = Map<String, dynamic>();
    map['senderUid'] = _message.senderUid;
    map['receiverUid'] = _message.receiverUid;
    map['type'] = _message.type;
    map['timestamp'] = _message.timestamp;
    map['photoUrl'] = _message.photoUrl;

    _collectionReference = Firestore.instance
        .collection("messages")
        .document(_message.senderUid)
        .collection(userObj.iddriver.toString());

    _collectionReference.add(map).whenComplete(() {
      print("Messages added to db");
    });

    _collectionReference = Firestore.instance
        .collection("messages")
        .document(userObj.iddriver.toString())
        .collection(_message.senderUid);

    _collectionReference.add(map).whenComplete(() {
      print("Messages added to db");
    });
  }

  void sendMessage() async {
    print("Inside send message");
    var text = _messageController.text;
    print(text);
    _message = Message(
        receiverUid: userObj.iddriver.toString(),
        senderUid: _senderuid,
        message: text,
        timestamp: FieldValue.serverTimestamp(),
        type: 'text');
    print(
        "receiverUid: ${userObj.iddriver.toString()} , senderUid : $_senderuid , message: $text");
    print(
        "timestamp: ${DateTime.now().millisecond}, type: ${text != null ? 'text' : 'image'}");
    addMessageToDb(_message);
    api.sendFcm(userObj.token, text);
  }

  Future<UserObj> getUID() async {
    //FirebaseUser user = await _firebaseAuth.currentUser();
    UserObj userObj = Provider.of<UserObj>(context, listen: false);
    return userObj;
  }

  Future<DocumentSnapshot> getSenderPhotoUrl(String uid) {
    var senderDocumentSnapshot =
        Firestore.instance.collection('users').document(uid).get();
    return senderDocumentSnapshot;
  }

  Future<DocumentSnapshot> getReceiverPhotoUrl(String uid) {
    var receiverDocumentSnapshot =
        Firestore.instance.collection('users').document(uid).get();
    return receiverDocumentSnapshot;
  }

  Widget chatMessagesListWidget() {
    print("SENDERUID : $_senderuid");
    return Flexible(
      child: StreamBuilder(
        stream: Firestore.instance
            .collection('messages')
            .document(_senderuid)
            .collection(userObj.iddriver.toString())
            .orderBy('timestamp', descending: false)
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else {
            listItem = snapshot.data.documents;
            return ListView.builder(
              padding: EdgeInsets.all(10.0),
              itemBuilder: (context, index) =>
                  chatMessageItem(snapshot.data.documents[index]),
              itemCount: snapshot.data.documents.length,
            );
          }
        },
      ),
    );
  }

  Widget chatMessageItem(DocumentSnapshot documentSnapshot) {
    //return buildChatLayout(documentSnapshot);
    String text = documentSnapshot['message'];
    bool isme = documentSnapshot['senderUid'] == _senderuid;
    return (ChatMessage(
      text: text,
      senderPhotoUrl: senderPhotoUrl,
      receiverPhotoUrl: receiverPhotoUrl,
      isMe: isme,
    ));
  }

  Widget buildChatLayout(DocumentSnapshot snapshot) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.all(12.0),
          child: Row(
            mainAxisAlignment: snapshot['senderUid'] == _senderuid
                ? MainAxisAlignment.end
                : MainAxisAlignment.start,
            children: <Widget>[
              snapshot['senderUid'] == _senderuid
                  ? CircleAvatar(
                      backgroundImage: senderPhotoUrl == null
                          ? AssetImage('assets/blankimage.png')
                          : NetworkImage(senderPhotoUrl),
                      radius: 20.0,
                    )
                  : CircleAvatar(
                      backgroundImage: receiverPhotoUrl == null
                          ? AssetImage('assets/blankimage.png')
                          : NetworkImage(receiverPhotoUrl),
                      radius: 20.0,
                    ),
              SizedBox(
                width: 10.0,
              ),
              /* Text(
                snapshot['message'],
                maxLines: 2,
                overflow: TextOverflow.visible,
                style: TextStyle(
                    color: Colors.black, fontSize: 14.0),
              ),*/
              SizedBox(
                width: 200,
                child: Text(
                  snapshot['message'],
                  maxLines: 2,
                  overflow: TextOverflow.visible,
                  softWrap: true,
                  style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 20.0),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  void clearChat() {
    DialogUtils.showCustomDialog(context, title: "Confirm delete?",
        okBtnFunction: () {
      Navigator.pop(context);
      Firestore.instance
          .collection('messages')
          .document(_senderuid)
          .collection(userObj.iddriver.toString())
          .getDocuments()
          .then((snapshot) {
        for (DocumentSnapshot ds in snapshot.documents) {
          ds.reference.delete();
        }
      });
    });
  }
}

class MyAction {
  String name;
  int index;

  MyAction({this.name, this.index});

  MyAction.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    index = json['index'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['index'] = this.index;
    return data;
  }
}

class ChatMessage extends StatelessWidget {
  final String text;

  final String senderPhotoUrl;

  final String receiverPhotoUrl;

  final bool isMe;

  const ChatMessage(
      {Key key,
      this.text,
      this.senderPhotoUrl,
      this.receiverPhotoUrl,
      this.isMe})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    String txt = getPrettyString(text);
    if (isMe) {
      return Card(
        elevation: 0.5,
        child: ListTile(
          isThreeLine: true,
          trailing: CircleAvatar(
            backgroundImage: senderPhotoUrl == null
                ? AssetImage('assets/blankimage.png')
                : NetworkImage(senderPhotoUrl),
            radius: 20.0,
          ),
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(" "),
              //Text(name, style: Theme.of(context).textTheme.subhead),
            ],
          ),
          subtitle: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(" "),
              Text("$txt"),
            ],
          ),
        ),
      );
    }
    return ListTile(
      contentPadding: EdgeInsets.only(
        left: 15.0,
      ),
      isThreeLine: true,
      /*leading: new CircleAvatar(
        child: new Text(name[0]),
      ),*/
      leading: CircleAvatar(
        backgroundImage: receiverPhotoUrl == null
            ? AssetImage('assets/blankimage.png')
            : NetworkImage(receiverPhotoUrl),
        radius: 20.0,
      ),
      //title: Text(name,style: Theme.of(context).textTheme.subhead),
      subtitle: Text("$txt"),
    );
  }

  String getPrettyString(String str) {
    for (int i = 1; i < str.length; i++) {
      if (i % 30 == 0) {
        str = "${str.substring(0, i)} \n ${str.substring(i)}";
      }
    }
    return str;
  }
}
