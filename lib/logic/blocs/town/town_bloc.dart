// import 'dart:async';

// import 'package:equatable/equatable.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:meta/meta.dart';
// import 'package:child_milestone/logic/blocs/internet/internet_bloc.dart';

// import '../../../data/models/town_model.dart';
// import '../../../data/repositories/town_repository.dart';

// part "town_event.dart";
// part "town_state.dart";

// class TownBloc extends Bloc<TownEvent, TownState> {
//   final InternetBloc internetBloc;
//   final TownRepository townRepository;
//   late StreamSubscription internetBlocSubscription;

//   TownBloc({required this.internetBloc, required this.townRepository})
//       : super(TownLoadingState()) {
//     internetBlocSubscription = internetBloc.stream.listen((state) {
//       print("connection lost!!");
//     });
//     on<LoadTownEvent>((event, emit) async {
//       emit(TownLoadingState());
//       try {
//         final List<TownModel> towns = await townRepository.get_towns_list();
//         emit(TownLoadedState(towns));
//       } catch (e) {
//         emit(TownErrorState(e.toString()));
//       }
//     });
//   }

//   @override
//   Future<void> close() {
//     internetBlocSubscription.cancel();
//     return super.close();
//   }
// }
