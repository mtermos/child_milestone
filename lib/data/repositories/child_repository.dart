import 'package:child_milestone/data/models/child_model.dart';

class ChildRepository {
  final childDao;

  ChildRepository(this.childDao);

  Future getAllChildren() async {
    List<Map<String, dynamic>> result = await childDao.getAllChildren();

    return result.isNotEmpty
        ? result.map((item) => ChildModel.fromMap(item)).toList()
        : null;
  }

  Future insertChild(ChildModel child) => childDao.createChild(child);

  Future updateChild(ChildModel child) => childDao.updateChild(child);

  Future deleteChildById(int id) => childDao.deleteChild(id);

  Future deleteAllChildren() => childDao.deleteAllChildren();

  Future<ChildModel?> getChildByID(String child_id) async {
    Map<String, dynamic>? result = await childDao.getChildByID(child_id);
    if (result != null) {
      ChildModel child = ChildModel.fromMap(result);
      return child;
    }
  }

  get_children_list() async {
    List<ChildModel> children = [
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
    return children;
  }
}
