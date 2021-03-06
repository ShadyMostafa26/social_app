class MessageModel{
  String senderId;
  String receiverId;
  String dateTime;
  String text;

  MessageModel({
    this.dateTime,
    this.text,
    this.senderId,
    this.receiverId,
});

  MessageModel.fromJson(Map<String,dynamic> json){
    senderId = json['senderId'];
    receiverId = json['receiverId'];
    dateTime = json['dateTime'];
    text = json['text'];
  }

  Map<String,dynamic> toJson(){
    return {
      'senderId' : senderId,
      'receiverId' : receiverId,
      'dateTime' : dateTime,
      'text' : text,
    };
  }
}