import 'package:child_milestone/constants/tuples.dart';
import 'package:child_milestone/data/models/decision.dart';
import 'package:child_milestone/logic/shared/functions.dart';

class DecisionRepository {
  final decisionDao;

  DecisionRepository(this.decisionDao);

  Future<List<DecisionModel>> getAllDecisions() async {
    List<Map<String, dynamic>> result = await decisionDao.getAllDecisions();

    return result.isNotEmpty
        ? result.map((item) => DecisionModel.fromMap(item)).toList()
        : List<DecisionModel>.empty();
  }

  Future insertDecision(DecisionModel decision) =>
      decisionDao.createDecision(decision);

  Future updateDecision(DecisionModel decision) =>
      decisionDao.updateDecision(decision);

  Future deleteDecisionById(int id) => decisionDao.deleteDecision(id);

  Future deleteAllDecisions() => decisionDao.deleteAllDecisions();

  Future<DecisionModel?> getDecisionByID(int decision_id) async {
    Map<String, dynamic>? result =
        await decisionDao.getDecisionByID(decision_id);
    if (result != null) {
      DecisionModel decision = DecisionModel.fromMap(result);
      return decision;
    }
  }

  Future<List<DecisionModel>> getDecisionsByChild(int childId) async {
    List response = await decisionDao.getDecisionsByChild(childId);

    return response.isNotEmpty
        ? response.map((item) => DecisionModel.fromMap(item)).toList()
        : List<DecisionModel>.empty();
  }

  Future<DaoResponse<List<DecisionModel>, int>> getDecisionsByAge(
      DateTime dateOfBirth, int childId) async {
    int period = periodCalculator(dateOfBirth).id;
    DaoResponse<List, int> daoResponse =
        await decisionDao.getDecisionsByAge(period, childId);

    return DaoResponse(
        daoResponse.item1.isNotEmpty
            ? daoResponse.item1
                .map((item) => DecisionModel.fromMap(item))
                .toList()
            : List<DecisionModel>.empty(),
        daoResponse.item2);
  }

  Future<DecisionModel?> getDecisionByChildAndMilestone(
      int childId, int milestoneId) async {
    Map<String, dynamic> decisionMap =
        await decisionDao.getDecisionByChildAndMilestone(childId, milestoneId);

    return decisionMap.isNotEmpty ? DecisionModel.fromMap(decisionMap) : null;
  }
}
