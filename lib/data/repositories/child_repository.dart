// ignore_for_file: prefer_typing_uninitialized_variables

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
    return null;
  }
}
