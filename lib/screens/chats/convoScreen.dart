import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:talk_e/screens/chats/camerapage.dart';
import 'package:talk_e/screens/chats/camerascreen.dart';
import 'package:talk_e/services/call_utilities.dart';
import 'package:talk_e/services/consts.dart';
import 'package:talk_e/services/database.dart';
import 'dart:async';
import '../../constants.dart';

class convoScreen extends StatefulWidget {
 String chatRoomId;

  convoScreen({required this.chatRoomId});

  @override
  _convoScreenState createState() => _convoScreenState();
}

class _convoScreenState extends State<convoScreen> {
  DatabaseMethods databaseMethods = new DatabaseMethods();
  TextEditingController messageController = new TextEditingController();

  var chatMessageStream;

  Widget ChatMessageList() {
    return StreamBuilder(
      stream: chatMessageStream,
      builder: (context, snapshot) {
        return snapshot.hasData ? ListView.builder(
            itemCount: (snapshot.data! as QuerySnapshot).docs.length,
            itemBuilder: (context, index) {
              return MessageTile( message : (snapshot.data! as QuerySnapshot).docs[index]["message"],
                isSendByMe: (snapshot.data! as QuerySnapshot).docs[index]["sendBy"] == Consts.myName,);
            }) : Container();
      },
    );
  }

  sendMessage() {
    if (messageController.text.isNotEmpty) {
      Map<String, dynamic> messageMap = {
        "message": messageController.text,
        "sendBy": Consts.myName,
        "time" : DateTime.now().millisecondsSinceEpoch ,
      };
      databaseMethods.addConversationMessages(widget.chatRoomId, messageMap);
      messageController.text = "";
    }
  }

  @override
  void initState() {
    databaseMethods.getConversationMessages(widget.chatRoomId).then((value) {
      chatMessageStream = value;
    setState(() {

      });
    });
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Chat Screen"),
        actions: [
         IconButton(onPressed: (){}, icon: Icon(Icons.call)),
          IconButton(onPressed: (){}, icon: Icon(Icons.videocam)),
          SizedBox(width: 5,)
        ],
      ),
      body: Container(
        child: Stack(
          children: [
            ChatMessageList(),
            Container(
              child: Container(alignment: Alignment.bottomRight,
                child: SafeArea(
                  child: Row(
                    children: [
                      Expanded(
                        child: Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: kDefaultPadding * 0.75,
                          ),
                          decoration: BoxDecoration(
                            color: kPrimaryColor.withOpacity(0.05),
                            borderRadius: BorderRadius.circular(40),
                          ),
                          child: Row(
                            children: [
                              IconButton(onPressed: (){}, icon: Icon(Icons.sentiment_satisfied_alt_outlined,),
                                color: Theme.of(context)
                                    .textTheme
                                    .bodyText1!
                                    .color!
                                    .withOpacity(0.64),),
                              SizedBox(width: kDefaultPadding / 4),
                              Expanded(
                                child: TextField(
                                  controller: messageController,
                                  decoration: InputDecoration(
                                    hintText: "Type a new message...",
                                    border: InputBorder.none,
                                  ),
                                ),
                              ),
                              Icon(
                                Icons.attach_file,
                                color: Theme.of(context)
                                    .textTheme
                                    .bodyText1!
                                    .color!
                                    .withOpacity(0.64),
                              ),
                              SizedBox(width: kDefaultPadding / 4),
                              IconButton(onPressed: (){
                                Navigator.push(context, MaterialPageRoute(builder: (context)=> cameraScreen()));
                              },
                                  color: Theme.of(context)
                                  .textTheme
                                  .bodyText1!
                                  .color!
                                  .withOpacity(0.64), icon: Icon(Icons.camera_alt),),
                              SizedBox(width: kDefaultPadding / 4),
                              IconButton(
                                  onPressed: () => sendMessage(),
                                  icon: Icon(
                                    Icons.send,
                                    color: Colors.green,
                                  )),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MessageTile extends StatelessWidget {
  final String message;
  final bool isSendByMe;

  MessageTile({required this.message , required this.isSendByMe});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(left: isSendByMe ? 0:15, right: isSendByMe ? 15 :0),
      margin: EdgeInsets.symmetric(vertical: 5),
      width: MediaQuery.of(context).size.width,
      alignment: isSendByMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 24 , vertical: 8),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: isSendByMe ? [
              const Color(0xFF69F0AE),
              const Color(0xFFEEFF41)
            ] :
              [
                const Color(0xFFFF4081),
                const Color(0xFF18FFFF)
              ]
          ),
          borderRadius: isSendByMe ?
              BorderRadius.only(
                topLeft: Radius.circular(23),
                topRight: Radius.circular(23),
                bottomLeft: Radius.circular(23),
              ) :
              BorderRadius.only(
                topRight: Radius.circular(23),
                topLeft: Radius.circular(23),
                bottomRight: Radius.circular(23),
              ),
        ),
        child: Text(message , style: TextStyle(
          color: Colors.black,
          fontSize: 17
        ),),
      ),
    );
  }
}
