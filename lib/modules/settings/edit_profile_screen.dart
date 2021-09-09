import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app/shared/cubit/cubit.dart';
import 'package:social_app/shared/cubit/states.dart';
import 'package:social_app/shared/styles/icon_broken.dart';


class EditProfileScreen extends StatelessWidget {
  final nameController = TextEditingController();
  final phoneController = TextEditingController();
  final bioController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit,AppStates>(
        listener: (context, state) {},
        builder: (context, state) {
          var cubit = AppCubit.get(context);

          nameController.text = cubit.theUserModel.name;
          phoneController.text = cubit.theUserModel.phone;
          bioController.text = cubit.theUserModel.bio;
          return Scaffold(
            appBar: AppBar(
              title: Text('Edit Profile'),
              actions: [
                TextButton(
                  onPressed: (){
                    if(cubit.profileImage != null && cubit.coverImage == null)
                      cubit.uploadProfileImage(name: nameController.text, phone: phoneController.text, bio: bioController.text);
                    if(cubit.coverImage != null && cubit.profileImage == null)
                      cubit.uploadCoverImage(name: nameController.text, phone: phoneController.text, bio: bioController.text);
                    if(cubit.profileImage == null && cubit.coverImage == null )
                      cubit.updateUser(name: nameController.text, phone: phoneController.text, bio: bioController.text);
                    if(cubit.profileImage != null && cubit.coverImage != null ){
                     cubit.uploadProfileImage(name: nameController.text, phone: phoneController.text, bio: bioController.text);
                    cubit.uploadCoverImage(name: nameController.text, phone: phoneController.text, bio: bioController.text);
                    }
                  },
                  child: Text('UPDATE'),
                ),
                SizedBox(width: 3),
              ],
            ),
            body: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    Stack(
                      children: [
                        Container(
                          height: 195,
                          child: Stack(
                            children: [
                              Container(
                                height: 150,
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5),
                                  image: DecorationImage(
                                    image:(cubit.coverImage == null)? NetworkImage(
                                      '${cubit.theUserModel.cover}',
                                    ) : FileImage(cubit.coverImage),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              Align(
                                alignment: AlignmentDirectional.topCenter,
                                child: CircleAvatar(
                                  child: IconButton(
                                      icon: Icon(IconBroken.Camera),
                                      onPressed: (){
                                        cubit.pickCoverImage();
                                      },
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
                                    backgroundImage: (cubit.profileImage == null)? NetworkImage(
                                        '${cubit.theUserModel.image}',
                                    ) : FileImage(cubit.profileImage),
                                  ),
                                ),
                              ),
                              Align(
                                alignment: AlignmentDirectional.bottomCenter,
                                child: CircleAvatar(
                                  child: IconButton(
                                    icon: Icon(IconBroken.Camera),
                                    onPressed: (){
                                      cubit.pickProfileImage();
                                    },
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    if(state is UpdateUserLoadingState)
                      SizedBox(height: 15),
                      if(state is UpdateUserLoadingState)
                      LinearProgressIndicator(),
                    if(state is UpdateUserLoadingState)
                      SizedBox(height: 15,),
                    SizedBox(height: 15),
                    TextFormField(
                      controller: nameController,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: 'Name',
                        prefixIcon: Icon(IconBroken.User,)
                      ),
                    ),
                    SizedBox(height: 10),
                    TextFormField(
                      controller: phoneController,
                      keyboardType: TextInputType.phone,
                      decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          hintText: 'Phone',
                          prefixIcon: Icon(Icons.phone,)
                      ),
                    ),
                    SizedBox(height: 10),
                    TextFormField(
                      controller: bioController,
                      decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          hintText: 'Bio',
                          prefixIcon: Icon(IconBroken.Edit,)
                      ),
                    ),
                    SizedBox(height: 10),
                  ],
                ),
              ),
            ),
          );
        },
    );
  }
}
