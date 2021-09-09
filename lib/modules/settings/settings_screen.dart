import 'package:conditional_builder/conditional_builder.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app/modules/settings/edit_profile_screen.dart';
import 'package:social_app/shared/components/components.dart';
import 'package:social_app/shared/cubit/cubit.dart';
import 'package:social_app/shared/cubit/states.dart';

class SettingScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit,AppStates>(
      listener: (context, state) {},
      builder: (context, state) {
        var cubit = AppCubit.get(context);
              return ConditionalBuilder(
                condition: AppCubit.get(context).theUserModel != null,
                builder: (context) => Padding(
                  padding: const EdgeInsets.all(8.0),
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
                                    '${cubit.theUserModel.cover}',
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
                                  backgroundImage: NetworkImage(
                                      '${cubit.theUserModel.image}'),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Text(
                        '${cubit.theUserModel.name}',
                        style: Theme.of(context).textTheme.bodyText1,
                      ),
                      Text(
                        '${cubit.theUserModel.bio}',
                        style: Theme.of(context).textTheme.caption,
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: InkWell(
                              onTap: () {},
                              child: Column(
                                children: [
                                  Text('100'),
                                  Text('posts',style: Theme.of(context).textTheme.caption,),
                                ],
                              ),
                            ),
                          ),
                          Expanded(
                            child: InkWell(
                              onTap: () {},
                              child: Column(
                                children: [
                                  Text('100'),
                                  Text('Followers',style: Theme.of(context).textTheme.caption,),
                                ],
                              ),
                            ),
                          ),
                          Expanded(
                            child: InkWell(
                              onTap: () {},
                              child: Column(
                                children: [
                                  Text('100'),
                                  Text('Following',style: Theme.of(context).textTheme.caption,),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 10,),
                      Container(
                        width: double.infinity,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              padding: EdgeInsets.all(10)
                          ),
                          onPressed: () {
                            navigateTo(context, EditProfileScreen());
                          },
                          child: Text('EDIT PROFILE'),
                        ),
                      ),
                    ],
                  ),
                ),
                fallback: (context) => Center(child: CircularProgressIndicator()),
              );

      },
    );
  }
}


