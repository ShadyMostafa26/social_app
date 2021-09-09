import 'package:conditional_builder/conditional_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app/layout/home_layout.dart';
import 'package:social_app/shared/components/components.dart';
import 'package:social_app/shared/components/constatnts.dart';
import 'package:social_app/shared/cubit/cubit.dart';
import 'package:social_app/shared/cubit/states.dart';
import 'package:social_app/shared/network/local/cache_helper.dart';

class RegisterScreen extends StatelessWidget {
  final emailController = TextEditingController();
  final nameController = TextEditingController();
  final phoneController = TextEditingController();
  final passwordController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, AppStates>(
      listener: (context, state) {
        if (state is AppCreateUserSuccessState) {
          CacheHelper.saveData(
            key: 'uId',
            value: state.userModel.uId,
          ).then((value) {
            uId = state.userModel.uId;
            navigateAndFinish(context, HomeLayout());
          });
        }
      },
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(),
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
                        'REGISTER',
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
                        controller: nameController,
                        keyboardType: TextInputType.text,
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'please enter your name';
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            hintText: 'Name',
                            prefixIcon: Icon(Icons.person)),
                      ),
                      SizedBox(height: 10),
                      TextFormField(
                        controller: phoneController,
                        keyboardType: TextInputType.phone,
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'please enter your phone';
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            hintText: 'Phone',
                            prefixIcon: Icon(Icons.phone)),
                      ),
                      SizedBox(height: 10),
                      TextFormField(
                        controller: passwordController,
                        keyboardType: TextInputType.visiblePassword,
                        obscureText: AppCubit.get(context).isHidden,
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
                              AppCubit.get(context).icon,
                            ),
                            onPressed: () {
                              AppCubit.get(context)
                                  .changeIconPasswordVisibility();
                            },
                          ),
                        ),
                      ),
                      SizedBox(height: 7),
                      Container(
                        width: double.infinity,
                        child: ConditionalBuilder(
                          condition: state is! AppRegisterLoadingState,
                          builder: (context) => ElevatedButton(
                            onPressed: () {
                              if (formKey.currentState.validate()) {
                                AppCubit.get(context).register(
                                  email: emailController.text,
                                  name: nameController.text,
                                  phone: phoneController.text,
                                  password: passwordController.text,
                                );
                              }
                            },
                            child: Text('REGISTER'),
                          ),
                          fallback: (context) =>
                              Center(child: CircularProgressIndicator()),
                        ),
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
