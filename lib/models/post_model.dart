class PostModel{
  String text;
  String postImage;
  String dateTime;
  String uId;
  String image;
  String name;

  PostModel({
    this.text,
    this.postImage,
    this.dateTime,
    this.uId,
    this.name,
    this.image,
});

  Map<String,dynamic> toJson(){
    return {
      'text' : text,
      'postImage' : postImage,
      'dateTime' : dateTime,
      'uId' : uId,
      'name' : name,
      'image' : image,
    };
  }

  PostModel.fromJson(Map<String,dynamic> json){
    text = json['text'];
    postImage = json['postImage'];
    dateTime = json['dateTime'];
    uId = json['uId'];
    name = json['name'];
    image = json['image'];
  }
}