import 'package:farm_app/features/auth/pages/signup_screen.dart';
import 'package:farm_app/features/task/pages/home_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../common/utils/theme.dart';
import '../../../common/widgets/reusable _social_icon_widget.dart';
import '../../../common/widgets/reusable_button_widget.dart';
import '../../../common/widgets/reusable_textformfield_widget.dart';
import '../../../common/widgets/reusable_title_widget.dart';

class LoginScreen extends StatelessWidget {
  LoginScreen({super.key});

  final TextEditingController _userNameOrEmailController =
      TextEditingController();
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
              const ReusableTitle(title: 'Login\nWelCome back!'),
              SizedBox(height: 24.h),
              ReusableTextFormField(
                labelText: 'Enter Your Username / Email',
                controller: _userNameOrEmailController,
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
              SizedBox(height: 18.h),
              Text(
                'Forgot Password?',
                style: AppTheme.linkText(
                  color: AppTheme.buttonColor,
                ),
              ),
              SizedBox(height: 24.h),
              SizedBox(
                width: double.infinity,
                child: ReusableButton(
                  label: 'Login',
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
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => SignUpScreen()),
                  );
                },
                child: RichText(
                  text: TextSpan(
                    text: 'Don\’t have an account? ',
                    style: AppTheme.linkText(),
                    children: [
                      TextSpan(
                        text: 'Signup',
                        style: AppTheme.linkText(
                          color: AppTheme.buttonColor,
                        ),
                      ),
                    ],
                  ),
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
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => HomeScreen()),
                  );

                },
                iconPath: 'assets/images/facebook.png',
              ),
              SizedBox(height: 18.h),
              SocialLoginButton(
                textColor: AppTheme.black,
                text: 'Login with Google',
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => HomeScreen()),
                  );
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
