import 'package:flutter/material.dart';
import 'package:task_manager/data/models/network_response.dart';
import '../../data/services/network_calling.dart';
import '../../data/utils/urls.dart';
import '../widgets/screen_background.dart';

class AddNewTaskScreen extends StatefulWidget {
  const AddNewTaskScreen({Key? key}) : super(key: key);

  @override
  State<AddNewTaskScreen> createState() => _AddNewTaskScreenState();
}

class _AddNewTaskScreenState extends State<AddNewTaskScreen> {

  final TextEditingController subjectTextEditingController =
      TextEditingController();
  final TextEditingController descriptionTextEditingController =
      TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _isNewTaskCreate = false;

  Future<void> addNewTask() async {
    _isNewTaskCreate = true;
    if (mounted) {
      setState(() {});
    }
    NetworkResponse response =
        await NetworkCalling().postRequest(Urls.createTask, <String, dynamic>{
      "title": subjectTextEditingController.text.trim(),
      "description": descriptionTextEditingController.text.trim(),
      "status": "New"
    });
    _isNewTaskCreate = false;
    if (mounted) {
      setState(() {});
    }

    if (response.isSuccess) {
      if (mounted) {
        subjectTextEditingController.clear();
        descriptionTextEditingController.clear();
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Task added Successfully!')));
      }
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text("Task add failed")));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.sizeOf(context);
    return Scaffold(
        appBar: AppBar(
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
                      SizedBox(height: size.height * 0.05),
                      Text(
                        'Add New Task',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      const SizedBox(height: 20),
                      TextFormField(
                          controller: subjectTextEditingController,
                          keyboardType: TextInputType.text,
                          decoration: const InputDecoration(
                            hintText: "Subject",
                          ),
                          validator: (String? value) {
                            if (value?.trim().isEmpty ?? true) {
                              return 'Enter a title';
                            }
                            return null;
                          }),
                      const SizedBox(height: 20),
                      TextFormField(
                          controller: descriptionTextEditingController,
                          keyboardType: TextInputType.text,
                          maxLines: 5,
                          decoration: const InputDecoration(
                            hintText: "Description",
                          ),
                          validator: (String? value) {
                            if (value?.trim().isEmpty ?? true) {
                              return 'Enter Description';
                            }
                            return null;
                          }),
                      const SizedBox(height: 20),
                      SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: Visibility(
                          visible:!_isNewTaskCreate,
                          replacement:const Center(child:CircularProgressIndicator()),
                          child: ElevatedButton(
                            onPressed: () {
                              if (!_formKey.currentState!.validate()) {
                                return;
                              }
                             addNewTask();
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
