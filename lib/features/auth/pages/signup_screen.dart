import 'package:farm_app/features/task/pages/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../common/utils/theme.dart';
import '../../../common/widgets/reusable _social_icon_widget.dart';
import '../../../common/widgets/reusable_button_widget.dart';
import '../../../common/widgets/reusable_textformfield_widget.dart';
import '../../../common/widgets/reusable_title_widget.dart';

class SignUpScreen extends StatelessWidget {
  SignUpScreen({super.key});

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
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: 24.h),
              const ReusableTitle(title: 'Signup'),
              SizedBox(height: 24.h),
              ReusableTextFormField(
                labelText: 'Enter Your Username',
                controller: _userNameController,
              ),
              SizedBox(height: 24.h),
              ReusableTextFormField(
                labelText: 'Enter Your Email',
                controller: _emailController,
              ),
              SizedBox(height: 24.h),
              ReusableTextFormField(
                labelText: 'Enter Your Phone Number',
                controller: _phoneNumberController,
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
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => HomeScreen()),
                    );

                  },
                ),
              ),
              SizedBox(height: 18.h),
              RichText(
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
              SizedBox(height: 18.h),
              Row(
                children: [
                  const Expanded(
                    child: Divider(
                      thickness: 1.0,
                      color: Colors.grey,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Text(
                      'Or',
                      style: AppTheme.linkText(),
                    ),
                  ),
                  const Expanded(
                    child: Divider(
                      thickness: 1.0,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 18.h),
              SocialLoginButton(
                text: 'Login with Facebook',
                textColor: AppTheme.white,
                backgroundColor: AppTheme.socialButtonColor,
                onPressed: () {
                  // Handle Facebook login action
                },
                iconPath: 'assets/images/facebook.png',
              ),
              SizedBox(height: 18.h),
              SocialLoginButton(
                textColor: AppTheme.black,
                text: 'Login with Google',
                onPressed: () {
                  // Handle Google login action
                },
                iconPath: 'assets/images/google.png',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
