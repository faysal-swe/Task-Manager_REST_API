import 'package:flutter/material.dart';
import '../../data/models/auth_utils.dart';
import '../screens/Auth/login.dart';

class UserProfileBanner extends StatefulWidget {
  const UserProfileBanner({
    super.key,
  });

  @override
  State<UserProfileBanner> createState() => _UserProfileBannerState();
}

class _UserProfileBannerState extends State<UserProfileBanner> {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        CircleAvatar(
          radius: 25,
          child: ClipOval(
            child: Image.network(
              'https://i.pinimg.com/originals/8b/16/7a/8b167af653c2399dd93b952a48740620.jpg',
              height: 100,
              width: 100,
              fit: BoxFit.cover,
            ),
          ),
        ),
        const SizedBox(width: 12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
                "${AuthUtils.userInfo.data?.firstName ?? 'Undefined'} ${AuthUtils.userInfo.data?.lastName ?? ''}",
                style: const TextStyle(fontSize: 20, color: Colors.white)),
            Text(AuthUtils.userInfo.data?.email ?? 'Undefined',
                style: const TextStyle(fontSize: 15, color: Colors.white)),
          ],
        ),
        const Spacer(),
        IconButton(
            onPressed: () async {
              await AuthUtils.clearUserInfo();
              if (mounted) {
                Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const LoginScreen()),
                    (route) => false);
              }
            },
            icon: const Icon(Icons.logout))
      ],
    );
  }
}
