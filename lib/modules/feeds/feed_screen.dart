import 'package:conditional_builder/conditional_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:photo_view/photo_view.dart';
import 'package:social_app/models/post_model.dart';
import 'package:social_app/models/user_model.dart';
import 'package:social_app/modules/users/user_profile_screen.dart';
import 'package:social_app/shared/components/components.dart';
import 'package:social_app/shared/cubit/cubit.dart';
import 'package:social_app/shared/cubit/states.dart';
import 'package:social_app/shared/styles/icon_broken.dart';

class FeedsScreen extends StatefulWidget {
  @override
  _FeedsScreenState createState() => _FeedsScreenState();
}

class _FeedsScreenState extends State<FeedsScreen> {
  @override
  void initState() {
    super.initState();
    AppCubit.get(context).getUserData();
  }

  final postController = TextEditingController();

  final formKey = GlobalKey<FormState>();

  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, AppStates>(
      listener: (context, state) {},
      builder: (context, state) {
        var cubit = AppCubit.get(context);
        return ConditionalBuilder(
          condition: cubit.theUserModel != null &&
              AppCubit.get(context).posts.length > 0,
          builder: (context) {
            return SingleChildScrollView(
              physics: BouncingScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  InkWell(
                    onTap: () {
                      showModalBottomSheet(
                        isScrollControlled: true,
                        backgroundColor: Colors.white,
                        context: context,
                        builder: (context) {
                          return Padding(
                            padding: const EdgeInsets.all(40.0),
                            child: Column(
                              children: [
                                if (state is AddPostLoadingState)
                                  SizedBox(
                                    height: 13,
                                  ),
                                if (state is AddPostLoadingState)
                                  LinearProgressIndicator(
                                    backgroundColor: Colors.blue,
                                  ),
                                Row(
                                  children: [
                                    CircleAvatar(
                                      backgroundImage: NetworkImage(
                                        '${cubit.theUserModel.image}',
                                      ),
                                    ),
                                    Text(' ${cubit.theUserModel.name}'),
                                    Spacer(),
                                    TextButton(
                                      onPressed: () {
                                        if (cubit.postImage != null)
                                          cubit.uploadPostImage(
                                            text: postController.text,
                                            dateTime: DateTime.now().toString(),
                                          );
                                        if (cubit.postImage == null)
                                          cubit.addPost(
                                            text: postController.text,
                                            dateTime: DateTime.now().toString(),
                                          );

                                        postController.clear();
                                        cubit.postImage = null;
                                      },
                                      child: Text('POST'),
                                    )
                                  ],
                                ),
                                Expanded(
                                  child: TextFormField(
                                    controller: postController,
                                    decoration: InputDecoration(
                                        hintText: 'whats in your mind?',
                                        border: InputBorder.none),
                                  ),
                                ),
                                if (cubit.postImage != null)
                                  Container(
                                    width: double.infinity,
                                    height: 250,
                                    child: Stack(
                                      children: [
                                        PhotoView(
                                          imageProvider: FileImage(
                                            cubit.postImage,
                                          ),
                                          minScale:
                                              PhotoViewComputedScale.contained *
                                                  0.9,
                                          maxScale:
                                              PhotoViewComputedScale.contained *
                                                  2,
                                          backgroundDecoration: BoxDecoration(
                                            color: Colors.white,
                                          ),
                                        ),
                                        CircleAvatar(
                                          child: IconButton(
                                            icon: Icon(Icons.close),
                                            onPressed: () {
                                              cubit.removeImage();
                                            },
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                if (cubit.postImage != null)
                                  SizedBox(height: 5),
                                TextButton(
                                  onPressed: () {
                                    cubit.pickPostImage();
                                  },
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(IconBroken.Image),
                                      Text(' add photo'),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      );
                    },
                    child: Card(
                      color: Colors.grey[300],
                      child: Container(
                        padding: EdgeInsets.all(10),
                        width: double.infinity,
                        child: Row(
                          children: [
                            CircleAvatar(
                              backgroundImage: NetworkImage(
                                '${cubit.theUserModel.image}',
                              ),
                            ),
                            Text(' What\'s on your mind?')
                          ],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                  ListView.separated(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemBuilder: (context, index) {
                      return buildPostItem(AppCubit.get(context).posts[index],
                          AppCubit.get(context).theUserModel, context, index);
                    },
                    separatorBuilder: (context, index) => SizedBox(height: 15),
                    itemCount: AppCubit.get(context).posts.length,
                  ),
                  SizedBox(height: 10),
                ],
              ),
            );
          },
          fallback: (context) => Center(child: CircularProgressIndicator()),
        );
      },
    );
  }

  Widget buildPostItem(PostModel postModel, UserModel model, context, index) => Card(
        clipBehavior: Clip.antiAliasWithSaveLayer,
        elevation: 5,
        margin: EdgeInsets.symmetric(horizontal: 8),
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  InkWell(
                    onTap: (){
                      AppCubit.get(context).getUserPost(postModel.uId).then((value) {
                        navigateTo(context, UserProfileScreen(profileUserModel: postModel,));
                      });

                    },
                    child: CircleAvatar(
                      backgroundImage: NetworkImage(
                        '${postModel.image}',
                      ),
                      radius: 25,
                    ),
                  ),
                  SizedBox(width: 10),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      InkWell(
                        onTap: (){
                          navigateTo(context, UserProfileScreen(profileUserModel: postModel,));
                        },
                        child: Text(
                          '${postModel.name}',
                          style: TextStyle(height: 1),
                        ),
                      ),
                      Text(
                        '${postModel.dateTime}',
                        style: Theme.of(context)
                            .textTheme
                            .caption
                            .copyWith(height: 1.3),
                      ),
                    ],
                  ),
                  Spacer(),
                  InkWell(
                    onTap: () {},
                    child: Icon(
                      Icons.more_horiz,
                      size: 25,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 15),
                child: Container(
                  height: 1,
                  width: double.infinity,
                  color: Colors.grey[300],
                ),
              ),
              Text(
                '${postModel.text}',
                style: TextStyle(height: 1.3),
              ),
              SizedBox(height: 7),
              if (postModel.postImage != "")
                Container(
                  width: double.infinity,
                  height: 200,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    image: DecorationImage(
                      fit: BoxFit.cover,
                      image: NetworkImage(
                        '${postModel.postImage}',
                      ),
                    ),
                  ),
                ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: Row(
                  children: [
                    Expanded(
                      child: InkWell(
                        onTap: () {},
                        child: Row(
                          children: [
                            Icon(
                              IconBroken.Heart,
                              color: Colors.red[600],
                            ),
                            Text(
                              ' ${AppCubit.get(context).likes[index]}',
                              style: Theme.of(context).textTheme.caption,
                            ),
                          ],
                        ),
                      ),
                    ),
                    Expanded(
                      child: InkWell(
                        onTap: () {},
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Icon(
                              IconBroken.Chat,
                              color: Colors.red[600],
                            ),
                            Text(
                              ' 0 comments',
                              style: Theme.of(context).textTheme.caption,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                height: 1,
                width: double.infinity,
                color: Colors.grey[300],
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Expanded(
                      child: InkWell(
                        onTap: () {},
                        child: Row(
                          children: [
                            CircleAvatar(
                              radius: 17,
                              backgroundImage: NetworkImage(
                                '${model.image}',
                              ),
                            ),
                            Text(
                              '  Write a comment...',
                              style: Theme.of(context).textTheme.caption,
                            ),
                          ],
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        AppCubit.get(context)
                            .likePost(AppCubit.get(context).postId[index]);
                      },
                      child: Row(
                        children: [
                          Icon(
                            IconBroken.Heart,
                            color: Colors.red,
                          ),
                          Text(
                            ' Like',
                            style: Theme.of(context).textTheme.caption,
                          ),
                        ],
                      ),
                    ),
                    SizedBox(width: 15),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
}
