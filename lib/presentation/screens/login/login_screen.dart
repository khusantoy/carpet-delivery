import 'package:carpet_delivery/presentation/screens/login/register_screen.dart';
import 'package:carpet_delivery/presentation/widgets/custom_textfield.dart';
import 'package:carpet_delivery/presentation/widgets/universal_button_widget.dart';
import 'package:carpet_delivery/utils/app_constants/app_colors.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
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
    return Scaffold(
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Form(
              key: formkey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Gap(94),
                  const Text(
                    "Tizimga kirish",
                    style: TextStyle(
                        color: AppColors.customBlack,
                        fontSize: 24,
                        fontWeight: FontWeight.bold),
                  ),
                  const Gap(80),
                  Gap(24.h),
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
                  Gap(24.h),
                  UniversalButtonWidget(
                    function: () {},
                    child: const Text("Kirish"),
                  ),
                  Gap(24.h),
                  RichText(
                    text: TextSpan(
                      style: TextStyle(
                        color: AppColors.locationColor,
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w500,
                      ),
                      children: <TextSpan>[
                        const TextSpan(text: "Ro'yxatdan o'tmaganmisiz? "),
                        TextSpan(
                          text: " Ro'yxatdan o'tish",
                          style: const TextStyle(
                            decoration: TextDecoration.underline,
                            decorationStyle: TextDecorationStyle.solid,
                            color: AppColors.customBlack,
                            fontWeight: FontWeight.bold,
                          ),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (ctx) => const RegisterScreen(),
                                ),
                              );
                            },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
