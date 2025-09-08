import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:yapilacaklar_listesi/data/local_storage.dart';
import 'package:yapilacaklar_listesi/main.dart';
import 'package:yapilacaklar_listesi/models/task.dart';

class taskList extends StatefulWidget {
  final task tasks;
  taskList({super.key, required this.tasks});

  @override
  State<taskList> createState() => _taskListState();
}

class _taskListState extends State<taskList> {
  late TextEditingController _taskname;
  late localStorage _localstorage;

  @override
  void initState() {
    super.initState();
    _localstorage = locator<localStorage>();
    _taskname = TextEditingController(text: widget.tasks.name);
  }

  @override
  void dispose() {
    _taskname.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(.1),
              blurRadius: 10,
            ),
          ]),
      child: ListTile(
        leading: GestureDetector(
          onTap: () {
            if (_taskname.text.trim().isNotEmpty &&
                _taskname.text.trim() != widget.tasks.name) {
              widget.tasks.name = _taskname.text.trim();
              _localstorage.updateTask(task: widget.tasks);
            }
            widget.tasks.isCompleted = !widget.tasks.isCompleted;
            _localstorage.updateTask(task: widget.tasks);
            setState(() {});
          },
          child: Container(
            child: Icon(
              Icons.check,
              color: Colors.white,
            ),
            decoration: BoxDecoration(
                color: widget.tasks.isCompleted ? Colors.green : Colors.white,
                border: Border.all(color: Colors.grey, width: 0.8),
                shape: BoxShape.circle),
          ),
        ),
        title: widget.tasks.isCompleted
            ? Text(
                widget.tasks.name,
                style: const TextStyle(
                    decoration: TextDecoration.lineThrough, color: Colors.grey),
              )
            : TextField(
                controller: _taskname,
                minLines: 1,
                maxLines: null,
                textInputAction: TextInputAction.done,
                decoration: const InputDecoration(
                  border: InputBorder.none,
                ),
                onSubmitted: (value) {
                  if (value.trim().length > 3) {
                    widget.tasks.name = value.trim();
                    _localstorage.updateTask(task: widget.tasks);
                    setState(() {});
                  }
                },
              ),
        trailing: Text(
          DateFormat('hh:mm a').format(widget.tasks.created),
          style: const TextStyle(color: Colors.grey, fontSize: 14),
        ),
      ),
    );
  }
}
