import 'package:carpet_delivery/bloc/user_profile/user_bloc.dart';
import 'package:carpet_delivery/data/models/user/user.dart';
import 'package:carpet_delivery/presentation/widgets/custom_textfield.dart';
import 'package:carpet_delivery/utils/app_constants/app_colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _fullname = TextEditingController();
  final _id = TextEditingController();
  final _phoneNumber = TextEditingController();
  final _role = TextEditingController();
  final _username = TextEditingController();

  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    print("Salom ");
    return Scaffold(
      appBar: AppBar(
        title: const Text("Profil"),
        actions: [
          PopupMenuButton<String>(
            onSelected: (String value) {
              if (value == 'logout') {
<<<<<<< HEAD
                _showLogoutDialog(context);
              } else if (value == 'edit_profile') {
                _showEditProfileDialog(context);
=======
                showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      title: Text(
                        "Profildan chiqmoqchimisiz?",
                        style: TextStyle(fontSize: 16.sp),
                      ),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: const Text(
                            "Bekor qilish",
                            style: TextStyle(
                              color: AppColors.customBlack,
                            ),
                          ),
                        ),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.customBlack,
                          ),
                          onPressed: () {
                            context.read<AuthBloc>().add(LogoutAuthEvent());
                            Navigator.of(context).pop();
                          },
                          child: const Text(
                            "Ha",
                            style: TextStyle(color: AppColors.white),
                          ),
                        )
                      ],
                    );
                  },
                );
              } else if (value == 'edit') {
                showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      title: Form(
                        key: formkey,
                        child: Column(
                          children: [
                            CustomTextfield(
                              controller: _usernameController,
                              hintText: "Foydalanuvchi ismi kiritilsin",
                              validator: (value) {
                                if (value == null || value.trim().isEmpty) {
                                  return "Foydalanuvchi  ismi bo'sh bo'lmasligi kerak!";
                                }
                                return null;
                              },
                            ),
                            const Gap(10),
                            CustomTextfield(
                              controller: _phoneController,
                              maxlength: 9,
                              textInputType: TextInputType.phone,
                              labeltext: "Telefon raqam kiriting",
                              hintText: "(90) 123 45 67",
                              validator: (value) {
                                if (value == null || value.trim().isEmpty) {
                                  return "Telefon raqam bo'sh bo'lmasligi kerak!";
                                } else if (value.length != 9) {
                                  return "Parol 9 ta raqamdan kam bo'lmasligi kerak!";
                                }

                                return null;
                              },
                            ),
                          ],
                        ),
                      ),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: const Text(
                            "Bekor qilish",
                            style: TextStyle(
                              color: AppColors.customBlack,
                            ),
                          ),
                        ),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.customBlack,
                          ),
                          onPressed: () {
                            if (formkey.currentState!.validate()) {
                              final request = LoginRequest(
                                password: _phoneController.text,
                                username: _usernameController.text,
                              );
                              context
                                  .read<AuthBloc>()
                                  .add(LoginAuthEvent(request: request));
                            }
                          },
                          child: const Text(
                            "Ha",
                            style: TextStyle(color: AppColors.white),
                          ),
                        )
                      ],
                    );
                  },
                );
>>>>>>> 92d1a00ff8c0e866dee1adf2ef75032663bf5dd3
              }
            },
            itemBuilder: (BuildContext context) {
              return [
                const PopupMenuItem<String>(
                  value: 'edit',
                  child: ListTile(
                    leading: Icon(Icons.edit),
                    title: Text("Profilni tahrirlash"),
                  ),
                ),
                const PopupMenuItem<String>(
                  value: 'logout',
                  child: ListTile(
                    leading: Icon(Icons.logout),
                    title: Text("Chiqish"),
                  ),
                ),
              ];
            },
          ),
        ],
      ),
      body: BlocBuilder<UserBloc, UserState>(
        bloc: context.read<UserBloc>()..add(FetchUserProfileEvent()),
        builder: (context, state) {
          print("============================");
          print(state);
          print("============================");

          if (state is LoadingState) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state is LoadedState) {
            print("User profile");
            final user = state.user;
            _fullname.text = user.username;
            _id.text = user.phoneNumber;
            _phoneNumber.text = user.phoneNumber;
            _role.text = user.phoneNumber;
            _username.text = user.phoneNumber;

            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircleAvatar(
                    radius: 50.r,
                    child: Icon(
                      CupertinoIcons.person_alt,
                      size: 70.r,
                    ),
                  ),
                  const Gap(20),
                  Text(
                    'Fullname: ${user.fullname}',
                    style: TextStyle(fontSize: 18.sp),
                  ),
                  Text(
                    'ID: ${user.id}',
                    style: TextStyle(fontSize: 18.sp),
                  ),
                  Text(
                    'Phone Number: ${user.phoneNumber}',
                    style: TextStyle(fontSize: 18.sp),
                  ),
                  Text(
                    'Role: ${user.role}',
                    style: TextStyle(fontSize: 18.sp),
                  ),
                  Text(
                    'Username: ${user.username}',
                    style: TextStyle(fontSize: 18.sp),
                  ),
                ],
              ),
            );
          }
          return const Center(child: Text('User not found.'));
        },
      ),
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(
            "Profildan chiqmoqchimisiz?",
            style: TextStyle(fontSize: 14.sp),
            textAlign: TextAlign.center,
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text("Yopish"),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.customBlack),
              onPressed: () {},
              child: const Text(
                "Ha",
                style: TextStyle(color: AppColors.white),
              ),
            ),
          ],
        );
      },
    );
  }

  void _showEditProfileDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Form(
            key: formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CustomTextfield(
                  controller: _username,
                  hintText: "Foydalanuvchi ismi kiritilsin",
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return "Foydalanuvchi ismi bo'sh bo'lmasligi kerak!";
                    }
                    return null;
                  },
                ),
                const Gap(10),
                CustomTextfield(
                  controller: _phoneNumber,
                  maxlength: 9,
                  textInputType: TextInputType.phone,
                  labeltext: "Telefon raqam kiriting",
                  hintText: "(90) 123 45 67",
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return "Telefon raqam bo'sh bo'lmasligi kerak!";
                    } else if (value.length != 9) {
                      return "Telefon raqam 9 ta raqamdan kam bo'lmasligi kerak!";
                    }
                    return null;
                  },
                ),
              ],
            ),
          ),
<<<<<<< HEAD
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text("Yopish"),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.customBlack),
              onPressed: () {
                if (formKey.currentState!.validate()) {
                  formKey.currentState!.save();
                  final request = User(
                      id: _id.text,
                      fullname: _fullname.text,
                      username: _username.text,
                      phoneNumber: _phoneNumber.text,
                      role: _role.text);
                  context.read<UserBloc>().add(FetchUserProfileEvent());
                }
              },
              child: const Text(
                "Ha",
                style: TextStyle(color: AppColors.white),
              ),
            ),
          ],
        );
      },
=======
        ],
      )),
>>>>>>> 92d1a00ff8c0e866dee1adf2ef75032663bf5dd3
    );
  }
}
