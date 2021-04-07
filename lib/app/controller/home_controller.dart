import 'package:apptodo/app/models/todo.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class HomeController extends GetxController {
  final controllerTask = TextEditingController();
  final controllerEdit = TextEditingController();

  final lastRemoved = Todo().obs;
  get getListToDo => lastRemoved;
  setListToDo(newValue) => lastRemoved.value = newValue;

  RxInt lastToDoRemovedIndexPos = 0.obs;
  int get getLastTodoRemovedPos => lastToDoRemovedIndexPos.value;
  setLastTodoRemovedPos(newValue) => lastToDoRemovedIndexPos.value = newValue;

  final listToDo2 = <Rx<Todo>>[].obs;
  get getListToDo2 => listToDo2;
  setListToDo2(newValue) => listToDo2.add(newValue);

  Future<void> addTodo2() async {
    Rx<Todo> newToDo = Todo().obs;

    newToDo.value.name = controllerTask.text;
    controllerTask.text = "";
    newToDo.value.ok = false;
    listToDo2.add(newToDo);
    await GetStorage().write("todo", listToDo2);
  }

  void updateCheckBox2(int index, bool value) {
    listToDo2[index].value.ok = value;
    listToDo2.refresh();
    GetStorage().write("todo", listToDo2);
  }

  initializeList() {
    var getList = GetStorage().read("todo");

    getList.forEach((element) {
      Todo todo = Todo.fromJson(element);

      listToDo2.add(todo.obs);
    });
  }

  removedTodo(int index) {
    lastRemoved.value = listToDo2[index].value;
    lastToDoRemovedIndexPos.value = index;
    listToDo2.removeAt(index);
    GetStorage().write("todo", listToDo2);
  }

  undoAction(int index) {
    listToDo2.insert(index, lastRemoved.value.obs);
    GetStorage().write("todo", listToDo2);
  }

  editTaskText(int index) async {
    Rx<Todo> example = Todo().obs;

    example.value.name = controllerEdit.text;
    controllerEdit.text = "";

    listToDo2[index].value.name = example.value.name;
    await GetStorage().write("todo", listToDo2);
  }

  editTaskDialog(int index) {
    Get.defaultDialog(
        barrierDismissible: false,
        title: "Editar Tarefa",
        content: Column(
          children: [
            TextFormField(
              controller: controllerEdit,
              decoration: InputDecoration(
                labelText: "Nome da Tarefa",
              ),
            ),
          ],
        ),
        buttonColor: Colors.white,
        cancelTextColor: Colors.red,
        confirmTextColor: Colors.green,
        textCancel: "Cancelar",
        textConfirm: "Atualizar",
        onCancel: () {
          listToDo2.refresh();
          Get.back();
        },
        onConfirm: () {
          if (controllerEdit.text != "") {
            editTaskText(index);

            listToDo2.refresh();
            Get.back();
          }
        });
  }

  @override
  void onReady() {
    // TODO: implement onReady
    super.onReady();

    initializeList();
  }
}
