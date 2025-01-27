import 'package:child_milestone/data/models/child_model.dart';
import 'package:child_milestone/data/models/milestone_item.dart';
import 'package:child_milestone/logic/shared/functions.dart';

class MilestoneRepository {
  final milestoneDao;

  MilestoneRepository(this.milestoneDao);

  Future getAllMilestones() async {
    List<Map<String, dynamic>> result = await milestoneDao.getAllMilestones();

    return result.isNotEmpty
        ? result.map((item) => MilestoneItem.fromMap(item)).toList()
        : List<MilestoneItem>.empty();
  }

  Future insertMilestone(MilestoneItem milestone) =>
      milestoneDao.createMilestone(milestone);

  Future updateMilestone(MilestoneItem milestone) =>
      milestoneDao.updateMilestone(milestone);

  Future deleteMilestoneById(int id) => milestoneDao.deleteMilestone(id);

  Future deleteAllMilestones() => milestoneDao.deleteAllMilestones();

  Future<MilestoneItem?> getMilestoneByID(int milestone_id) async {
    Map<String, dynamic>? result =
        await milestoneDao.getMilestoneByID(milestone_id);
    if (result != null) {
      MilestoneItem milestone = MilestoneItem.fromMap(result);
      return milestone;
    }
    return null;
  }

  Future<List<MilestoneItem>?> getMilestonesByAge(ChildModel child) async {
    int period = periodCalculator(child).id;
    List<Map<String, dynamic>> result =
        await milestoneDao.getMilestonesByAge(period);

    return result.isNotEmpty
        ? result.map((item) => MilestoneItem.fromMap(item)).toList()
        : List<MilestoneItem>.empty();
  }

  Future<List<MilestoneItem>?> getMilestonesByPeriod(int period) async {
    List<Map<String, dynamic>> result =
        await milestoneDao.getMilestonesByAge(period);

    return result.isNotEmpty
        ? result.map((item) => MilestoneItem.fromMap(item)).toList()
        : List<MilestoneItem>.empty();
  }

  Future<List<MilestoneItem>?> getMilestonesByChild(
      DateTime dateOfBirth) async {
    List<Map<String, dynamic>> result =
        await milestoneDao.getMilestonesByChild();

    return result.isNotEmpty
        ? result.map((item) => MilestoneItem.fromMap(item)).toList()
        : List<MilestoneItem>.empty();
  }

  Future getMilestonesUntilPeriod(int period) async {
    List<Map<String, dynamic>> result =
        await milestoneDao.getMilestonesUntilPeriod(period);

    return result.isNotEmpty
        ? result.map((item) => MilestoneItem.fromMap(item)).toList()
        : List<MilestoneItem>.empty();
  }

  Future getMilestonesUntilMonth(int months) async {
    List<Map<String, dynamic>> result =
        await milestoneDao.getMilestonesUntilMonth(months);

    return result.isNotEmpty
        ? result.map((item) => MilestoneItem.fromMap(item)).toList()
        : List<MilestoneItem>.empty();
  }
}
