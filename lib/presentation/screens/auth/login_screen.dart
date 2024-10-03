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
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              backgroundColor: AppColors.readyColor,
              content: Center(
                child: Text(state.message),
              ),
            ),
          );
        }
      },
      child: Scaffold(
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Form(
              key: formkey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    "Tizimga kirish",
                    style: TextStyle(
                      color: AppColors.customBlack,
                      fontSize: 24.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const Gap(60),
                  CustomTextfield(
                    labeltext: "Username",
                    controller: _usernameController,
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return "Username kiriting";
                      }
                      return null;
                    },
                  ),
                  const Gap(24),
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
                    labeltext: "Parol",
                    controller: _passwordController,
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return "Parol kiriting";
                      }

                      return null;
                    },
                  ),
                  const Gap(40),
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
                    child: const Text(
                      "Kirish",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
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
