// import 'package:fluent_ui/fluent_ui.dart';
// import 'package:flutter/material.dart' as material;
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:real_estate_estimator/constants/enums.dart';
// import 'package:real_estate_estimator/data/models/town_model.dart';
// import 'package:real_estate_estimator/logic/cubits/price_estimation/price_estimation_cubit.dart';
// import 'package:real_estate_estimator/presentation/widgets/house_type_field.dart';

// import '../widgets/town_field.dart';

// class Forms extends StatefulWidget {
//   const Forms({Key? key}) : super(key: key);

//   @override
//   _FormsState createState() => _FormsState();
// }

// class _FormsState extends State<Forms> {
//   List<bool> _isSelected = [false, false, false];
//   final myController = TextEditingController();
//   List<TownModel> towns = [];
//   TownModel town = TownModel(name: "", price_per_meter: 0);
//   double current_price = 0;
//   HomeType? homeType;

//   final _clearController = TextEditingController();

//   String? comboBoxValue;

//   DateTime date = DateTime.now();

//   @override
//   void initState() {
//     super.initState();
//     _clearController.addListener(() {
//       if (_clearController.text.length == 1 && mounted) setState(() {});
//     });
//   }

//   void callback(HomeType? newHomeType) {
//     setState(() {
//       homeType = newHomeType;
//     });
//   }

//   @override
//   void dispose() {
//     _clearController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return ScaffoldPage.scrollable(
//       header: const PageHeader(title: Text('Real-State Price Estimator')),
//       children: [
//         Title(color: Colors.black, child: const Text("Town")),
//         const SizedBox(height: 3),
//         town_field(town, towns),
//         const SizedBox(height: 20),
//         Row(
//           children: [
//             Expanded(
//               child: TextFormBox(
//                 header: 'House Area in m²',
//                 placeholder: 'Enter House Area in m²',
//                 controller: myController,
//                 prefix: const Padding(
//                   padding: EdgeInsetsDirectional.all(8.0),
//                   child: Icon(
//                     FluentIcons.charticulator_plot_cartesian,
//                     size: 25,
//                   ),
//                 ),
//               ),
//             )
//           ],
//         ),
//         const SizedBox(height: 20),
//         Title(color: Colors.black, child: const Text("Type")),
//         const SizedBox(height: 3),
//         HouseTypeField(callback: callback),
//         // Row(
//         //   children: [
//         //     material.Material(
//         //       child: material.ToggleButtons(
//         //         children: <Widget>[
//         //           Container(
//         //               child: Text(HomeType.Apartment.name),
//         //               padding: const EdgeInsets.all(8.0)),
//         //           Container(
//         //               child: Text(HomeType.House.name),
//         //               padding: const EdgeInsets.all(8.0)),
//         //           Container(
//         //               child: Text(HomeType.Land.name),
//         //               padding: const EdgeInsets.all(8.0)),
//         //         ],
//         //         onPressed: (int index) {
//         //           setState(() {
//         //             _isSelected =
//         //                 List.filled(_isSelected.length, false, growable: true);
//         //             _isSelected[index] = true;
//         //           });
//         //         },
//         //         isSelected: _isSelected,
//         //       ),
//         //     )
//         //   ],
//         // ),
//         const SizedBox(height: 20),
//         Row(
//           children: [
//             Container(
//                 child: const Text('Estimated Price'),
//                 padding: EdgeInsets.fromLTRB(0, 5, 8, 5)),
//             Card(
//               child: BlocConsumer<PriceEstimationCubit, PriceEstimationState>(
//                 listener: (priceEstimationCubitContext, state) {
//                   if (state is PriceEstimationDoneState &&
//                       state.price_estimation_value > 0) {
//                     setState(() {
//                       current_price = state.price_estimation_value;
//                     });
//                   }
//                 },
//                 builder: (counterCubiBuilderContext, state) {
//                   return SelectableText(
//                     current_price.toStringAsFixed(3),
//                     selectionControls: fluentTextSelectionControls,
//                     showCursor: true,
//                     cursorWidth: 1.5,
//                   );
//                 },
//               ),
//             ),
//           ],
//         ),
//         const SizedBox(height: 20),
//         Row(
//           children: [
//             FilledButton(
//               child: const Text('Estimate Price'),
//               onPressed: () => BlocProvider.of<PriceEstimationCubit>(context)
//                   .estimate(double.parse(myController.text), town),
//             ),
//           ],
//         )
//       ],
//     );
//   }
// }
