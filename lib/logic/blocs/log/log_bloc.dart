import 'package:child_milestone/constants/strings.dart';
import 'package:child_milestone/constants/tuples.dart';
import 'package:child_milestone/data/models/log.dart';
import 'package:child_milestone/data/repositories/log_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
part 'log_event.dart';
part 'log_state.dart';

class LogBloc extends Bloc<LogEvent, LogState> {
  final LogRepository logRepository;

  LogBloc({required this.logRepository}) : super(InitialLogState()) {
    on<AddLogEvent>(addLog);
    on<GetAllLogsEvent>(getAllLogs);
    on<DeleteAllLogsEvent>(deleteAllLogs);
    on<GetLogEvent>(getLog);
    on<UploadLogsEvent>(uploadLogs);
  }

  void addLog(AddLogEvent event, Emitter<LogState> emit) async {
    emit(AddingLogState());
    DaoResponse<bool, int> daoResponse =
        await logRepository.insertLog(event.log);
    print('daoResponse: ${daoResponse.item1}');
    if (daoResponse.item1) {
      print("updateLogOnBackend");
      String? response = await updateLogOnBackend(event.log);
      print('response: ${response}');
      emit(AddedLogState(event.log));
    }
  }

  void getAllLogs(GetAllLogsEvent event, Emitter<LogState> emit) async {
    emit(AllLogsLoadingState());
    List<LogModel>? logs = await logRepository.getAllLogs();
    print('logs: ${logs}');
    if (logs != null) {
      emit(AllLogsLoadedState(logs));
    } else {
      emit(AllLogsLoadingErrorState());
    }
  }

  void deleteAllLogs(DeleteAllLogsEvent event, Emitter<LogState> emit) async {
    emit(DeleteingAllLogsState());
    await logRepository.deleteAllLogs();
    emit(DeletedAllLogsState());
  }

  void getLog(GetLogEvent event, Emitter<LogState> emit) async {
    emit(LogLoadingState());
    LogModel? log = await logRepository.getLogByID(event.logId);
    if (log != null) {
      emit(LogLoadedState(log));
    } else {
      emit(LogLoadingErrorState());
    }
  }

  void uploadLogs(UploadLogsEvent event, Emitter<LogState> emit) async {
    emit(UploadingLogsState());
    List<LogModel> newLogs = (await logRepository.getAllLogs())
        .where((element) => !element.uploaded)
        .toList();

    bool noErrors = true;
    if (newLogs.isNotEmpty) {
      for (var log in newLogs) {
        String? error = await updateLogOnBackend(log);
        if (error == null) {
          log.uploaded = true;
          await logRepository.updateLog(log);
        } else {
          noErrors = false;
          emit(ErrorUploadingLogsState(error: error));
        }
      }
    }
    if (noErrors) emit(UploadedLogsState());
  }

  Future<String?> updateLogOnBackend(LogModel logModel) async {
    print('logModel: ${logModel}');
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString(SharedPrefKeys.accessToken);
    String? userID = prefs.getString(SharedPrefKeys.userID);
    if (token != null) {
      try {
        print("uploading logs");
        final response = await http.post(
          Uri.parse(Urls.backendUrl + Urls.addLogUrl),
          headers: {
            "Authorization": "Bearer " + token,
          },
          body: {
            "user_id": userID,
            "action": logModel.action,
            "description": logModel.description,
            "takenAt": logModel.takenAt.toString(),
          },
        );
        print('response.body: ${response.body}');
        if (response.statusCode == 200) {
          return null;
        } else {
          return "response not 200";
        }
      } catch (e) {
        print('e: ${e}');
        return "connection failed";
      }
    }
    return "token not available";
  }
}
