import 'package:child_milestone/data/models/log.dart';

class LogRepository {
  final logDao;

  LogRepository(this.logDao);

  Future getAllLogs() async {
    List<Map<String, dynamic>> result = await logDao.getAllLogs();

    return result.isNotEmpty
        ? result.map((item) => LogModel.fromMap(item)).toList()
        : List<LogModel>.empty();
  }

  Future getLogsBtwDates(DateTime startDate, DateTime endDate) async {
    List<Map<String, dynamic>> result =
        await logDao.getLogsBtwDates(startDate, endDate);

    return result.isNotEmpty
        ? result.map((item) => LogModel.fromMap(item)).toList()
        : List<LogModel>.empty();
  }

  Future insertLog(LogModel log) => logDao.createLog(log.toMap());

  Future updateLog(LogModel log) => logDao.updateLog(log.toMap());

  Future deleteLogById(int id) => logDao.deleteLog(id);

  Future deleteAllLogs() => logDao.deleteAllLogs();

  Future<LogModel?> getLogByID(int logId) async {
    Map<String, dynamic>? result = await logDao.getLogByID(logId);
    if (result != null) {
      LogModel log = LogModel.fromMap(result);
      return log;
    }
    return null;
  }
}
