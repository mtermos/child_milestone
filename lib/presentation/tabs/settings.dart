// // ignore_for_file: constant_identifier_names

// import 'package:flutter/foundation.dart';

// import 'package:fluent_ui/fluent_ui.dart';

// const List<String> accentColorNames = [
//   'System',
//   'Yellow',
//   'Orange',
//   'Red',
//   'Magenta',
//   'Purple',
//   'Blue',
//   'Teal',
//   'Green',
// ];

// bool get kIsWindowEffectsSupported {
//   return !kIsWeb &&
//       [
//         TargetPlatform.windows,
//         TargetPlatform.linux,
//         TargetPlatform.macOS,
//       ].contains(defaultTargetPlatform);
// }

// class Settings extends StatelessWidget {
//   const Settings({Key? key, this.controller}) : super(key: key);

//   final ScrollController? controller;

//   @override
//   Widget build(BuildContext context) {
//     assert(debugCheckHasMediaQuery(context));
//     const spacer = SizedBox(height: 10.0);
//     const biggerSpacer = SizedBox(height: 40.0);
//     return ScaffoldPage.scrollable(
//       header: const PageHeader(title: Text('Settings')),
//       scrollController: controller,
//       children: [
//         Text('Theme mode', style: FluentTheme.of(context).typography.subtitle),
//         spacer,
//         biggerSpacer,
//         Text(
//           'Navigation Pane Display Mode',
//           style: FluentTheme.of(context).typography.subtitle,
//         ),
//         spacer,
//         biggerSpacer,
//         Text('Navigation Indicator',
//             style: FluentTheme.of(context).typography.subtitle),
//         spacer,
//         biggerSpacer,
//         Text('Accent Color',
//             style: FluentTheme.of(context).typography.subtitle),
//         spacer
//       ],
//     );
//   }
// }
