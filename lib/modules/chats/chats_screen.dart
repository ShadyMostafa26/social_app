import 'package:conditional_builder/conditional_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app/models/user_model.dart';
import 'package:social_app/modules/chats/chat_details_screen.dart';
import 'package:social_app/shared/components/components.dart';
import 'package:social_app/shared/cubit/cubit.dart';
import 'package:social_app/shared/cubit/states.dart';

class ChatScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit,AppStates>(
      listener: (context, state) {},
      builder: (context, state) {
        return  ConditionalBuilder(
          condition: AppCubit.get(context).users.length > 0,
          builder: (context) => ListView.separated(
            physics: BouncingScrollPhysics(),
            itemBuilder: (context, index) => buildChatItem(AppCubit.get(context).users[index],context),
            separatorBuilder: (context, index) => SizedBox(height: 5,),
            itemCount: AppCubit.get(context).users.length,
          ),
          fallback: (context) => Center(child: CircularProgressIndicator()),
        );
      },
    );
  }


  Widget buildChatItem(UserModel model,context) =>  InkWell(
    onTap: () {
      navigateTo(context, ChatDetailsScreen(userModel: model,));
    },
    child: Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          Row(
            children: [
              CircleAvatar(
                backgroundImage: NetworkImage(
                  '${model.image}',
                ),
                radius: 25,
              ),
              SizedBox(width: 10),
              Text(
                '${model.name}',
                style: TextStyle(height: 1),
              ),
              Spacer(),
             // Text('${DateTime.now().hour} : ${DateTime.now().minute} ')
            ],
          ),
        ],
      ),
    ),
  );
}
