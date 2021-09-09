import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app/layout/home_layout.dart';
import 'package:social_app/modules/login/login_screen.dart';
import 'package:social_app/shared/components/components.dart';
import 'package:social_app/shared/components/constatnts.dart';
import 'package:social_app/shared/cubit/cubit.dart';
import 'package:social_app/shared/cubit/states.dart';
import 'package:social_app/shared/network/local/cache_helper.dart';

Future<void> firebaseMessagingBackground(RemoteMessage message) async {
  print('on background message');
  print(message.data.toString());
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp();

  var token = await FirebaseMessaging.instance.getToken();
  print(token);

///////////////////////////////////////////////

  FirebaseMessaging.onMessage.listen((event) {
    print(event.data.toString());
    showToast(back: Colors.red, msg: "onMessage");
  });

//////////////////////////////////////////////

  FirebaseMessaging.onMessageOpenedApp.listen((event) {
    print(event.data.toString());
    showToast(back: Colors.red, msg: "onMessageOpened");
  });

//////////////////////////////////////////////////////

  FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackground);

  await CacheHelper.init();
  Bloc.observer = MyBlocObserver();

  uId = CacheHelper.getData(key: 'uId');
  print(uId);

  Widget widget;
  if (uId != null) {
    widget = HomeLayout();
  } else {
    widget = LoginScreen();
  }

  runApp(MyApp(
    startScreen: widget,
  ));
}

class MyApp extends StatelessWidget {
  final startScreen;

  const MyApp({this.startScreen});
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AppCubit()
        ..getUserData()
        ..getPost()
        ..getUsers(),
      child: BlocConsumer<AppCubit, AppStates>(
        listener: (context, state) {},
        builder: (context, state) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Social',
            theme: lightTheme(),
            home: startScreen,
          );
        },
      ),
    );
  }
}
