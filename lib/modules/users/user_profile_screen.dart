import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app/models/post_model.dart';
import 'package:social_app/models/user_model.dart';
import 'package:social_app/shared/cubit/cubit.dart';
import 'package:social_app/shared/cubit/states.dart';
import 'package:social_app/shared/styles/icon_broken.dart';

class UserProfileScreen extends StatefulWidget {
  final PostModel profileUserModel;

  UserProfileScreen({this.profileUserModel});

  @override
  _UserProfileScreenState createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen> {
  @override


  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, AppStates>(
      listener: (context, state) {},
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            title: Text('${widget.profileUserModel.name}'),
          ),
          body: SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  height: 185,
                  child: Stack(
                    children: [
                      Container(
                        height: 150,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          image: DecorationImage(
                            image: NetworkImage(
                              '',
                            ),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      Align(
                        alignment: AlignmentDirectional.bottomCenter,
                        child: CircleAvatar(
                          radius: 55,
                          backgroundColor: Colors.red,
                          child: CircleAvatar(
                            radius: 54,
                            backgroundImage:
                                NetworkImage('${widget.profileUserModel.image}'),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 10),
                Text('${widget.profileUserModel.name}',style: TextStyle(fontSize: 20),),

                SizedBox(height: 10),
                ListView.separated(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemBuilder: (context, index) => buildPostItem(AppCubit.get(context).userPosts[index],context),
                  separatorBuilder: (context, index) => SizedBox(height: 15),
                  itemCount: AppCubit.get(context).userPosts.length,
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget buildPostItem(PostModel postModel,context) =>
      Card(
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
                  CircleAvatar(
                    backgroundImage: NetworkImage(
                      '${postModel.image}',
                    ),
                    radius: 25,
                  ),
                  SizedBox(width: 10),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${postModel.name}',
                        style: TextStyle(height: 1),
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
                              '10',
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
                                '${postModel.image}',
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
                        // AppCubit.get(context).likePost(AppCubit.get(context).postId[index]);
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
