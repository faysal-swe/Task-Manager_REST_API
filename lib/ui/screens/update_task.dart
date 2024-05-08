import 'package:flutter/material.dart';
import '../../data/models/list_task_model.dart';
import '../../data/models/network_response.dart';
import '../../data/services/network_calling.dart';
import '../../data/utils/urls.dart';

class UpdateTaskStatus extends StatefulWidget {
  final ListData task;
  const UpdateTaskStatus({Key? key, required this.task}) : super(key: key);
  @override
  State<UpdateTaskStatus> createState() => _UpdateTaskStatusState();
}

class _UpdateTaskStatusState extends State<UpdateTaskStatus> {
  final List<String> _taskStatus = ['New', 'Cancelled', 'Complete', 'Progress'];
  late String selectedTask;
  
  Future<void>updateTaskStatus(String id, String taskStatus) async{
    NetworkResponse response = await NetworkCalling().getRequest(Urls.updateTaskStatus(id,taskStatus));
    if(response.statusCode == 200){
      if(mounted){
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content:Text('Status update successfully!')));
      }
    }else{
      if(mounted){
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content:Text('Status update failed!')));
      }
    }
  }
  
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    selectedTask = widget.task.status!.toUpperCase();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
      const Text('Update Task-Status',
          style: TextStyle(
            fontSize: 20,
          )),
      const SizedBox(height: 20),
      Expanded(
        child: ListView.builder(
            itemCount: _taskStatus.length,
            itemBuilder: (context, index) {
              return ListTile(
                  onTap: () {
                    selectedTask = _taskStatus[index].toUpperCase();
                    if (mounted) {
                      setState(() {});
                    }
                  },
                  title: Text(_taskStatus[index].toUpperCase()),
                  trailing: selectedTask == _taskStatus[index].toUpperCase()
                      ? const Icon(Icons.check, color: Colors.green)
                      : null);
            }),
      ),
      ElevatedButton(
        onPressed: () {
          updateTaskStatus(widget.task.sId!, selectedTask);
          Navigator.pop(context);
        },
        child: const Text('Update', style: TextStyle(color: Colors.white)),
      )
    ]);
  }
}
