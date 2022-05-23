// import 'package:fluent_ui/fluent_ui.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:real_estate_estimator/logic/blocs/town/town_bloc.dart';
// import '../../data/models/town_model.dart';

// Row town_field(TownModel town, List<TownModel> towns) {
//   return Row(
//     children: [
//       Expanded(
//         child: BlocBuilder<TownBloc, TownState>(
//           builder: (context, state) {
//             if (state is TownLoadedState) {
//               towns.clear();
//               towns.addAll(state.towns);
//               return AutoSuggestBox(
//                 items: towns.map((e) => e.name).toList(),
//                 placeholder: 'Pick a town',
//                 trailingIcon: IconButton(
//                   icon: const Icon(FluentIcons.search),
//                   onPressed: () {
//                     debugPrint('trailing button pressed');
//                   },
//                 ),
//                 onSelected: (text) {
//                   TownModel selected_town =
//                       towns.where((element) => element.name == text).first;
//                   town.name = selected_town.name;
//                   town.price_per_meter = selected_town.price_per_meter;
//                 },
//               );
//             } else if (state is TownLoadingState) {
//               return const Center(child: Text('Loading..'));
//             } else {
//               return Container();
//             }
//           },
//         ),
//       )
//     ],
//   );
// }
