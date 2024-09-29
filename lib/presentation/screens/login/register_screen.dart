import 'package:carpet_delivery/presentation/widgets/custom_textfield.dart';
import 'package:carpet_delivery/presentation/widgets/universal_button_widget.dart';
import 'package:carpet_delivery/utils/app_constants/app_colors.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _userNameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _phoneController = TextEditingController();
  final _nickNameController = TextEditingController();
  bool _isObscured = true;

  final formkey = GlobalKey<FormState>();

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
                    "Ro'yxatdan o'tish",
                    style: TextStyle(
                        color: AppColors.customBlack,
                        fontSize: 24,
                        fontWeight: FontWeight.bold),
                  ),
                  const Gap(80),
                  CustomTextfield(
                    labeltext: "F.I.O ni kiriting",
                    controller: _userNameController,
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
                        return "Foydalanuvchi nomi bo'sh bo'lmasligi kerak!";
                      } else if (value.length < 6) {
                        return "Parol 6 ta belgidan kam bo'lmasligi kerak!";
                      }

                      return null;
                    },
                  ),
                  Gap(24.h),
                  CustomTextfield(
                    maxlength: 9,
                    textInputType: TextInputType.phone,
                    labeltext: "Telefon raqam kiriting",
                    hintText: "(90) 123 45 67",
                    controller: _phoneController,
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return "Telefon raqam bo'sh bo'lmasligi kerak!";
                      } else if (value.length != 9) {
                        return "Parol 9 ta raqamdan kam bo'lmasligi kerak!";
                      }

                      return null;
                    },
                  ),
                  Gap(24.h),
                  CustomTextfield(
                    labeltext: "Ismingizni   kiriting",
                    controller: _nickNameController,
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return "Foydalanuvchi nomi bo'sh bo'lmasligi kerak!";
                      }
                      return null;
                    },
                  ),
                  Gap(24.h),
                  UniversalButtonWidget(
                    function: () {},
                    child: Text("Ro'yxatdan o'tish"),
                  ),
                  Gap(24.h),
                  RichText(
                    text: TextSpan(
                      style: TextStyle(
                        color: AppColors.locationColor,
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w500,
                      ),
                      children: <TextSpan>[
                        const TextSpan(text: "Ro'yxatdan o'tganmisiz? "),
                        TextSpan(
                          text: "Tizimga kirish",
                          style: const TextStyle(
                            decoration: TextDecoration.underline,
                            decorationStyle: TextDecorationStyle.solid,
                            color: AppColors.customBlack,
                            fontWeight: FontWeight.bold,
                          ),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              Navigator.pop(context);
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