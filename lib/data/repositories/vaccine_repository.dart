import 'package:child_milestone/data/models/child_model.dart';
import 'package:child_milestone/data/models/vaccine.dart';
import 'package:child_milestone/logic/shared/functions.dart';

class VaccineRepository {
  final vaccineDao;

  VaccineRepository(this.vaccineDao);

  Future getAllVaccines() async {
    List<Map<String, dynamic>> result = await vaccineDao.getAllVaccines();

    return result.isNotEmpty
        ? result.map((item) => Vaccine.fromMap(item)).toList()
        : List<Vaccine>.empty();
  }

  Future insertVaccine(Vaccine vaccine) =>
      vaccineDao.createVaccine(vaccine);

  Future updateVaccine(Vaccine vaccine) =>
      vaccineDao.updateVaccine(vaccine);

  Future deleteVaccineById(int id) => vaccineDao.deleteVaccine(id);

  Future deleteAllVaccines() => vaccineDao.deleteAllVaccines();

  Future<Vaccine?> getVaccineByID(int vaccine_id) async {
    Map<String, dynamic>? result =
        await vaccineDao.getVaccineByID(vaccine_id);
    if (result != null) {
      Vaccine vaccine = Vaccine.fromMap(result);
      return vaccine;
    }
    return null;
  }

  Future<List<Vaccine>?> getVaccinesByAge(ChildModel child) async {
    int period = periodCalculator(child).id;
    List<Map<String, dynamic>> result =
        await vaccineDao.getVaccinesByAge(period);

    return result.isNotEmpty
        ? result.map((item) => Vaccine.fromMap(item)).toList()
        : List<Vaccine>.empty();
  }

  Future<List<Vaccine>?> getVaccinesByPeriod(int period) async {
    List<Map<String, dynamic>> result =
        await vaccineDao.getVaccinesByAge(period);

    return result.isNotEmpty
        ? result.map((item) => Vaccine.fromMap(item)).toList()
        : List<Vaccine>.empty();
  }

  Future<List<Vaccine>?> getVaccinesByChild(
      DateTime dateOfBirth) async {
    List<Map<String, dynamic>> result =
        await vaccineDao.getVaccinesByChild();

    return result.isNotEmpty
        ? result.map((item) => Vaccine.fromMap(item)).toList()
        : List<Vaccine>.empty();
  }

  Future getVaccinesUntilPeriod(int period) async {
    List<Map<String, dynamic>> result =
        await vaccineDao.getVaccinesUntilPeriod(period);

    return result.isNotEmpty
        ? result.map((item) => Vaccine.fromMap(item)).toList()
        : List<Vaccine>.empty();
  }
}
