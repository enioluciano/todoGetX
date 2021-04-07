class Todo {
  String name;
  bool ok;

  Todo({this.name, this.ok});

  Todo.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    ok = json['ok'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();

    data['name'] = this.name;
    data['ok'] = this.ok;
    return data;
  }
}
