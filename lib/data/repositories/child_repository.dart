import 'package:child_milestone/data/dao/child_dao.dart';
import 'package:child_milestone/data/models/child_model.dart';

class ChildRepository {
  final childDao = ChildDao();

  Future getAllChildren({List<String>? columns, String? query}) =>
      childDao.getChilds(columns: columns, query: query);

  Future insertChild(ChildModel child) => childDao.createChild(child);

  Future updateChild(ChildModel child) => childDao.updateChild(child);

  Future deleteChildById(int id) => childDao.deleteChild(id);

  Future deleteAllChilds() => childDao.deleteAllChilds();

  get_childs_list() async {
    List<ChildModel> childs = [
      ChildModel(
        name: "Ahmad",
        date_of_birth: DateTime(2022, 1, 1),
        image_path: "assets/images/children/child1",
        gender: 'Male',
        child_id: '123',
        pregnancy_duration: 36,
      ),
      ChildModel(
        name: "Sara",
        date_of_birth: DateTime(2022, 2, 2),
        image_path: "assets/images/children/child2",
        gender: 'Female',
        child_id: '222',
        pregnancy_duration: 36,
      ),
    ];
    return childs;
  }
}
