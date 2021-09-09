import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app/shared/cubit/cubit.dart';
import 'package:social_app/shared/cubit/states.dart';
import 'package:social_app/shared/styles/icon_broken.dart';

class HomeLayout extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, AppStates>(
      listener: (context, state) {},
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            title: Text(
                '${AppCubit.get(context).titles[AppCubit.get(context).currentIndex]}'),
          ),
          bottomNavigationBar: BottomNavigationBar(
            currentIndex: AppCubit.get(context).currentIndex,
            onTap: (index) => AppCubit.get(context).changeBottomNav(index),
            items: [
              BottomNavigationBarItem(
                  icon: Icon(IconBroken.Home), label: 'Home'),
              BottomNavigationBarItem(
                  icon: Icon(IconBroken.Chat), label: 'Chats'),
              /*BottomNavigationBarItem(
                  icon: Icon(IconBroken.User), label: 'Users'),*/
              BottomNavigationBarItem(
                  icon: Icon(IconBroken.Setting), label: 'Setting')
            ],
          ),
          body: AppCubit.get(context).screens[AppCubit.get(context).currentIndex],

          floatingActionButton: (AppCubit.get(context).currentIndex == 2)?FloatingActionButton(
            onPressed: (){
              AppCubit.get(context).signOut(context);
            },
            child: Icon(IconBroken.Logout),
          ): null,
        );
      },
    );
  }
}
