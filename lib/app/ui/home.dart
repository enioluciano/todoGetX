import 'package:apptodo/app/controller/home_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Home extends StatelessWidget {
  final HomeController controller = Get.put(HomeController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Adicionar Tarefas"),
        centerTitle: true,
        actions: [
          IconButton(
              icon: Icon(Icons.nightlight_round),
              onPressed: () {
                Get.changeTheme(
                    Get.isDarkMode ? ThemeData.light() : ThemeData.dark());
              })
        ],
      ),
      body: Column(
        children: <Widget>[
          Container(
            padding: EdgeInsets.fromLTRB(17.0, 1.0, 7.0, 1.0),
            child: Row(
              children: <Widget>[
                Expanded(
                    child: TextField(
                  textInputAction: TextInputAction.done,
                  onSubmitted: (_) => FocusScope.of(context).unfocus(),
                  controller: controller.controllerTask,
                  decoration: InputDecoration(
                      labelText: "Nova Tarefa",
                      labelStyle: Get.isDarkMode
                          ? TextStyle(color: Colors.white)
                          : TextStyle(color: Colors.blueAccent)),
                )),
                SizedBox(
                  width: 5,
                ),
                ElevatedButton(
                  child: Text("ADD"),
                  onPressed: () {
                    FocusScope.of(context).unfocus();
                    if (controller.controllerTask.text != "") {
                      controller.addTodo2();
                    }
                  },
                )
              ],
            ),
          ),
          Expanded(
              child: Obx(
            () => ListView.builder(
                padding: EdgeInsets.only(top: 10.0),
                itemCount: controller.listToDo2.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: EdgeInsets.only(top: 8),
                    child: Card(
                      elevation: 3,
                      shadowColor: Colors.blue,
                      child: Dismissible(
                        secondaryBackground: backgroundWidgetRemoved(),
                        background: backgroundWidgetEdit(),
                        key: Key(
                            DateTime.now().millisecondsSinceEpoch.toString()),
                        child: CheckboxListTile(
                          activeColor:
                              Get.isDarkMode ? Colors.white : Colors.blue,
                          checkColor:
                              Get.isDarkMode ? Colors.red : Colors.white,
                          title: Text(controller.listToDo2[index].value.name),
                          secondary: controller.listToDo2[index].value.ok
                              ? CircleAvatar(
                                  radius: 15,
                                  child: Icon(
                                    Icons.check_circle,
                                    color: Colors.white,
                                  ),
                                  backgroundColor: Colors.green,
                                )
                              : CircleAvatar(
                                  radius: 15,
                                  child: Icon(
                                    Icons.warning_rounded,
                                    color: Colors.white,
                                    size: 25,
                                  ),
                                  backgroundColor: Colors.yellow[800],
                                ),
                          value: controller.listToDo2[index].value.ok,
                          onChanged: (bool value) {
                            controller.updateCheckBox2(index, value);
                          },
                        ),
                        onDismissed: (direction) async {
                          if (direction == DismissDirection.endToStart) {
                            controller.removedTodo(index);

                            Get.rawSnackbar(
                                backgroundColor: Colors.red,
                                message: "Tarefa removida!",
                                mainButton: GestureDetector(
                                  child: Text(
                                    "Desfazer",
                                    style: TextStyle(color: Colors.white),
                                  ),
                                  onTap: () {
                                    controller.undoAction(index);
                                    if (Get.isSnackbarOpen) {
                                      Get.back();
                                    }
                                  },
                                ),
                                icon: Icon(
                                  Icons.check_circle,
                                  color: Colors.white,
                                ));
                          } else {
                            controller.editTaskDialog(index);
                          }
                        },
                      ),
                    ),
                  );
                }),
          ))
        ],
      ),
    );
  }
}

Widget backgroundWidgetRemoved() {
  return Container(
    color: Colors.red,
    child: Align(
      alignment: Alignment(0.9, 0.0),
      child: Icon(
        Icons.delete,
        color: Colors.white,
      ),
    ),
  );
}

Widget backgroundWidgetEdit() {
  return Container(
    color: Colors.yellow[800],
    child: Align(
      alignment: Alignment(-0.9, 0.0),
      child: Icon(
        Icons.edit,
        color: Colors.white,
      ),
    ),
  );
}
