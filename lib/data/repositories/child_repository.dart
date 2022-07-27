import 'package:child_milestone/constants/tuples.dart';
import 'package:child_milestone/data/models/child_model.dart';

class ChildRepository {
  final childDao;

  ChildRepository(this.childDao);

  Future getAllChildren() async {
    List<Map<String, dynamic>> result = await childDao.getAllChildren();

    return result.isNotEmpty
        ? result.map((item) => ChildModel.fromMap(item)).toList()
        : List<ChildModel>.empty();
  }

  Future<DaoResponse<bool, int>> insertChild(ChildModel child) =>
      childDao.createChild(child);

  Future updateChild(ChildModel child) => childDao.updateChild(child);

  Future deleteChildById(int id) => childDao.deleteChild(id);

  Future deleteAllChildren() => childDao.deleteAllChildren();

  Future<ChildModel?> getChildByID(int id) async {
    Map<String, dynamic>? result = await childDao.getChildByID(id);
    if (result != null) {
      ChildModel child = ChildModel.fromMap(result);
      return child;
    }
  }

  get_children_list() async {
    List<ChildModel> children = [
      ChildModel(
        id: 1,
        name: "Ahmad",
        dateOfBirth: DateTime(2022, 1, 1),
        imagePath: "assets/images/children/child1",
        gender: 'Male',
        pregnancyDuration: 36,
      ),
      ChildModel(
        id: 2,
        name: "Sara",
        dateOfBirth: DateTime(2022, 2, 2),
        imagePath: "assets/images/children/child2",
        gender: 'Female',
        pregnancyDuration: 36,
      ),
    ];
    return children;
  }
}
