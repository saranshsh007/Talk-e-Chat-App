import 'package:flutter/material.dart';
import 'package:talk_e/models/call.dart';
import 'package:talk_e/services/callmethods.dart';

class callScreen extends StatefulWidget {

  late final Call call;
  callScreen({required this.call});

  @override
  _callScreenState createState() => _callScreenState();
}

class _callScreenState extends State<callScreen> {
  CallMethods callMethods = CallMethods();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        alignment: Alignment.center,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text("Call has been made"),
            MaterialButton(onPressed: (){
              callMethods.endCall(call : widget.call);
              Navigator.pop(context);
            } ,
              color: Colors.red,
              child: Icon(Icons.call_end,
              color: Colors.white,),),
          ],
        ),
      ),
    );
  }
}
