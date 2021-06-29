import 'package:flutter/cupertino.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:talk_e/screens/chats/convoScreen.dart';
import 'package:talk_e/services/consts.dart';
import 'package:talk_e/services/database.dart';
import 'package:talk_e/theme.dart';
import 'package:path/path.dart' as path;

import 'helperfunction.dart';

class searchScreen extends StatefulWidget {
  @override
  _searchScreenState createState() => _searchScreenState();
}

var _myName;
class _searchScreenState extends State<searchScreen> {


  DatabaseMethods databaseMethods = new DatabaseMethods();
  TextEditingController searchTextEditingController =
      new TextEditingController();

  var searchSnapshot;
  Widget searchList() {
    return searchSnapshot != null
        ? ListView.builder(
        itemCount: searchSnapshot.docs.length,
        shrinkWrap: true,
        itemBuilder: (context, index) {
          return SearchTile(userName: searchSnapshot.docs[index]["name"]);
        })
        : Container();
  }
  initiateSearch() {
    databaseMethods
        .getUserByUserName(searchTextEditingController.text)
        .then((snapshot) {
      setState(() {
        searchSnapshot = snapshot;
      });
    });
  }
  createChatroomAndStartConversation(
      {required String userName}) {

    if(userName != Consts.myName){
      List<String> users = [userName, Consts.myName];
      String chatRoomId = getChatRoomId(userName, Consts.myName);
      Map<String, dynamic> chatRoomMap = {
        "users": users,
        "chatroomId": chatRoomId,
      };

      DatabaseMethods().createChatRoom(chatRoomId, chatRoomMap);
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => convoScreen(chatRoomId : chatRoomId,)));
    }else{
      showDialog(context: context, builder: (context){
        return
          AlertDialog(
            title: Text("You cannot send message to yourself !!!"),
            actions: [
             FlatButton(onPressed: (){
               Navigator.of(context).pop();
             }, child: Text("ok",style: TextStyle(fontSize: 20 , color: Colors.blueAccent),)),
            ],
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(30))),
            elevation: 24.0,

          );
      });
    }

  }

  getUserInfo() async{
    _myName = (await HelperFunctions.getUserNameSharedPreference());

   setState(() {

   });
     print("${_myName}");
  }

  Widget SearchTile({required String userName}) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                userName,
                style: TextStyle(
                  fontSize: 16,
                ),
              )
            ],
          ),
          Spacer(),
          GestureDetector(
            onTap: () {
          createChatroomAndStartConversation(userName: userName);
            },
            child: Container(
              decoration: BoxDecoration(
                color: Colors.greenAccent[700],
                borderRadius: BorderRadius.circular(30),
              ),
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              child: Text("Message"),
            ),
          ),
        ],
      ),
    );
  }
  @override
  void initState() {
    getUserInfo();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("search users"),
      ),
      body: Container(
        child: Column(
          children: [
            Container(
              color: Colors.white10,
              padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
              child: Row(
                children: [
                  Expanded(
                      child: TextFormField(
                    controller: searchTextEditingController,
                    decoration: InputDecoration(
                      hintText: "Search username...",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      hintStyle: TextStyle(color: Colors.black54),
                     suffixIcon: IconButton(onPressed: (){initiateSearch();},icon: Icon(Icons.search),
                      tooltip: "search",
                     ),
                    ),
                  )),

                ],
              ),
            ),
            searchList(),
          ],
        ),
      ),
    );
  }
}

getChatRoomId(String a, String b) {
  if (a.substring(0, 1).codeUnitAt(0) > b.substring(0, 1).codeUnitAt(0)) {
    return "$b\_$a";
  } else {
    return "$a\_$b";
  }
}
