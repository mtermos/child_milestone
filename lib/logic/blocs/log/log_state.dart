// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'log_bloc.dart';

@immutable
abstract class LogState extends Equatable {
  @override
  List<Object?> get props => [];
}

class InitialLogState extends LogState {}

class AddingLogState extends LogState {}

class AddedLogState extends LogState {
  final LogModel log;

  AddedLogState(this.log);

  @override
  List<Object?> get props => [log];
}

class LogLoadingState extends LogState {}

class LogLoadingErrorState extends LogState {}

class LogLoadedState extends LogState {
  final LogModel log;

  LogLoadedState(this.log);

  @override
  List<Object?> get props => [log];
}

class AllLogsLoadingState extends LogState {}

class AllLogsLoadingErrorState extends LogState {}

class AllLogsLoadedState extends LogState {
  final List<LogModel> logs;

  AllLogsLoadedState(this.logs);

  @override
  List<Object?> get props => [logs];
}

class DeleteingAllLogsState extends LogState {}

class DeletedAllLogsState extends LogState {}

class LogErrorState extends LogState {
  final String error;

  LogErrorState(this.error);

  @override
  List<Object?> get props => [error];
}

class UploadingLogsState extends LogState {}

class ErrorUploadingLogsState extends LogState {
  final String error;
  ErrorUploadingLogsState({
    required this.error,
  });
}

class UploadedLogsState extends LogState {}
