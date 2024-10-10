import 'package:carpet_delivery/bloc/auth/auth_bloc.dart';
import 'package:carpet_delivery/data/models/auth/login_request.dart';
import 'package:carpet_delivery/presentation/widgets/custom_textfield.dart';
import 'package:carpet_delivery/presentation/widgets/universal_button_widget.dart';
import 'package:carpet_delivery/utils/app_constants/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final formkey = GlobalKey<FormState>();
  bool _isObscured = true;

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is ErrorAuthState) {
          showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: Text(
                  "Login qilishda xatolik bor!\nIltimos tekshirib qaytadan urinib ko'ring",
                  style: TextStyle(fontSize: 14.sp),
                  textAlign: TextAlign.center,
                ),
                actions: [
                  UniversalButtonWidget(
                      function: () {
                        Navigator.pop(context);
                      },
                      child: const Text("Qayta kirish"))
                ],
              );
            },
          );
        }
      },
      child: Scaffold(
        body: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.r),
            child: Form(
              key: formkey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Gap(94.h),
                  Text(
                    "Tizimga kirish",
                    style: TextStyle(
                        color: AppColors.customBlack,
                        fontSize: 24.sp,
                        fontWeight: FontWeight.bold),
                  ),
                  Gap(80.h),
                  CustomTextfield(
                    labeltext: "Foydalanuvchi nomini kiriting",
                    controller: _usernameController,
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return "Foydalanuvchi nomi bo'sh bo'lmasligi kerak!";
                      }
                      return null;
                    },
                  ),
                  Gap(24.h),
                  CustomTextfield(
                    suffixIcon: IconButton(
                      onPressed: () {
                        _isObscured = !_isObscured;
                        setState(() {});
                      },
                      icon: Icon(
                        _isObscured ? Icons.visibility : Icons.visibility_off,
                      ),
                    ),
                    obscureText: _isObscured,
                    labeltext: "Parolingizni  kiriting",
                    controller: _passwordController,
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return "Parol  bo'sh bo'lmasligi kerak!";
                      } else if (value.length < 6) {
                        return "Parol 6 ta belgidan kam bo'lmasligi kerak!";
                      }

                      return null;
                    },
                  ),
                  Gap(16.h),
                  Gap(24.h),
                  UniversalButtonWidget(
                    function: () {
                      if (formkey.currentState!.validate()) {
                        formkey.currentState!.save();
                        final request = LoginRequest(
                            password: _passwordController.text,
                            username: _usernameController.text);
                        context
                            .read<AuthBloc>()
                            .add(LoginAuthEvent(request: request));
                      }
                    },
                    child: const Text("Kirish"),
                  ),
                  Gap(24.h),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
