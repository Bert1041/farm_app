import 'package:farm_app/features/auth/pages/login_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/common/widgets/reusable _social_icon_widget.dart';
import '../../../core/common/widgets/reusable_button_widget.dart';
import '../../../core/common/widgets/reusable_textformfield_widget.dart';
import '../../../core/common/widgets/reusable_title_widget.dart';
import '../../../core/helpers/authentication_helper.dart';
import '../../../core/utils/theme.dart';
import '../../task/pages/home_screen.dart';

class SignUpScreen extends StatelessWidget {
  SignUpScreen({super.key});

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _userNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: 24.h),
                const ReusableTitle(title: 'Signup'),
                const Spacer(),
                ReusableTextFormField(
                  labelText: 'Enter Your Username',
                  controller: _userNameController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a username';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 24.h),
                ReusableTextFormField(
                  labelText: 'Enter Your Email',
                  controller: _emailController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your email';
                    }
                    // Regular expression for email validation
                    final emailRegex =
                        RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
                    if (!emailRegex.hasMatch(value)) {
                      return 'Please enter a valid email';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 24.h),
                ReusableTextFormField(
                  labelText: 'Enter Your Phone Number',
                  controller: _phoneNumberController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your phone number';
                    }
                    // Check if phone number contains only digits and its length is between 7 and 15 characters
                    final phoneRegex = RegExp(r'^[0-9]{10,11}$');
                    if (!phoneRegex.hasMatch(value)) {
                      return 'Please enter a valid phone number';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 24.h),
                ReusableTextFormField(
                  labelText: 'Enter Your Password',
                  controller: _passwordController,
                  obscureText: true,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a password';
                    } else if (value.length < 6) {
                      return 'Password must be at least 6 characters';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 24.h),
                SizedBox(
                  width: double.infinity,
                  child: ReusableButton(
                    label: 'Signup',
                    color: AppTheme.buttonColor,
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        AuthenticationHelper()
                            .signUpWithEmailAndPassword(
                          context,
                          email: _emailController.text,
                          password: _passwordController.text,
                          phoneNumber: _phoneNumberController.text,
                          userName: _userNameController.text,
                        )
                            .then((success) {
                          if (success) {
                            Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const HomeScreen()));
                          }
                        });
                      }
                    },
                  ),
                ),
                SizedBox(height: 18.h),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => LoginScreen()),
                    );
                  },
                  child: RichText(
                    text: TextSpan(
                      text: 'Already have an account? ',
                      style: AppTheme.linkText(),
                      children: [
                        TextSpan(
                          text: 'Login',
                          style: AppTheme.linkText(
                            color: AppTheme.buttonColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 18.h),
                // SocialLoginButton(
                //   textColor: AppTheme.black,
                //   text: 'Login with Google',
                //   onPressed: () {
                //     // Handle Google login action
                //   },
                //   iconPath: 'assets/images/google.png',
                // ),
                const Spacer(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
