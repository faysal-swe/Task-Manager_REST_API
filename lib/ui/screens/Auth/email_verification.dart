import 'package:flutter/material.dart';
import 'package:task_manager/ui/widgets/screen_background.dart';
import '../../../data/models/network_response.dart';
import '../../../data/services/network_calling.dart';
import '../../../data/utils/urls.dart';
import 'login.dart';
import 'otp_verification.dart';

class EmailVerificationScreen extends StatefulWidget {
  const EmailVerificationScreen({Key? key}) : super(key: key);

  @override
  State<EmailVerificationScreen> createState() => _EmailVerificationScreen();
}

class _EmailVerificationScreen extends State<EmailVerificationScreen> {
  final TextEditingController _emailTextEditingController =
      TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool isInProgress = false;

  Future<void> emailVerification() async {
    isInProgress = true;
    if (mounted) {
      setState(() {});
    }
    NetworkResponse response = await NetworkCalling()
        .getRequest(Urls.emailVerification(_emailTextEditingController.text));
    isInProgress = false;
    if (mounted) {
      setState(() {});
    }
    if (response.isSuccess) {
      if (mounted) {
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => OtpVerificationScreen(email:_emailTextEditingController.text)));
      }
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Email Verification failed!')));
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
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(height: size.height * 0.2),
                  Text(
                    'Your Email Address',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const Text(
                    'A 6 digit verification pin will send your email address',
                    style: TextStyle(
                        fontSize: 15,
                        color: Colors.grey,
                        fontWeight: FontWeight.w700),
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                      controller: _emailTextEditingController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: const InputDecoration(
                        hintText: "Email",
                      ),
                      validator: (String? value) {
                        if (value?.trim().isEmpty ?? true) {
                          return 'enter email address';
                        }
                        return null;
                      }),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: Visibility(
                      visible: !isInProgress,
                      replacement: const Center(child:CircularProgressIndicator()),
                      child: ElevatedButton(
                        onPressed: () {
                          if (!_formKey.currentState!.validate()) {
                            return;
                          }
                          emailVerification();
                        },
                        child: const Icon(
                          Icons.arrow_forward_ios_outlined,
                          color: Colors.white,
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
