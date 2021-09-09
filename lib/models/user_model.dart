class UserModel{
  String name;
  String email;
  String phone;
  String uId;
  String image;
  String cover;
  String bio;

  UserModel({
    this.phone,
    this.email,
    this.name,
    this.uId,
    this.image,
    this.cover,
    this.bio
});
  
  Map<String,dynamic> toJson(){
    return {
      'name' : name,
      'email' : email,
      'phone' : phone,
      'uId' : uId,
      'image' : image,
      'cover' : cover,
      'bio' : bio,
    };
  }

  UserModel.fromJson(Map<String,dynamic> json){
    name = json['name'];
    email = json['email'];
    phone = json['phone'];
    uId = json['uId'];
    image = json['image'];
    cover = json['cover'];
    bio = json['bio'];
  }
}