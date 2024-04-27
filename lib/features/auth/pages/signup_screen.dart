import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/common/widgets/reusable_button_widget.dart';
import '../../../core/common/widgets/reusable_textformfield_widget.dart';
import '../../../core/common/widgets/reusable_title_widget.dart';
import '../../../core/helpers/authentication_helper.dart';
import '../../../core/utils/theme.dart';
import '../../task/pages/home_screen.dart';
import '../pages/login_screen.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  static final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final TextEditingController _userNameController = TextEditingController();

  final TextEditingController _emailController = TextEditingController();

  final TextEditingController _phoneNumberController = TextEditingController();

  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
            child: Form(
              key: SignUpScreen._formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const ReusableTitle(title: 'Signup'),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.1),
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
                        if (SignUpScreen._formKey.currentState!.validate()) {
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
                              // Show popup window about the app
                              showDialog(
                                barrierDismissible: false,
                                context: context,
                                builder: (context) => AlertDialog(
                                  title: Text('About PoultryPal',
                                      style: AppTheme.title()),
                                  content: Text(
                                    'Elevate your broiler farming with our specialized Poultry Management System designed for farmers using the "All-In-All-Out" method. \n\nSeamlessly stay on top of your farms operations, receive timely alerts for all your tasks daily, monitor health, track performance, and optimize resources for better results. \n\nExperience streamlined operations and enhanced productivity.',
                                    style: AppTheme.bodyText2(),
                                  ),
                                  actions: <Widget>[
                                    TextButton(
                                      onPressed: () {
                                        Navigator.pop(context);
                                        Navigator.pushReplacement(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                const HomeScreen(),
                                          ),
                                        );
                                      },
                                      child: Text('Continue'),
                                    ),
                                  ],
                                ),
                              );
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
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
