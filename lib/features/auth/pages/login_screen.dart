import 'package:farm_app/features/auth/pages/signup_screen.dart';
import 'package:farm_app/features/task/pages/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/common/widgets/reusable_button_widget.dart';
import '../../../core/common/widgets/reusable_textformfield_widget.dart';
import '../../../core/common/widgets/reusable_title_widget.dart';
import '../../../core/helpers/authentication_helper.dart';
import '../../../core/utils/theme.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  static final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();

  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
          child: Form(
            key: LoginScreen._formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // SizedBox(height: 24.h),
                const ReusableTitle(title: 'Login\nWelCome back!'),
                const Spacer(),
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
                Align(
                  alignment: Alignment.centerRight,
                  child: Text(
                    'Forgot Password?',
                    style: AppTheme.linkText(
                      color: AppTheme.buttonColor,
                    ),
                  ),
                ),
                SizedBox(height: 24.h),
                SizedBox(
                  width: double.infinity,
                  child: ReusableButton(
                    label: 'Login',
                    color: AppTheme.buttonColor,
                    onPressed: () {
                      if (LoginScreen._formKey.currentState!.validate()) {
                        AuthenticationHelper()
                            .signIn(
                          context,
                          email: _emailController.text,
                          password: _passwordController.text,
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
                SizedBox(
                  width: double.infinity,
                  child: ReusableButton(
                    label: 'Login as Guest',
                    color: Colors.lightBlueAccent,
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const HomeScreen()),
                      );
                    },
                  ),
                ),
                // SocialLoginButton(
                //   textColor: AppTheme.black,
                //   text: 'Login with Google',
                //   onPressed: () {
                //     Navigator.push(
                //       context,
                //       MaterialPageRoute(builder: (context) => HomeScreen()),
                //     );
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
