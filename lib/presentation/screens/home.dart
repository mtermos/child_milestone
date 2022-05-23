// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:child_milestone/logic/blocs/internet/internet_bloc.dart';
// import 'package:child_milestone/logic/blocs/town/town_bloc.dart';
// import 'package:child_milestone/presentation/tabs/animated.dart';
// import 'package:child_milestone/presentation/tabs/estimator_form.dart';
// import 'package:child_milestone/presentation/tabs/settings.dart';

// class Home extends StatefulWidget {
//   Home({Key? key}) : super(key: key);

//   @override
//   State<Home> createState() => _HomeState();
// }

// class _HomeState extends State<Home> {
//   int index = 0;
//   final viewKey = GlobalKey();

//   @override
//   Widget build(BuildContext context) {
//     return NavigationView(
//       key: viewKey,
//       pane: NavigationPane(
//         selected: index,
//         onChanged: (i) => setState(() {
//           index = i;
//         }),
//         size: const NavigationPaneSize(
//           openMinWidth: 250,
//           openMaxWidth: 320,
//         ),
//         header: Container(
//           height: kOneLineTileHeight,
//           padding: const EdgeInsets.symmetric(horizontal: 10.0),
//           child: FlutterLogo(),
//         ),
//         displayMode: PaneDisplayMode.auto,
//         items: [
//           PaneItem(
//               icon: const Icon(FluentIcons.calculator),
//               title: const Text("Estimate Price")),
//           PaneItem(
//               icon: const Icon(FluentIcons.calculator),
//               title: const Text("Estimate Price"))
//         ],
//         footerItems: [
//           PaneItemSeparator(),
//           PaneItem(
//             icon: const Icon(FluentIcons.settings),
//             title: const Text('Settings'),
//           ),
//         ],
//       ),
//       content: NavigationBody(
//         index: index,
//         transitionBuilder: (child, animation) {
//           return EntrancePageTransition(child: child, animation: animation);
//         },
//         animationDuration: Duration(milliseconds: 300),
//         children: [
//           BlocBuilder<InternetBloc, InternetState>(
//             builder: (context, state) {
//               if (state is InternetConnected) {
//                 return Forms();
//               } else if (state is InternetDisconnected) {
//                 return const Center(child: Text('Connection problem!!'));
//               } else {
//                 return Container();
//               }
//             },
//           ),
//           BlocBuilder<InternetBloc, InternetState>(
//             builder: (context, state) {
//               if (state is InternetConnected) {
//                 return PriceEstimationAnimated();
//               } else if (state is InternetDisconnected) {
//                 return const Center(child: Text('Connection problem!!'));
//               } else {
//                 return Container();
//               }
//             },
//           ),
//           Settings(),
//         ],
//       ),
//     );
//     // return Container(
//     //   color: Colors.blue,
//     //   child: Center(
//     //     child: Column(
//     //       mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//     //       children: [
//     //         Button(
//     //           child: const Text('List Groceries'),
//     //           onPressed: () async {
//     //             final groceries = await groceryCollection.get();

//     //             print(groceries);
//     //           },
//     //         ),
//     //       ],
//     //     ),
//     //   ),
//     // );
//   }

//   @override
//   void initState() {
//     super.initState();
//   }

//   @override
//   void dispose() {
//     super.dispose();
//   }
// }
