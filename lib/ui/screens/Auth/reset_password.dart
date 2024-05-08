import 'package:flutter/material.dart';
import 'package:task_manager/ui/widgets/screen_background.dart';

import '../../../data/models/network_response.dart';
import '../../../data/services/network_calling.dart';
import '../../../data/utils/urls.dart';
import 'login.dart';
import 'otp_verification.dart';

class ResetPasswordScreen extends StatefulWidget {
  final String email;
  final String otp;
  const ResetPasswordScreen({Key? key, required this.email, required this.otp}) : super(key: key);

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreen();
}

class _ResetPasswordScreen extends State<ResetPasswordScreen> {
  final TextEditingController _passwordTextEditingController = TextEditingController();
  final TextEditingController _confirmPassTextEditingController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool isInProgress = false;

  Future<void> resetPassword() async {
    isInProgress = true;
    if (mounted) {
      setState(() {});
    }
    NetworkResponse response = await NetworkCalling().postRequest(Urls.resetPassword, <String,dynamic>{
      'email':widget.email,
      "OTP":widget.otp,
      "password": _passwordTextEditingController.text
    });
    isInProgress = false;
    if (mounted) {
      setState(() {});
    }
    if (response.isSuccess) {
      if (mounted) {
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
                builder: (context) => const LoginScreen()),
                (route) => false);
      }
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Verification failed!')));
      }
    }
  }

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
              key:_formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(height: size.height * 0.2),
                  Text(
                    'Set Password',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const Text(
                    'Minimum length password 8 character with latter and number combination',
                    style: TextStyle(fontSize:15,color: Colors.grey,fontWeight:FontWeight.w700),
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    controller: _passwordTextEditingController,
                    keyboardType: TextInputType.emailAddress,
                    obscureText:true,
                    decoration: const InputDecoration(
                      hintText: "Password",
                    ),
                    validator:(String? value){
                      if (value?.isEmpty ?? true) {
                        return 'Enter password';
                      } else if (value!.length < 6) {
                        return 'Password must be at least 6 digits long';
                      }
                      return null;
                    }
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    controller: _confirmPassTextEditingController,
                    keyboardType: TextInputType.emailAddress,
                    obscureText:true,
                    decoration: const InputDecoration(
                      hintText: "Confirm Password",
                    ),
                    validator:(String? value){
                      if(value?.contains(_passwordTextEditingController.text) ?? false){
                        return null;
                      }
                      return 'incorrect confirm password';
                    }
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: Visibility(
                      visible: !isInProgress,
                      replacement: const Center(child: CircularProgressIndicator()),
                      child: ElevatedButton(
                        onPressed: () {
                          if(!_formKey.currentState!.validate()){
                            return;
                          }
                          resetPassword();
                        },
                        child: const Text(
                          'Confirm',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 40),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        "Have account?",
                        style: TextStyle(fontWeight: FontWeight.w500),
                      ),
                      const SizedBox(width: 2),
                      TextButton(
                          onPressed: () {
                            Navigator.pushAndRemoveUntil(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const LoginScreen()),
                                    (route) => false);
                          },
                          style: TextButton.styleFrom(
                            padding: EdgeInsets.zero,
                            minimumSize: Size.zero,
                            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          ),
                          child: const Text('Sign in',
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
