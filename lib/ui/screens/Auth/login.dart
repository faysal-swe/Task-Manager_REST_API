import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:task_manager/ui/screens/Auth/email_verification.dart';
import 'package:task_manager/ui/screens/Auth/signup.dart';
import 'package:task_manager/ui/widgets/screen_background.dart';
import '../../state_controller/login_controller.dart';
import '../bottom_nav_bar.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailTextEditingController =
      TextEditingController();
  final TextEditingController _passwordTextEditingController =
      TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.sizeOf(context);
    return Scaffold(
        body: ScreenBackground(
      child: Padding(
        padding: const EdgeInsets.all(26),
        child: SingleChildScrollView(
          child: SafeArea(
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(height: size.height * 0.2),
                  Text(
                    'Get Started With',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    controller: _emailTextEditingController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: const InputDecoration(
                      hintText: "Email",
                    ),
                    validator: (String? value) {
                      if (value!.trim().isEmpty ?? true) {
                        return 'please enter email address';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                      controller: _passwordTextEditingController,
                      obscureText: true,
                      decoration: const InputDecoration(
                        hintText: "Password",
                      ),
                      validator: (String? value) {
                        if (value!.isEmpty ?? true) {
                          return 'please enter password';
                        }
                        return null;
                      }),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child:
                        GetBuilder<LoginController>(builder: (loginController) {
                        return Visibility(
                        visible: !loginController.loginInProgress,
                        replacement:
                            const Center(child: CircularProgressIndicator()),
                        child: ElevatedButton(
                          onPressed: () {
                            if (!_formKey.currentState!.validate()) {
                              return;
                            }
                            loginController.userLogIn(
                                _emailTextEditingController.text,
                                _passwordTextEditingController.text).then((value){
                                  if(value){
                                    Get.off(const BottomNavigationBarScreen());
                                  }else{
                                    Get.snackbar('Failed','Login failed try again!');
                                  }
                            });
                            _emailTextEditingController.clear();
                            _passwordTextEditingController.clear();
                          },
                          child: const Icon(
                            Icons.arrow_forward_ios_outlined,
                            color: Colors.white,
                          ),
                        ),
                      );
                    }),
                  ),
                  const SizedBox(height: 40),
                  Center(
                    child: TextButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      const EmailVerificationScreen()));
                        },
                        child: const Text('Forget Password?',
                            style: TextStyle(
                                color: Colors.grey,
                                fontWeight: FontWeight.w700))),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        "Don't have account?",
                        style: TextStyle(fontWeight: FontWeight.w500),
                      ),
                      const SizedBox(width: 2),
                      TextButton(
                          onPressed: () {
                            Navigator.pushAndRemoveUntil(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const SignUpScreen()),
                                (route) => false);
                          },
                          style: TextButton.styleFrom(
                            padding: EdgeInsets.zero,
                            minimumSize: Size.zero,
                            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          ),
                          child: const Text('Sign up',
                              style: TextStyle(color: Colors.green)))
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    ));
  }
}
