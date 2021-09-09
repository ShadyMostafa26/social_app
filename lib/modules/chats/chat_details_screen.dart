import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app/models/message_model.dart';
import 'package:social_app/models/user_model.dart';
import 'package:social_app/shared/cubit/cubit.dart';
import 'package:social_app/shared/cubit/states.dart';
import 'package:social_app/shared/styles/icon_broken.dart';

class ChatDetailsScreen extends StatelessWidget {
  final UserModel userModel;
   ChatDetailsScreen({ this.userModel});

   final messageController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (context) {
         AppCubit.get(context).getMessages(receiverId: userModel.uId);
        return BlocConsumer<AppCubit,AppStates>(
          listener: (context, state) {},
          builder: (context, state) {
            return Scaffold(
              appBar: AppBar(
                titleSpacing: 0,
                title: Row(
                  children: [
                    CircleAvatar(
                      radius: 20,
                      backgroundImage: NetworkImage('${userModel.image}'),
                    ),
                    SizedBox(width: 5,),
                    Text('${userModel.name}'),
                  ],
                ),
              ),
              body: Padding(
                padding: const EdgeInsets.all(15.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                  Expanded(
                    child: ListView.separated(
                      physics: BouncingScrollPhysics(),
                      itemBuilder: (context, index) {
                        var message = AppCubit.get(context).messages[index];
                         if(AppCubit.get(context).theUserModel.uId == message.senderId )
                           return buildMyMessage(AppCubit.get(context).messages[index]);

                         return buildMessage(AppCubit.get(context).messages[index]);
                      },
                      separatorBuilder: (context, index) => SizedBox(height: 10,),
                      itemCount: AppCubit.get(context).messages.length,
                    ),
                  ),
                    SizedBox(height: 5,),
                    Container(
                      height: 50,
                      clipBehavior: Clip.antiAliasWithSaveLayer,
                      decoration: BoxDecoration(
                          border: Border.all(
                              color: Colors.grey[300],
                              width: 1
                          ),
                          borderRadius: BorderRadius.circular(15)
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              controller: messageController,
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                hintText: ' Aa',

                              ),
                            ),
                          ),
                          Container(
                            height: 50,
                            color: Colors.blue,
                            child: MaterialButton(
                              minWidth: 1,
                              onPressed: () {
                                AppCubit.get(context).sendMessage(receiverId: userModel.uId, dateTime: DateTime.now().toString(), text: messageController.text);
                                messageController.clear();
                              },
                              child: Icon(
                                IconBroken.Send,
                                size: 16,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget buildMessage(MessageModel model) => Align(
    alignment: AlignmentDirectional.centerStart,
    child: Container(
      decoration: BoxDecoration(
        color: Colors.grey[300],
        borderRadius: BorderRadiusDirectional.only(
          topStart: Radius.circular(10),
          topEnd: Radius.circular(10),
          bottomEnd: Radius.circular(10),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text('${model.text}'),
      ),
    ),
  );

  Widget buildMyMessage(MessageModel model)=> Align(
    alignment: AlignmentDirectional.centerEnd,
    child: Container(
      decoration: BoxDecoration(
        color: Colors.pink[500].withOpacity(0.6),
        borderRadius: BorderRadiusDirectional.only(
          topStart: Radius.circular(10),
          topEnd: Radius.circular(10),
          bottomStart: Radius.circular(10),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text('${model.text}'),
      ),
    ),
  );
}
