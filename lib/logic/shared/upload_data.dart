import 'dart:convert';

import 'package:child_milestone/data/models/milestone_item.dart';
import 'package:child_milestone/logic/blocs/child/child_bloc.dart';
import 'package:child_milestone/logic/blocs/decision/decision_bloc.dart';
import 'package:child_milestone/logic/blocs/rating/rating_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

bool uploadData(BuildContext context) {
  // upload children
  BlocProvider.of<ChildBloc>(context).add(UploadChildrenEvent(context: context));

  // upload ratings
  // BlocProvider.of<RatingBloc>(context).add(const UploadRatingsEvent());

  return false;
}
