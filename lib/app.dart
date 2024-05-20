import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:task_manager/ui/screens/splash_screen.dart';
import 'ui/state_controller/email_controller.dart';
import 'ui/state_controller/login_controller.dart';
import 'ui/state_controller/signup_controller.dart';
import 'ui/state_controller/summarycount_controller.dart';
import 'ui/state_controller/taskList_controller.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

class TaskManagerApp extends StatefulWidget {
  const TaskManagerApp({Key? key}) : super(key: key);
  @override
  State<TaskManagerApp> createState() => _TaskManagerAppState();
}

class _TaskManagerAppState extends State<TaskManagerApp> {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
        navigatorKey:navigatorKey,
        title: 'Task Manager',
        initialBinding: ControllerBinding(),
        theme: ThemeData(
            brightness: Brightness.light,
            colorSchemeSeed: Colors.green,
            inputDecorationTheme: const InputDecorationTheme(
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(borderSide: BorderSide.none),
            ),
            textTheme: const TextTheme(
              titleLarge: TextStyle(fontSize:30, fontWeight: FontWeight.w700),
            ),
            elevatedButtonTheme: ElevatedButtonThemeData(
              style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10))),
            ),
        ),
        darkTheme: ThemeData(brightness: Brightness.dark),
        themeMode: ThemeMode.light,
        debugShowCheckedModeBanner: false,
        home: const SplashScreen());
  }
}
class ControllerBinding extends Bindings{
  @override
  void dependencies() {
    // TODO: implement dependencies
    Get.put(LoginController());
    Get.put(EmailController());
    Get.put(SignupController());
    Get.put(SummeryCountController());
    Get.put(TaskListController());
  }

}
