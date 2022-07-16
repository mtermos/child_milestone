import 'package:child_milestone/data/models/tip.dart';
import 'package:child_milestone/logic/shared/functions.dart';

class TipRepository {
  final tipDao;

  TipRepository(this.tipDao);

  Future getAllTips() async {
    List<Map<String, dynamic>> result = await tipDao.getAllTips();

    return result.isNotEmpty
        ? result.map((item) => TipModel.fromMap(item)).toList()
        : null;
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
  }

  Future<List<TipModel>?> getTipsByAge(DateTime dateOfBirth) async {
    int period = periodCalculator(dateOfBirth);

    List<Map<String, dynamic>> result = await tipDao.getTipsByAge(period);

    return result.map((item) => TipModel.fromMap(item)).toList();
  }
}
