import 'package:flutter/material.dart';
import 'package:task_manager/ui/screens/cancelled_task.dart';
import 'package:task_manager/ui/screens/completed_task.dart';
import 'package:task_manager/ui/screens/new_task.dart';
import 'package:task_manager/ui/screens/progress_task.dart';
import 'package:task_manager/ui/screens/update_profile.dart';
import '../widgets/user_profile_banner.dart';

class BottomNavigationBarScreen extends StatefulWidget {
  const BottomNavigationBarScreen({Key? key}) : super(key: key);

  @override
  State<BottomNavigationBarScreen> createState() =>
      _BottomNavigationBarScreenState();
}

class _BottomNavigationBarScreenState extends State<BottomNavigationBarScreen> {
  int _setIndex = 0;
  final List<Widget> navScreens = [
    const NewTaskScreen(),
    const CompletedTaskScreen(),
    const CancelledTaskScreen(),
    const ProgressTaskScreen()
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 70,
        title: InkWell(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const UpdateProfile()));
            },
            child: const UserProfileBanner()),
        backgroundColor: Colors.green,
      ),
      body: navScreens[_setIndex],
      bottomNavigationBar: BottomNavigationBar(
          onTap: (value) {
            setState(() {
              _setIndex = value;
            });
          },
          currentIndex: _setIndex,
          selectedItemColor: Colors.green,
          unselectedItemColor: Colors.grey,
          showUnselectedLabels: true,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.note_alt_outlined),
              label: 'New Task',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.done_all),
              label: 'Completed',
            ),
            BottomNavigationBarItem(
                icon: Icon(Icons.free_cancellation), label: 'Cancelled'),
            BottomNavigationBarItem(
                icon: Icon(Icons.incomplete_circle), label: 'Progress'),
          ]),
    );
  }
}
