import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:talk_e/models/call.dart';
import 'package:talk_e/services/consts.dart';

class CallMethods{

  final CollectionReference callCollection = FirebaseFirestore.instance.
  collection(CALL_COLLECTION);

  Future<bool> makeCall({required Call call}) async{
   try{
     call.hasDialed = true;
     Map<String , dynamic> hasDialedMap = call.toMap(call);

     call.hasDialed = false;
     Map<String , dynamic> hasNotDialedMap = call.toMap(call);

     await callCollection.doc(call.callerId).set(hasDialedMap);
     await callCollection.doc(call.receiverId).set(hasNotDialedMap);
     return true;
   }
   catch(e){
     print(e.toString());
    return false;
   }
  }
  Future<bool> endCall({required Call call}) async{
    try{
      await callCollection.doc(call.callerId).delete();
      await callCollection.doc(call.receiverId).delete();
      return true;
    }
     catch(e){
      print(e.toString());
      return false;
     }
  }
}