import 'package:social_app/models/user_model.dart';

abstract class AppStates{}

class AppInitialState extends AppStates{}

class AppChangePasswordVisibleState extends AppStates{}

class AppChangeBottomNavState extends AppStates{}

class AppLoginLoadingState extends AppStates{}
class AppLoginSuccessState extends AppStates{
  final uId;
  AppLoginSuccessState(this.uId);
}
class AppLoginErrorState extends AppStates{
  final String error;

  AppLoginErrorState(this.error);
}

class AppRegisterLoadingState extends AppStates{}
class AppRegisterSuccessState extends AppStates{}
class AppRegisterErrorState extends AppStates{}

class AppCreateUserLoadingState extends AppStates{}
class AppCreateUserSuccessState extends AppStates{
  final UserModel userModel;
  AppCreateUserSuccessState(this.userModel);
}
class AppCreateUserErrorState extends AppStates{}

class AppGetUserDataLoadingState extends AppStates{}
class AppGetUserDataSuccessState extends AppStates{}
class AppGetUserDataErrorState extends AppStates{}

class GetPickProfileImageSuccessState extends AppStates{}
class GetPickProfileImageErrorState extends AppStates{}

class GetPickCoverImageSuccessState extends AppStates{}
class GetPickCoverImageErrorState extends AppStates{}

class UploadProfileImageSuccessState extends AppStates{}
class UploadProfileImageErrorState extends AppStates{}

class UploadCoverImageSuccessState extends AppStates{}
class UploadCoverImageErrorState extends AppStates{}

class UpdateUserLoadingState extends AppStates{}
class UpdateUserSuccessState extends AppStates{}
class UpdateUserErrorState extends AppStates{}

class GetPickPostImageSuccessState extends AppStates{}
class GetPickPostImageErrorState extends AppStates{}

class RemoveImageState extends AppStates{}

class AddPostLoadingState extends AppStates{}
class AddPostSuccessState extends AppStates{}
class AddPostErrorState extends AppStates{}

class UploadPostImageSuccessState extends AppStates{}
class UploadPostImageErrorState extends AppStates{}

class GetPostLoadingState extends AppStates{}
class GetPostSuccessState extends AppStates{}
class GetPostErrorState extends AppStates{}

class LikePostSuccessState extends AppStates{}
class LikePostErrorState extends AppStates{}

class SocialLogoutSuccessState extends AppStates{}
class SocialLogoutErrorState extends AppStates{}

class GetAllUsersLoadingState extends AppStates{}
class GetAllUsersSuccessState extends AppStates{}
class GetAllUsersErrorState extends AppStates{}

class SendMessageSuccessState extends AppStates{}
class SendMessageErrorState extends AppStates{}


class GetMessageSuccessState extends AppStates{}
class GetMessageErrorState extends AppStates{}


class GetUserPostLoadingState extends AppStates{}
class GetUserPostSuccessState extends AppStates{}
class GetUserPostErrorState extends AppStates{}