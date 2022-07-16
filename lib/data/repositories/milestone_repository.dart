import 'package:child_milestone/data/models/milestone_item.dart';
import 'package:child_milestone/logic/shared/functions.dart';

class MilestoneRepository {
  final milestoneDao;

  MilestoneRepository(this.milestoneDao);

  Future getAllMilestones() async {
    List<Map<String, dynamic>> result = await milestoneDao.getAllMilestones();

    return result.isNotEmpty
        ? result.map((item) => MilestoneItem.fromMap(item)).toList()
        : null;
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
  }

  Future<List<MilestoneItem>?> getMilestonesByAge(DateTime dateOfBirth) async {
    int period = periodCalculator(dateOfBirth);
    List<Map<String, dynamic>> result =
        await milestoneDao.getMilestonesByAge(period);

    return result.isNotEmpty
        ? result.map((item) => MilestoneItem.fromMap(item)).toList()
        : [];
  }

  Future<List<MilestoneItem>?> getMilestonesByChild(DateTime dateOfBirth) async {
    List<Map<String, dynamic>> result =
        await milestoneDao.getMilestonesByChild();

    return result.isNotEmpty
        ? result.map((item) => MilestoneItem.fromMap(item)).toList()
        : [];
  }
}
