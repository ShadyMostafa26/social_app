import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:social_app/models/message_model.dart';
import 'package:social_app/models/post_model.dart';
import 'package:social_app/models/user_model.dart';
import 'package:social_app/modules/chats/chats_screen.dart';
import 'package:social_app/modules/feeds/feed_screen.dart';
import 'package:social_app/modules/login/login_screen.dart';
import 'package:social_app/modules/settings/settings_screen.dart';
import 'package:social_app/modules/users/users_screen.dart';
import 'package:social_app/shared/components/components.dart';
import 'package:social_app/shared/components/constatnts.dart';
import 'package:social_app/shared/cubit/states.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:social_app/shared/network/local/cache_helper.dart';

class AppCubit extends Cubit<AppStates> {
  AppCubit() : super(AppInitialState());

  static AppCubit get(context) => BlocProvider.of(context);

  IconData iconLogin = Icons.visibility;
  bool isHiddenLogin = true;

  void changeIconPasswordLoginVisibility() {
    isHiddenLogin = !isHiddenLogin;
    iconLogin = isHiddenLogin ? Icons.visibility : Icons.visibility_off;
    emit(AppChangePasswordVisibleState());
  }

  IconData icon = Icons.visibility;
  bool isHidden = true;

  void changeIconPasswordVisibility() {
    isHidden = !isHidden;
    icon = isHidden ? Icons.visibility : Icons.visibility_off;
    emit(AppChangePasswordVisibleState());
  }

/////////////////////////////////////////////////////

  List<Widget> screens = [
    FeedsScreen(),
    ChatScreen(),
   // UsersScreen(),
    SettingScreen(),
  ];

  List<String> titles = [
    'News Feeds',
    'Chats',
   // 'Users',
    'Setting',
  ];

  int currentIndex = 0;

  void changeBottomNav(index) {
    currentIndex = index;
    if (currentIndex == 1) getUsers();
    emit(AppChangeBottomNavState());
  }

/////////////////////////////////////////////////////

  void login({
    @required String email,
    @required String password,
  }) {
    emit(AppLoginLoadingState());
    FirebaseAuth.instance
        .signInWithEmailAndPassword(
      email: email,
      password: password,
    )
        .then((value) {
      emit(AppLoginSuccessState(value.user.uid));
    }).catchError((error) {
      print(error.toString());
      emit(AppLoginErrorState(error.toString()));
    });
  }

  void signOut(context) {
    FirebaseAuth.instance.signOut().then((value) {
      CacheHelper.removeData(key: 'uId');
      navigateAndFinish(context, LoginScreen());
      currentIndex = 0;
      emit(SocialLogoutSuccessState());
    }).catchError((error) {
      emit(SocialLogoutErrorState());
    });
  }

  void register({
    @required String email,
    @required String name,
    @required String phone,
    @required String password,
  }) {
    emit(AppRegisterLoadingState());
    FirebaseAuth.instance
        .createUserWithEmailAndPassword(
      email: email,
      password: password,
    )
        .then((value) {
      createUser(
        email: value.user.email,
        name: name,
        phone: phone,
        uId: value.user.uid,
      );
    }).catchError((error) {
      print(error.toString());
      emit(AppRegisterErrorState());
    });
  }

  void createUser({
    @required String email,
    @required String name,
    @required String phone,
    @required String uId,
  }) {
    UserModel userModel = UserModel(
      email: email,
      phone: phone,
      name: name,
      uId: uId,
      bio: 'write your bio...',
      image:
          'https://media.istockphoto.com/vectors/default-profile-picture-avatar-photo-placeholder-vector-illustration-vector-id1223671392?k=6&m=1223671392&s=612x612&w=0&h=NGxdexflb9EyQchqjQP0m6wYucJBYLfu46KCLNMHZYM=',
      cover:
          'https://www.timelinecoverphotomaker.com/sites/default/files/facebook-cover-photos/2013/11/beautiful-sun-rays-facebook-cover-photo.jpg',
    );
    FirebaseFirestore.instance
        .collection('users')
        .doc(uId)
        .set(userModel.toJson())
        .then((value) {
      emit(AppCreateUserSuccessState(userModel));
    }).catchError((error) {
      print(error.toString());
      emit(AppCreateUserErrorState());
    });
  }

//////////////////////////////////////////////////////////

  UserModel theUserModel;

  void getUserData() {
    emit(AppGetUserDataLoadingState());
    FirebaseFirestore.instance.collection('users').doc(uId).get().then((value) {
      theUserModel = UserModel.fromJson(value.data());
      emit(AppGetUserDataSuccessState());
    }).catchError((error) {
      print(error.toString());
      emit(AppGetUserDataErrorState());
    });
  }

  var picker = ImagePicker();
  File profileImage;

  Future pickProfileImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      profileImage = File(pickedFile.path);
      emit(GetPickProfileImageSuccessState());
    } else {
      print('No image selected');
      emit(GetPickProfileImageErrorState());
    }
  }

  File coverImage;

  Future pickCoverImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      coverImage = File(pickedFile.path);
      emit(GetPickCoverImageSuccessState());
    } else {
      print('no image selected');
      emit(GetPickCoverImageErrorState());
    }
  }

  void uploadProfileImage({
    @required String name,
    @required String phone,
    @required String bio,
  }) {
    emit(UpdateUserLoadingState());
    firebase_storage.FirebaseStorage.instance
        .ref()
        .child('users/${Uri.file(profileImage.path).pathSegments.last}')
        .putFile(profileImage)
        .then((value) {
      value.ref.getDownloadURL().then((value) {
        updateUser(name: name, phone: phone, bio: bio, image: value);
        getUserData();
      }).catchError((error) {
        emit(UploadProfileImageErrorState());
      });
    }).catchError((error) {
      emit(UploadProfileImageErrorState());
    });
  }

  void uploadCoverImage({
    @required String name,
    @required String phone,
    @required String bio,
  }) {
    emit(UpdateUserLoadingState());
    firebase_storage.FirebaseStorage.instance
        .ref()
        .child('users/${Uri.file(coverImage.path).pathSegments.last}')
        .putFile(coverImage)
        .then((value) {
      value.ref.getDownloadURL().then((value) {
        updateUser(name: name, phone: phone, bio: bio, cover: value);
      }).catchError((error) {
        emit(UploadCoverImageErrorState());
      });
    }).catchError((error) {
      emit(UploadCoverImageErrorState());
    });
  }

  void updateUser({
    @required String name,
    @required String phone,
    @required String bio,
    String image,
    String cover,
  }) {
    emit(UpdateUserLoadingState());
    UserModel userModel = UserModel(
      name: name,
      phone: phone,
      bio: bio,
      email: theUserModel.email,
      uId: theUserModel.uId,
      image: image ?? theUserModel.image,
      cover: cover ?? theUserModel.cover,
    );
    FirebaseFirestore.instance
        .collection('users')
        .doc(theUserModel.uId)
        .update(userModel.toJson())
        .then((value) {
      getUserData();
    }).catchError((error) {
      print(error.toString());
      emit(UpdateUserErrorState());
    });
  }

//////////////////////////////////////////////////////////////////////

  File postImage;

  Future pickPostImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      postImage = File(pickedFile.path);
      emit(GetPickPostImageSuccessState());
    } else {
      print('no image');
      emit(GetPickPostImageErrorState());
    }
  }

  void removeImage() {
    postImage = null;
    emit(RemoveImageState());
  }

  void uploadPostImage({
    @required String text,
    @required String dateTime,
  }) {
    emit(AddPostLoadingState());
    firebase_storage.FirebaseStorage.instance
        .ref()
        .child('posts/${Uri.file(postImage.path).pathSegments.last}')
        .putFile(postImage)
        .then((value) {
      value.ref.getDownloadURL().then((value) {
        addPost(text: text, dateTime: dateTime, postImage: value);
      }).catchError((error) {
        emit(UploadPostImageErrorState());
      });
    }).catchError((error) {
      print(error.toString());
      emit(UploadPostImageErrorState());
    });
  }

  void addPost({
    @required String text,
    @required String dateTime,
    String postImage,
  }) {
    emit(AddPostLoadingState());

    PostModel postModel = PostModel(
      image: theUserModel.image,
      name: theUserModel.name,
      uId: theUserModel.uId,
      postImage: postImage ?? '',
      dateTime: dateTime,
      text: text,
    );

    FirebaseFirestore.instance
        .collection('posts')
        .add(postModel.toJson())
        .then((value) {
      emit(AddPostSuccessState());
    }).catchError((error) {
      print(error.toString());
      emit(AddPostErrorState());
    });
  }

  PostModel postModel;
  List<PostModel> posts = [];
  List<String> postId = [];
  List<int> likes = [];

  void getPost() {
    posts = [];
    emit(GetPostLoadingState());
    FirebaseFirestore.instance
        .collection('posts')
        .where('uId', isNotEqualTo: '$uId')
        .get()
        .then((value) {
      value.docs.forEach((element) {
        element.reference.collection('likes').get().then((value) {
          likes.add(value.docs.length);
          postId.add(element.id);
          posts.add(PostModel.fromJson(element.data()));
          emit(GetPostSuccessState());
        }).catchError((error) {});

        emit(GetPostSuccessState());
      });
    }).catchError((error) {
      emit(GetPostErrorState());
    });
  }

  List<PostModel> userPosts = [];
  Future getUserPost(userUid) async{
    emit(GetUserPostLoadingState());
   return await FirebaseFirestore.instance
        .collection('posts')
        .get()
        .then((value) {
      value.docs.forEach((element) {
        if((element.data()['uId']) == userUid)
        userPosts.add(PostModel.fromJson(element.data()));
        emit(GetUserPostSuccessState());
      });
    }).catchError((error) {
      emit(GetUserPostErrorState());
    });
  }

  void likePost(String postId) {
    FirebaseFirestore.instance
        .collection('posts')
        .doc(postId)
        .collection('likes')
        .doc(theUserModel.uId)
        .set({
      'like': true,
    }).then((value) {
      emit(LikePostSuccessState());
    }).catchError((error) {
      emit(LikePostErrorState());
    });
  }

  List<UserModel> users;

  void getUsers() {
    users = [];
    emit(GetAllUsersLoadingState());
    FirebaseFirestore.instance.collection('users').get().then((value) {
      value.docs.forEach((element) {
        if (element.data()['uId'] != theUserModel.uId)
          users.add(UserModel.fromJson(element.data()));
      });
      emit(GetAllUsersSuccessState());
    }).catchError((error) {
      emit(GetAllUsersErrorState());
    });
  }

  void sendMessage({
    @required String receiverId,
    @required String dateTime,
    @required String text,
  }) {
    MessageModel messageModel = MessageModel(
      text: text,
      dateTime: dateTime,
      receiverId: receiverId,
      senderId: theUserModel.uId,
    );

    FirebaseFirestore.instance
        .collection('users')
        .doc(theUserModel.uId)
        .collection('chats')
        .doc(receiverId)
        .collection('messages')
        .add(messageModel.toJson())
        .then((value) {
      emit(SendMessageSuccessState());
    }).catchError((error) {
      emit(SendMessageErrorState());
    });

    FirebaseFirestore.instance
        .collection('users')
        .doc(receiverId)
        .collection('chats')
        .doc(theUserModel.uId)
        .collection('messages')
        .add(messageModel.toJson())
        .then((value) {
      emit(SendMessageSuccessState());
    }).catchError((error) {
      emit(SendMessageErrorState());
    });
  }

  List<MessageModel> messages = [];

  void getMessages({
    @required String receiverId,
  }) {
    FirebaseFirestore.instance
        .collection('users')
        .doc(theUserModel.uId)
        .collection('chats')
        .doc(receiverId)
        .collection('messages')
        .orderBy('dateTime')
        .snapshots()
        .listen((event) {
      messages = [];
      event.docs.forEach((element) {
        messages.add(MessageModel.fromJson(element.data()));
      });
      emit(GetMessageSuccessState());
    });
  }
}
