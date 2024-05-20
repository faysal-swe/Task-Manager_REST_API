import 'package:get/get.dart';
import '../../data/models/list_task_model.dart';
import '../../data/models/network_response.dart';
import '../../data/services/network_calling.dart';
import '../../data/utils/urls.dart';

class TaskListController extends GetxController{
  bool _taskListInProgress = false;
  ListTaskModel listTaskModel = ListTaskModel();
  bool get taskListInProgress => _taskListInProgress;
  // ListTaskModel get getListTaskModel=>_listTaskModel;

  Future<bool> getTaskList(String status) async {
    _taskListInProgress = true;
    update();
    NetworkResponse response =
    await NetworkCalling().getRequest(Urls.listTaskByStatus(status));
    _taskListInProgress = false;
    update();
    if (response.statusCode == 200) {
      listTaskModel = ListTaskModel.fromJson(response.body!);
    update();
      return true;
    } else {
       return false;
      }
    }
  }
