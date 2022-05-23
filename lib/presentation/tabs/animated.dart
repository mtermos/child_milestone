// import 'package:fluent_ui/fluent_ui.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:real_estate_estimator/constants/enums.dart';
// import 'package:real_estate_estimator/logic/cubits/price_estimation/price_estimation_cubit.dart';
// import 'package:real_estate_estimator/presentation/widgets/house_type_field.dart';
// import 'package:responsive_framework/responsive_framework.dart';
// import 'package:real_estate_estimator/data/models/town_model.dart';
// import 'package:real_estate_estimator/presentation/widgets/house_area_field.dart';
// import 'package:real_estate_estimator/presentation/widgets/town_field.dart';

// class PriceEstimationAnimated extends StatefulWidget {
//   const PriceEstimationAnimated({Key? key}) : super(key: key);

//   @override
//   _CrossFadeAnimationDemoState createState() => _CrossFadeAnimationDemoState();
// }

// class _CrossFadeAnimationDemoState extends State<PriceEstimationAnimated> {
//   Row? first, second;
//   HouseTypeField? third;
//   Widget? _myAnimated;
//   final house_area_controller = TextEditingController();
//   HomeType? homeType;
//   int _count = 0;
//   Map<String, double> towns_map = {};
//   List<TownModel> towns = [];
//   TownModel town = TownModel(name: "", price_per_meter: 0);
//   double current_price = 0.0;
//   double current_area = 0.0;
//   double area = 0;
//   double? _height;
//   String button_text = "Next";
//   bool connected = false;

//   void callback(HomeType? newHomeType) {
//     setState(() {
//       homeType = newHomeType;
//     });
//   }

//   @override
//   void initState() {
//     first = town_field(town, towns);
//     second = house_area_field(house_area_controller);
//     third = HouseTypeField(callback: callback);
//     _myAnimated = first;
//     _height = 20;
//     super.initState();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Builder(
//         builder: (context) => ResponsiveWrapper.builder(
//               ScaffoldPage.withPadding(
//                 header:
//                     const PageHeader(title: Text('Real-State Price Estimator')),
//                 content: Container(
//                   decoration: const BoxDecoration(
//                       color: Color.fromRGBO(51, 51, 51, 0.5),
//                       borderRadius: BorderRadius.all(Radius.circular(20))),
//                   padding: EdgeInsets.all(15.0),
//                   child: Row(
//                     mainAxisSize: MainAxisSize.min,
//                     children: [
//                       Expanded(
//                         flex: 5,
//                         child: Column(
//                           crossAxisAlignment: CrossAxisAlignment.center,
//                           mainAxisAlignment: MainAxisAlignment.center,
//                           children: [
//                             AnimatedSwitcher(
//                               duration: const Duration(milliseconds: 200),
//                               reverseDuration: const Duration(milliseconds: 0),
//                               transitionBuilder:
//                                   (Widget child, Animation<double> animation) {
//                                 return ScaleTransition(
//                                     scale: animation, child: child);
//                               },
//                               child: _myAnimated,
//                             ),
//                             const SizedBox(height: 20),
//                             Button(
//                               child: Text(button_text),
//                               onPressed: () async {
//                                 if (_myAnimated == first) {
//                                   if (town.name != "") {
//                                     setState(() {
//                                       _myAnimated = second;
//                                     });
//                                   }
//                                 } else if (_myAnimated == second) {
//                                   if (house_area_controller.text != "") {
//                                     setState(() {
//                                       area = double.parse(
//                                           house_area_controller.text);
//                                       _myAnimated = third;
//                                       button_text = "Estimate Price";
//                                     });
//                                     // var current_area = double.parse(
//                                     //     house_area_controller.text);
//                                     // if (current_area > 0) {
//                                     //   BlocProvider.of<PriceEstimationCubit>(
//                                     //           context)
//                                     //       .estimate(current_area, town);
//                                     //   setState(() {
//                                     //     area = current_area;
//                                     //   });
//                                     // }
//                                   }
//                                 } else if (_myAnimated == third) {
//                                   if (homeType != null) {
//                                     BlocProvider.of<PriceEstimationCubit>(
//                                             context)
//                                         .estimate(area, town);
//                                     print(homeType);
//                                   }
//                                 }
//                               },
//                             ),
//                           ],
//                         ),
//                       ),
//                       const SizedBox(width: 40),
//                       Expanded(
//                         flex: 5,
//                         child: Column(
//                           crossAxisAlignment: CrossAxisAlignment.center,
//                           mainAxisAlignment: MainAxisAlignment.center,
//                           children: [
//                             const Text(
//                               "Your Information:",
//                               style: TextStyle(
//                                   fontSize: 24, fontWeight: FontWeight.bold),
//                             ),
//                             const SizedBox(height: 20),
//                             Row(
//                               children: [
//                                 const Text(
//                                   "Town: ",
//                                   style: TextStyle(fontWeight: FontWeight.bold),
//                                 ),
//                                 TextButton(
//                                   onPressed: () {
//                                     setState(() {
//                                       _myAnimated = first;
//                                       button_text = "Next";
//                                     });
//                                   },
//                                   child: Text(
//                                     town.name,
//                                     style: const TextStyle(
//                                         fontSize: 16, color: Colors.black),
//                                   ),
//                                 )
//                               ],
//                             ),
//                             Row(
//                               children: [
//                                 const Text(
//                                   "House Area: ",
//                                   style: TextStyle(fontWeight: FontWeight.bold),
//                                 ),
//                                 TextButton(
//                                   onPressed: () {
//                                     setState(() {
//                                       _myAnimated = second;
//                                       button_text = "Next";
//                                     });
//                                   },
//                                   child: Text(
//                                     (area > 0)
//                                         ? area.toStringAsFixed(2) + " m²"
//                                         : "",
//                                     style: const TextStyle(
//                                         fontSize: 16, color: Colors.black),
//                                   ),
//                                 ),
//                               ],
//                             ),
//                             Row(
//                               children: [
//                                 const Text(
//                                   "House Type:",
//                                   style: TextStyle(fontWeight: FontWeight.bold),
//                                 ),
//                                 TextButton(
//                                   onPressed: () {
//                                     print(homeType.hashCode);
//                                     setState(() {
//                                       _myAnimated = third;
//                                       button_text = "Next";
//                                     });
//                                   },
//                                   child: Text(
//                                     (homeType != null) ? homeType!.name : "",
//                                     style: const TextStyle(
//                                         fontSize: 16, color: Colors.black),
//                                   ),
//                                 ),
//                               ],
//                             ),
//                             const SizedBox(height: 7),
//                             Row(
//                               children: [
//                                 const Text(
//                                   "Current Price: ",
//                                   style: TextStyle(fontWeight: FontWeight.bold),
//                                 ),
//                                 BlocConsumer<PriceEstimationCubit,
//                                     PriceEstimationState>(
//                                   listener:
//                                       (priceEstimationCubitContext, state) {
//                                     if (state is PriceEstimationDoneState &&
//                                         state.price_estimation_value > 0) {
//                                       setState(() {
//                                         current_price =
//                                             state.price_estimation_value;
//                                       });
//                                     }
//                                   },
//                                   builder: (counterCubiBuilderContext, state) {
//                                     return Text(
//                                         (current_price > 0)
//                                             ? current_price.toStringAsFixed(3)
//                                             : "",
//                                         style: const TextStyle(
//                                             fontSize: 16, color: Colors.black));
//                                   },
//                                 ),
//                               ],
//                             ),
//                           ],
//                         ),
//                       )
//                     ],
//                   ),
//                 ),
//               ),
//               defaultScale: true,
//               backgroundColor: Colors.grey,
//               breakpoints: [
//                 const ResponsiveBreakpoint.resize(480, name: MOBILE),
//                 const ResponsiveBreakpoint.autoScale(800, name: TABLET),
//                 const ResponsiveBreakpoint.resize(1000, name: DESKTOP),
//               ],
//             ));
//   }
// }
