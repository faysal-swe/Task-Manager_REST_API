import 'package:flutter/material.dart';
import '../../data/models/list_task_model.dart';

class TaskListTile extends StatelessWidget {
  final Widget child;
  final ListData data;
  final VoidCallback onDeleteTap, onEditTap;
  const TaskListTile(
      {super.key,
      required this.child,
      required this.data,
      required this.onDeleteTap,
      required this.onEditTap});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: const EdgeInsets.all(6),
      title: Text(data.title ?? 'Unknown',
          style: const TextStyle(fontWeight: FontWeight.bold)),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(data.description ?? " "),
          Text(data.createdDate ?? " ",
              style: const TextStyle(fontWeight: FontWeight.w500)),
          Row(
            children: [
              child,
              const Spacer(),
              IconButton(
                  onPressed: onDeleteTap,
                  icon: const Icon(Icons.delete_forever_outlined,
                      color: Colors.red)),
              IconButton(
                  onPressed: onEditTap,
                  icon: const Icon(Icons.edit, color: Colors.green)),
            ],
          )
        ],
      ),
    );
  }
}
