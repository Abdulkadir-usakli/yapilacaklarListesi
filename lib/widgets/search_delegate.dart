import 'package:flutter/material.dart';
import 'package:yapilacaklar_listesi/data/local_storage.dart';
import 'package:yapilacaklar_listesi/main.dart';
import 'package:yapilacaklar_listesi/models/task.dart';
import 'package:yapilacaklar_listesi/widgets/task_list.dart';

class searchDelegate extends SearchDelegate {
  final List<task> alltask;

  searchDelegate({required this.alltask});

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
          onPressed: () {
            query.isEmpty ? null : query = '';
          },
          icon: const Icon(Icons.clear))
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return GestureDetector(
      onTap: () {
        close(context, null);
      },
      child: const Icon(
        Icons.arrow_back_ios,
        color: Colors.black,
        size: 20,
      ),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    List<task> filteredList = alltask
        .where(
            (value) => value.name.toLowerCase().contains(query.toLowerCase()))
        .toList();
    return filteredList.length > 0
        ? ListView.builder(
            itemBuilder: (context, index) {
              var oankieleman = filteredList[index];
              return Dismissible(
                background: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.delete, color: Colors.grey),
                    Text('Bu görev silindi')
                  ],
                ),
                key: Key(oankieleman.id),
                onDismissed: (direction) async {
                  filteredList.removeAt(index);
                  await locator<localStorage>().deleteTask(task: oankieleman);
                },
                child: taskList(tasks: oankieleman),
              );
            },
            itemCount: filteredList.length)
        : const Center(
            child: Text('Aradığınızı Bulamadık'),
          );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    List<task> suggestedList = alltask
        .where((task) => task.name.toLowerCase().contains(query.toLowerCase()))
        .toList();
    if (suggestedList.isEmpty) {
      return const Center(
          child: Text(
        'Sonuç bulunamadı.',
        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
      ));
    }
    return ListView.builder(
      itemCount: suggestedList.length,
      itemBuilder: (context, index) {
        final currentTask = suggestedList[index];
        return ListTile(
          title: Text(currentTask.name),
          onTap: () {
            query = currentTask.name;
            showResults(context);
          },
        );
      },
    );
  }
}
