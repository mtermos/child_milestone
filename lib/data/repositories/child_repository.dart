import 'package:child_milestone/data/models/child_model.dart';

class ChildRepository {
  get_childs_list() async {
    List<ChildModel> childs = [
      ChildModel(
          name: "Ahmad",
          date_of_birth: DateTime(2022, 1, 1),
          image: "assets/images/children/child1"),
      ChildModel(
          name: "Sara",
          date_of_birth: DateTime(2022, 2, 2),
          image: "assets/images/children/child2"),
    ];
    return childs;
  }
}
