import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:task_manager/ui/screens/add_new_task.dart';
import 'package:task_manager/ui/widgets/task_list_tile.dart';
import '../../data/models/network_response.dart';
import '../../data/services/network_calling.dart';
import '../../data/utils/urls.dart';
import '../state_controller/summarycount_controller.dart';
import '../state_controller/taskList_controller.dart';
import '../widgets/summary_card.dart';
import 'update_task.dart';

class NewTaskScreen extends StatefulWidget {
  const NewTaskScreen({Key? key}) : super(key: key);

  @override
  State<NewTaskScreen> createState() => _NewTaskScreenState();
}

class _NewTaskScreenState extends State<NewTaskScreen> {

  final SummeryCountController _summeryCountController = Get.find();
  final TaskListController _taskListController = Get.find();

  Future<void> deleteTask(String taskId) async {
    NetworkResponse response =
        await NetworkCalling().getRequest(Urls.deleteTask(taskId));
    if (response.isSuccess) {
      _taskListController.listTaskModel.data!.removeWhere((element) => element.sId == taskId);
      _summeryCountController.getSummaryCount();
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text('Deleting failed!')));
      }
    }
  }

  void pageBuilder(){
    _summeryCountController.getSummaryCount();
    _taskListController.getTaskList('New').then((value){
      if(!value){
        Get.snackbar('Failed','Task List failed!');
      }
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_){
      pageBuilder();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          children: [
            GetBuilder<SummeryCountController>(
              builder: (summeryCountController) {
                return Visibility(
                  visible:!summeryCountController.summeryCardInProgress,
                  replacement: const Center(child:LinearProgressIndicator()),
                  child: SummaryCard(
                      data: summeryCountController.summaryCountModel ?? [],
                      ),
                );
              }
            ),
            const SizedBox(height:10),
            Expanded(
              child: RefreshIndicator(
                onRefresh: () async {
                  pageBuilder();
                },
                child: GetBuilder<TaskListController>(
                  builder: (taskListController) {
                    return Visibility(
                      visible: !taskListController.taskListInProgress,
                      replacement: const Center(child: CircularProgressIndicator()),
                      child: ListView.separated(
                        itemCount: _taskListController.listTaskModel.data?.length ?? 0,
                        itemBuilder: (context, index) {
                          return TaskListTile(
                              data: _taskListController.listTaskModel.data![index],
                              onDeleteTap: () {
                                deleteTask(_taskListController.listTaskModel.data![index].sId!);
                              },
                              onEditTap: () {
                                showModalBottomSheet(
                                    context: context,
                                    builder: (context) {
                                      return Center(
                                        child: Padding(
                                          padding: const EdgeInsets.all(10.0),
                                          child: UpdateTaskStatus(task:_taskListController.listTaskModel.data![index]),
                                        ),
                                      );
                                    });
                              },
                              child: Container(
                                  alignment: Alignment.center,
                                  width: 100,
                                  height: 30,
                                  decoration: BoxDecoration(
                                      color: Colors.blue,
                                      borderRadius: BorderRadius.circular(15)),
                                  child: const Text('New',
                                      style: TextStyle(color: Colors.white))));
                        },
                        separatorBuilder: (BuildContext context, int index) {
                          return const Divider(
                            height: 4,
                          );
                        },
                      ),
                    );
                  }
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const AddNewTaskScreen()));
          },
          backgroundColor: Colors.green,
          child: const Icon(Icons.add, color: Colors.white)),
    );
  }
}
