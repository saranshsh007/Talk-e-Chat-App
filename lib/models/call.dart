class Call{
  late String callerId;
  late String receiverId;
  late String channelId;
  late bool hasDialed ;

  Call({required this.callerId ,
  required this.receiverId,
  required this. channelId,
  required this.hasDialed
  });

  Map<String , dynamic> toMap(Call call){
    Map<String , dynamic> callMap = Map();
    callMap["caller_id"] = call.callerId;
    callMap["receiver_id"] = call.receiverId;
    callMap["channel_id"] = call.channelId;
    callMap["has_dialed"] = call.hasDialed;
    return callMap;
  }

  Call.fromMap(Map callMap) {

    this.receiverId = callMap["receiver_id"];
    this. channelId = callMap["channel_id"];
    this.hasDialed = callMap["has_dialed"];

  }
}

