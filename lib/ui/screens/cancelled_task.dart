import 'package:flutter/material.dart';
import 'package:task_manager/ui/screens/update_task.dart';
import '../../data/models/list_task_model.dart';
import '../../data/models/network_response.dart';
import '../../data/services/network_calling.dart';
import '../../data/utils/urls.dart';
import '../widgets/task_list_tile.dart';

class CancelledTaskScreen extends StatefulWidget {
  const CancelledTaskScreen({Key? key}) : super(key: key);

  @override
  State<CancelledTaskScreen> createState() => _CancelledTaskScreenState();
}

class _CancelledTaskScreenState extends State<CancelledTaskScreen> {
  bool taskListInProgress = false;
  ListTaskModel _listTaskModel = ListTaskModel();

  Future<void> getTaskList() async {
    taskListInProgress = true;
    if (mounted) {
      setState(() {});
    }
    NetworkResponse response =
        await NetworkCalling().getRequest(Urls.listTaskByStatus('CANCELLED'));
    if (response.statusCode == 200) {
      _listTaskModel = ListTaskModel.fromJson(response.body!);
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text('Task List failed!')));
      }
    }
    taskListInProgress = false;
    if (mounted) {
      setState(() {});
    }
  }

  Future<void> deleteTask(String taskId) async {
    NetworkResponse response =
        await NetworkCalling().getRequest(Urls.deleteTask(taskId));
    if (response.isSuccess) {
      _listTaskModel.data!.removeWhere((element) => element.sId == taskId);
      if(mounted){
        setState(() {});
      }
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text('Deleting failed!')));
      }
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_){
      getTaskList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          children: [
            const SizedBox(height: 10),
            Expanded(
              child: RefreshIndicator(
                onRefresh: () async {
                  getTaskList();
                },
                child: Visibility(
                  visible: !taskListInProgress,
                  replacement: const Center(child: CircularProgressIndicator()),
                  child: ListView.separated(
                    itemCount: _listTaskModel.data?.length ?? 0,
                    itemBuilder: (context, index) {
                      return TaskListTile(
                          data: _listTaskModel.data![index],
                          onDeleteTap: () {
                            deleteTask(_listTaskModel.data![index].sId!);
                          },
                          onEditTap: () {
                            showModalBottomSheet(
                                context: context,
                                builder: (context) {
                                  return Center(
                                    child: Padding(
                                      padding: const EdgeInsets.all(10.0),
                                      child: UpdateTaskStatus(
                                          task: _listTaskModel.data![index]),
                                    ),
                                  );
                                });
                          },
                          child: Container(
                              alignment: Alignment.center,
                              width: 100,
                              height: 30,
                              decoration: BoxDecoration(
                                  color: Colors.red,
                                  borderRadius: BorderRadius.circular(15)),
                              child: const Text('Cancelled',
                                  style: TextStyle(color: Colors.white))));
                    },
                    separatorBuilder: (BuildContext context, int index) {
                      return const Divider(
                        height: 4,
                      );
                    },
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
