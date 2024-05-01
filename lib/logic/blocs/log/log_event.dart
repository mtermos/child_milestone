// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'log_bloc.dart';

@immutable
abstract class LogEvent extends Equatable {
  const LogEvent();
  @override
  List<Object> get props => [];
}

class AddLogEvent extends LogEvent {
  final LogModel log;

  const AddLogEvent({
    required this.log,
  });
}

class GetAllLogsEvent extends LogEvent {}

class DeleteAllLogsEvent extends LogEvent {}

class GetLogEvent extends LogEvent {
  final int logId;
  const GetLogEvent({required this.logId});
}

class UploadLogsEvent extends LogEvent {
  const UploadLogsEvent();
}
