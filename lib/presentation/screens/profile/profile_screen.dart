import 'package:carpet_delivery/bloc/auth/auth_bloc.dart';
import 'package:carpet_delivery/data/models/auth/login_request.dart';
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
  final _usernameController = TextEditingController();
  final _phoneController = TextEditingController();
  final formkey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Profil"),
        actions: [
          PopupMenuButton<String>(
            onSelected: (String value) {
              if (value == 'logout') {
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
                            child: const Text("Yopish")),
                        ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.customBlack),
                            onPressed: () {},
                            child: const Text(
                              "Ha",
                              style: TextStyle(color: AppColors.white),
                            ))
                      ],
                    );
                  },
                );
              } else if (value == 'edit_profile') {
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
                            child: const Text("Yopish")),
                        ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.customBlack),
                            onPressed: () {
                              if (formkey.currentState!.validate()) {
                                final request = LoginRequest(
                                    password: _phoneController.text,
                                    username: _usernameController.text);
                                context
                                    .read<AuthBloc>()
                                    .add(LoginAuthEvent(request: request));
                              }
                            },
                            child: const Text(
                              "Ha",
                              style: TextStyle(color: AppColors.white),
                            ))
                      ],
                    );
                  },
                );
              }
            },
            itemBuilder: (BuildContext context) {
              return [
                const PopupMenuItem<String>(
                  value: 'edit_profile',
                  child: Row(
                    children: [
                      Icon(Icons.edit),
                      SizedBox(width: 8),
                      Text('Profili tahrirlash'),
                    ],
                  ),
                ),
                const PopupMenuItem<String>(
                  value: 'logout',
                  child: Row(
                    children: [
                      Icon(Icons.logout),
                      SizedBox(width: 8),
                      Text('Profildan chiqish'),
                    ],
                  ),
                ),
              ];
            },
          ),
        ],
      ),
      body: Center(
          child: Column(
        children: [
          CircleAvatar(
            radius: 50.r,
            child: Icon(
              CupertinoIcons.person_alt,
              size: 70.r,
            ),
          ),
          
        ],
      )),
    );
  }
}
