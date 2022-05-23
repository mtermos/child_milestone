import 'package:child_milestone/data/models/child_model.dart';

class ChildRepository {
  get_childs_list() async {
    List<ChildModel> childs = [
      ChildModel(name: "ahmad", date_of_birth: DateTime(2022, 1, 1)),
      ChildModel(name: "ali", date_of_birth: DateTime(2022, 2, 2)),
    ];
    return childs;
  }
}
