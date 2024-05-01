import 'package:child_milestone/data/models/child_model.dart';
import 'package:child_milestone/data/models/tip.dart';
import 'package:child_milestone/logic/shared/functions.dart';

class TipRepository {
  final tipDao;

  TipRepository(this.tipDao);

  Future getAllTips() async {
    List<Map<String, dynamic>> result = await tipDao.getAllTips();

    return result.isNotEmpty
        ? result.map((item) => TipModel.fromMap(item)).toList()
        : List<TipModel>.empty();
  }

  Future insertTip(TipModel tip) => tipDao.createTip(tip);

  Future updateTip(TipModel tip) => tipDao.updateTip(tip);

  Future deleteTipById(int id) => tipDao.deleteTip(id);

  Future deleteAllTips() => tipDao.deleteAllTips();

  Future<TipModel?> getTipByID(int tip_id) async {
    Map<String, dynamic>? result = await tipDao.getTipByID(tip_id);
    if (result != null) {
      TipModel tip = TipModel.fromMap(result);
      return tip;
    }
    return null;
  }

  Future<List<TipModel>?> getTipsByAge(ChildModel child) async {
    int period = periodCalculator(child).id;

    List<Map<String, dynamic>> result = await tipDao.getTipsByAge(period);

    return result.map((item) => TipModel.fromMap(item)).toList();
  }
}
