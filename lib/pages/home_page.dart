import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker_plus/flutter_datetime_picker_plus.dart';
import 'package:yapilacaklar_listesi/data/local_storage.dart';
import 'package:yapilacaklar_listesi/main.dart';
import 'package:yapilacaklar_listesi/models/task.dart';
import 'package:yapilacaklar_listesi/widgets/search_delegate.dart';
import 'package:yapilacaklar_listesi/widgets/task_list.dart';

class homePage extends StatefulWidget {
  const homePage({super.key});

  @override
  State<homePage> createState() => _homePageState();
}

class _homePageState extends State<homePage> {
  late List<task> _alltask;
  late localStorage _localstorage;

  @override
  void initState() {
    super.initState();
    _localstorage = locator<localStorage>();
    _alltask = <task>[];
    _getAllTask();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: GestureDetector(
            onTap: () {
              _addTask();
            },
            child: const Text(
              'Bugün ne yapacaksın?',
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 25,
                  fontWeight: FontWeight.bold),
            ),
          ),
          centerTitle: false,
          actions: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: CircleAvatar(
                backgroundColor: Colors.grey.shade400,
                child: IconButton(
                    onPressed: () {
                      _searchPage();
                    },
                    icon: const Icon(
                      Icons.search,
                      color: Colors.white,
                    )),
              ),
            ),
            SizedBox(
              width: 5,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: CircleAvatar(
                backgroundColor: Colors.grey.shade400,
                child: IconButton(
                  onPressed: () {
                    _addTask();
                  },
                  icon: const Icon(
                    Icons.add,
                    color: Colors.white,
                  ),
                ),
              ),
            )
          ],
        ),
        body: _alltask.isNotEmpty
            ? ListView.builder(
                itemBuilder: (context, index) {
                  var oankieleman = _alltask[index];
                  return Padding(
                    padding: const EdgeInsets.only(top: 15),
                    child: Dismissible(
                      background: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.delete, color: Colors.grey),
                          Text(
                            'Bu görev silindi',
                            style: TextStyle(fontSize: 15,fontWeight:FontWeight.bold),
                          )
                        ],
                      ),
                      key: Key(oankieleman.id),
                      onDismissed: (direction) {
                        _alltask.removeAt(index);
                        _localstorage.deleteTask(task: oankieleman);
                        setState(() {});
                      },
                      child: taskList(tasks: oankieleman),
                    ),
                  );
                },
                itemCount: _alltask.length)
            : const Center(
                child: Text(
                  'Hadi Görev Ekle',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ),);
        }

  void _addTask() {
    showModalBottomSheet(
        context: context,
        builder: (context) {
          return Container(
            padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom),
            width: MediaQuery.of(context).size.width,
            child: ListTile(
              title: TextField(
                autofocus: true,
                decoration: const InputDecoration(
                    hintText: 'Görev nedir ?', border: InputBorder.none),
                onSubmitted: (value) {
                  Navigator.of(context).pop();
                  if (value.length > 3) {
                    DatePicker.showTimePicker(
                      context,
                      showSecondsColumn: false,
                      onConfirm: (time) async {
                        var yenieklenengorev =
                            task.create(name: value, created: time);
                        _alltask.insert(0, yenieklenengorev);
                        await _localstorage.addTask(task: yenieklenengorev);
                        setState(() {});
                      },
                    );
                  }
                },
              ),
            ),
          );
        });
  }

  void _getAllTask() async {
    _alltask = await _localstorage.getAllTask();
    setState(() {});
  }

  void _searchPage() async {
    await showSearch(
        context: context, delegate: searchDelegate(alltask: _alltask));
    _getAllTask();
  }
}
