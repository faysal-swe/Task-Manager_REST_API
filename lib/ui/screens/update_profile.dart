import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:task_manager/ui/widgets/screen_background.dart';
import '../../data/models/auth_utils.dart';
import '../../data/models/login_model.dart';
import '../../data/models/network_response.dart';
import '../../data/services/network_calling.dart';
import '../../data/utils/urls.dart';
import '../widgets/user_profile_banner.dart';

class UpdateProfile extends StatefulWidget {
  const UpdateProfile({Key? key}) : super(key: key);

  @override
  State<UpdateProfile> createState() => _UpdateProfileState();
}

class _UpdateProfileState extends State<UpdateProfile> {
  final ImagePicker picker = ImagePicker();
  XFile? image;
  final TextEditingController _emailTextEditingController =
  TextEditingController(text: AuthUtils.userInfo.data?.email);
  final TextEditingController _firstNameTextEditingController =
  TextEditingController(text: AuthUtils.userInfo.data?.firstName);
  final TextEditingController _lastNameTextEditingController =
  TextEditingController(text: AuthUtils.userInfo.data?.lastName);
  final TextEditingController _mobileTextEditingController =
  TextEditingController(text: AuthUtils.userInfo.data?.mobile);
  final TextEditingController _passwordTextEditingController =
  TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final updateData = AuthUtils.userInfo.data;
  bool isInProgress = false;

  void uploadImage() {
    picker.pickImage(source: ImageSource.gallery).then((xFile) {
      if (xFile != null) {
        image = xFile;
        if (mounted) {
          setState(() {});
        }
      }
    });
  }

  Future<void> updateProfile() async {
    isInProgress = true;
    if (mounted) {
      setState(() {});
    }

    Map<String, dynamic> requestedBody = {
      "email": _emailTextEditingController.text.trim(),
      "firstName": _firstNameTextEditingController.text.trim(),
      "lastName": _lastNameTextEditingController.text.trim(),
      "mobile": _mobileTextEditingController.text.trim(),
      "photo": ""
    };
    log(_firstNameTextEditingController.text.trim());
    log(_emailTextEditingController.text.trim());
    log(_lastNameTextEditingController.text.trim());

    if (_passwordTextEditingController.text.isNotEmpty) {
      requestedBody["password"] = _passwordTextEditingController.text;
    }
    NetworkResponse response =
    await NetworkCalling().postRequest(Urls.profileUpdate, requestedBody);

    isInProgress = false;
    if (mounted) {
      setState(() {});
    }

    if (response.isSuccess) {
      updateData?.email = _emailTextEditingController.text.trim();
      updateData?.firstName = _firstNameTextEditingController.text.trim();
      updateData?.lastName = _lastNameTextEditingController.text.trim();
      updateData?.mobile= _mobileTextEditingController.text.trim();
      log("UpdateData first name is : ${updateData?.email}");
      await AuthUtils.updateUserInfo(updateData);
      if (mounted) {
        setState(() {
          ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Profile Update Successfully!')));
        });
      }
    } else {
      if (mounted) {
        setState(() {
          ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Profile Update failed!')));
        });
      }
    }
  }

    @override
    Widget build(BuildContext context) {
      Size size = MediaQuery.sizeOf(context);
      return Scaffold(
          appBar: AppBar(
            automaticallyImplyLeading: false,
            toolbarHeight: 70,
            title: const UserProfileBanner(),
            backgroundColor: Colors.green,
          ),
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
                        SizedBox(height: size.height * 0.02),
                        Text(
                          'Update Profile',
                          style: Theme
                              .of(context)
                              .textTheme
                              .titleLarge,
                        ),
                        const SizedBox(height: 20),
                        InkWell(
                          onTap: () {
                            uploadImage();
                          },
                          child: Container(
                              width: double.infinity,
                              color: Colors.white,
                              child: Row(
                                children: [
                                  Container(
                                      color: Colors.grey.shade700,
                                      child: const Padding(
                                        padding: EdgeInsets.all(18.0),
                                        child: Text('Photo',
                                            style:
                                            TextStyle(color: Colors.white)),
                                      )),
                                  const SizedBox(width: 10.0),
                                  Visibility(
                                      visible: image != null,
                                      child: Text(image?.name ?? ' '))
                                ],
                              )),
                        ),
                        const SizedBox(height: 10),
                        TextFormField(
                          controller: _emailTextEditingController,
                          keyboardType: TextInputType.emailAddress,
                          readOnly: true,
                          decoration: const InputDecoration(
                            hintText: "Email",
                          ),
                        ),
                        const SizedBox(height: 10),
                        TextFormField(
                          controller: _firstNameTextEditingController,
                          keyboardType: TextInputType.text,
                          decoration: const InputDecoration(
                            hintText: "First Name",
                          ),
                        ),
                        const SizedBox(height: 10),
                        TextFormField(
                          controller: _lastNameTextEditingController,
                          keyboardType: TextInputType.text,
                          decoration: const InputDecoration(
                            hintText: "Last Name",
                          ),
                        ),
                        const SizedBox(height: 10),
                        TextFormField(
                          controller: _mobileTextEditingController,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                            hintText: "Mobile",
                          ),
                        ),
                        const SizedBox(height: 10),
                        TextFormField(
                          controller: _passwordTextEditingController,
                          obscureText: true,
                          decoration: const InputDecoration(
                            hintText: "Password",
                          ),
                        ),
                        const SizedBox(height: 10),
                        SizedBox(
                          width: double.infinity,
                          height: 50,
                          child: Visibility(
                            visible:!isInProgress,
                            replacement:const Center(child:CircularProgressIndicator()),
                            child: ElevatedButton(
                              onPressed: () {
                                updateProfile();
                              },
                              child: const Icon(
                                Icons.arrow_forward_ios_outlined,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ));
    }
  }

