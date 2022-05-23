// import 'package:bloc/bloc.dart';
// import 'package:equatable/equatable.dart';

// import 'package:meta/meta.dart';
// import 'package:real_estate_estimator/data/models/town_model.dart';

// import 'package:cloud_functions/cloud_functions.dart';
// import 'package:firedart/firedart.dart' as firedart;

// part 'price_estimation_state.dart';

// class PriceEstimationCubit extends Cubit<PriceEstimationState> {
//   PriceEstimationCubit()
//       : super(PriceEstimationDoneState(price_estimation_value: 0.0));

//   void estimate(area, TownModel town) {
//     // emit(PriceEstimationCalculatingState());

//     // using firebase cloud functions (at the time of implementation it was not supported for windows):

//     // final result = await FirebaseFunctions
//     //     .instance
//     //     .httpsCallable('estimatePrice')
//     //     .call({
//     //   'town': town.name,
//     //   'area': current_area
//     // });
//     // var price = result.data["price"];
//     double price_estimation_value = area * town.price_per_meter;

//     emit(PriceEstimationDoneState(
//         price_estimation_value: price_estimation_value));
//   }
// }
