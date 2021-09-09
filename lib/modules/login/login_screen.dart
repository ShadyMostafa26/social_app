import 'package:conditional_builder/conditional_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app/layout/home_layout.dart';
import 'package:social_app/modules/register/register_screen.dart';
import 'package:social_app/shared/components/components.dart';
import 'package:social_app/shared/components/constatnts.dart';
import 'package:social_app/shared/cubit/cubit.dart';
import 'package:social_app/shared/cubit/states.dart';
import 'package:social_app/shared/network/local/cache_helper.dart';

class LoginScreen extends StatelessWidget {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, AppStates>(
      listener: (context, state) {
        if (state is AppLoginSuccessState) {
          CacheHelper.saveData(
            key: 'uId',
            value: state.uId,
          ).then((value) {
            uId = state.uId;
            AppCubit.get(context).getPost();
            navigateAndFinish(context, HomeLayout());
          });
        }
        if (state is AppLoginErrorState) {
          showToast(
            msg: state.error,
            back: Colors.red[800],
          );
        }

      },
      builder: (context, state) {
        return Scaffold(
          body: Center(
            child: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.all(20),
                child: Form(
                  key: formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'LOGIN',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 30,
                        ),
                      ),
                      SizedBox(height: 20),
                      TextFormField(
                        controller: emailController,
                        keyboardType: TextInputType.emailAddress,
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'please enter your email';
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            hintText: 'Email',
                            prefixIcon: Icon(Icons.email)),
                      ),
                      SizedBox(height: 10),
                      TextFormField(
                        controller: passwordController,
                        keyboardType: TextInputType.visiblePassword,
                        obscureText: AppCubit.get(context).isHiddenLogin,
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'please enter your password';
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          hintText: 'Password',
                          prefixIcon: Icon(Icons.lock),
                          suffixIcon: IconButton(
                            icon: Icon(
                              AppCubit.get(context).iconLogin,
                            ),
                            onPressed: AppCubit.get(context)
                                .changeIconPasswordLoginVisibility,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 7,
                      ),
                      ConditionalBuilder(
                        condition: state is! AppLoginLoadingState,
                        builder: (context) => Container(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () {
                              if (formKey.currentState.validate()) {
                                AppCubit.get(context).login(
                                  email: emailController.text,
                                  password: passwordController.text,
                                );
                              }
                            },
                            child: Text('LOGIN'),
                          ),
                        ),
                        fallback: (context) =>
                            Center(child: CircularProgressIndicator()),
                      ),
                      SizedBox(
                        height: 7,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('Dont have an account? '),
                          TextButton(
                            onPressed: () {
                              navigateTo(context, RegisterScreen());
                            },
                            child: Text('Register'),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
