import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:task_manager/data/models/summary_count_model.dart';
import 'package:task_manager/ui/screens/add_new_task.dart';
import 'package:task_manager/ui/widgets/task_list_tile.dart';
import '../../data/models/list_task_model.dart';
import '../../data/models/network_response.dart';
import '../../data/services/network_calling.dart';
import '../../data/utils/urls.dart';
import '../widgets/summary_card.dart';
import 'update_task.dart';

class NewTaskScreen extends StatefulWidget {
  const NewTaskScreen({Key? key}) : super(key: key);

  @override
  State<NewTaskScreen> createState() => _NewTaskScreenState();
}

class _NewTaskScreenState extends State<NewTaskScreen> {
  bool taskListInProgress = false;
  bool summeryCardInProgress =false;
  ListTaskModel _listTaskModel = ListTaskModel();
  SummaryCountModel _summaryCountModel = SummaryCountModel();

  Future<void> getSummaryCount() async {
    summeryCardInProgress =true;
    if (mounted) {
      setState(() {});
    }

    NetworkResponse response =
        await NetworkCalling().getRequest(Urls.taskStatusCount);
    if (response.statusCode == 200) {
        _summaryCountModel = SummaryCountModel.fromJson(response.body!);
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Summery count failed!')));
      }
    }
    summeryCardInProgress =false;
    if (mounted) {
      setState(() {});
    }
  }

  Future<void> getTaskList() async {
    taskListInProgress = true;
    if (mounted) {
      setState(() {});
    }
    NetworkResponse response =
        await NetworkCalling().getRequest(Urls.listTaskByStatus('New'));
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
      getSummaryCount();
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
      getSummaryCount();
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
            Visibility(
              visible:!summeryCardInProgress,
              replacement: const Center(child:CircularProgressIndicator()),
              child: SummaryCard(
                  data: _summaryCountModel.data ?? [],
                  ),
            ),
            const SizedBox(height:10),
            Expanded(
              child: RefreshIndicator(
                onRefresh: () async {
                  getSummaryCount();
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
                                      child: UpdateTaskStatus(task:_listTaskModel.data![index]),
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
