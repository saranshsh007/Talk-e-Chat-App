import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:talk_e/screens/chats/components/body.dart';
import 'package:talk_e/screens/chats/convoScreen.dart';
import 'package:talk_e/screens/chats/helperfunction.dart';
import 'package:talk_e/screens/chats/search.dart';
import 'package:talk_e/screens/signinOrSignUp/signinUI.dart';
import 'package:talk_e/services/auth.dart';
import 'package:talk_e/services/consts.dart';
import 'package:talk_e/services/database.dart';
import '../../constants.dart';

class ChatsScreen extends StatefulWidget {
  @override
  _ChatsScreenState createState() => _ChatsScreenState();
}

class _ChatsScreenState extends State<ChatsScreen> {
  AuthMethods authMethods = new AuthMethods();
  DatabaseMethods databaseMethods = new DatabaseMethods();

  var chatRoomStream;

  Widget chatRoomList() {
    return StreamBuilder(
      stream: chatRoomStream,
      builder: (context, snapshot) {
        return snapshot.hasData
            ? ListView.builder(
                itemCount: (snapshot.data! as QuerySnapshot).docs.length,
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  return ChatRoomTile(
                      userName: (snapshot.data! as QuerySnapshot)
                          .docs[index]["chatroomId"]
                          .toString()
                          .replaceAll("_", "")
                          .replaceAll(Consts.myName, ""),
                      chatRoomId: (snapshot.data! as QuerySnapshot).docs[index]
                          ["chatroomId"]);
                })
            : Container(
                child: Center(
                  child: Text("Click on search icon to start a new conversation"),
                ),
              );
      },
    );
  }

  @override
  void initState() {
    getUserInfo();
    super.initState();
  }

  getUserInfo() async {
    Consts.myName = (await HelperFunctions.getUserNameSharedPreference())!;
    databaseMethods.getChatRooms(Consts.myName).then((snapshot) {
      setState(() {
        chatRoomStream = snapshot;
        print(
            "we got the data + ${chatRoomStream.toString()} this is name ${Consts.myName}");
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(),
      body: Container(
        child: chatRoomList(),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => searchScreen()));
        },
        backgroundColor: kPrimaryColor,
        child: Icon(
          Icons.person_add_alt_1,
          color: Colors.white,
        ),
      ),
    );
  }

  AppBar buildAppBar() {
    return AppBar(
      automaticallyImplyLeading: false,
      title: Text("Talk-e chats"),
      actions: [
        IconButton(
          icon: Icon(Icons.search),
          onPressed: () => Navigator.push(
              context, MaterialPageRoute(builder: (context) => searchScreen())),
          tooltip: "Search",
        ),
        IconButton(
          onPressed: () {
            authMethods.signOut();
            showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    title: Text("Do you want to Sign out ?"),
                    actions: [
                      TextButton(
                          onPressed: () {
                            Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => SignIn()));
                          },
                          child: Text("Yes", style: TextStyle(fontSize: 20))),
                      TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: Text("No", style: TextStyle(fontSize: 20))),
                    ],
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(30))),
                    elevation: 24.0,
                  );
                });
          },
          icon: Icon(Icons.exit_to_app),
          tooltip: "Sign-Out",
        ),
      ],
    );
  }
}

class ChatRoomTile extends StatelessWidget {
  final String userName;
  final String chatRoomId;

  ChatRoomTile({required this.userName, required this.chatRoomId});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => convoScreen(
                      chatRoomId: chatRoomId,
                    )));
      },
      child: Container(
        width: MediaQuery.of(context).size.width,
        padding: EdgeInsets.symmetric(horizontal: 24, vertical: 15),
        child: Row(
          children: [
            Container(
              height: 60,
              width: 60,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: Colors.blue,
                borderRadius: BorderRadius.circular(40),
              ),
              child: Text(
                userName.substring(0, 1).toUpperCase(),
                style: TextStyle(color: Colors.black, fontSize: 17),
              ),
            ),
            SizedBox(
              width: 8,
            ),
            Text(
              userName,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold
              ),
            )
          ],
        ),
      ),
    );
  }
}
