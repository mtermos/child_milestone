import 'package:child_milestone/logic/blocs/child/child_bloc.dart';
import 'package:child_milestone/logic/blocs/log/log_bloc.dart';
import 'package:child_milestone/logic/blocs/rating/rating_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

bool uploadData(BuildContext context) {
  // upload children
  BlocProvider.of<ChildBloc>(context).add(
      UploadChildrenEvent(appLocalizations: AppLocalizations.of(context)!));

  // upload ratings
  BlocProvider.of<RatingBloc>(context)
      .add(UploadRatingsEvent(appLocalizations: AppLocalizations.of(context)!));

  // upload logs
  BlocProvider.of<LogBloc>(context).add(const UploadLogsEvent());

  return false;
}
