// // ignore_for_file: public_member_api_docs, sort_constructors_first
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';

// import 'package:real_estate_estimator/constants/enums.dart';

// class HouseTypeField extends StatefulWidget {
//   Function callback;
//   HouseTypeField({
//     Key? key,
//     required this.callback,
//   }) : super(key: key);

//   @override
//   State<HouseTypeField> createState() => _HouseTypeFieldState();
// }

// class _HouseTypeFieldState extends State<HouseTypeField> {
//   List<bool> _isSelected = [false, false, false];
//   List<String> stringList = [
//     HomeType.Apartment.name,
//     HomeType.House.name,
//     HomeType.Land.name
//   ];

//   @override
//   Widget build(BuildContext context) {
//     return Material(
//       color: Colors.transparent,
//       child: GridView.count(
//         shrinkWrap: true,
//         physics: NeverScrollableScrollPhysics(),
//         crossAxisCount: 3, //set the number of buttons in a row
//         crossAxisSpacing: 8, //set the spacing between the buttons
//         childAspectRatio: 2, //set the width-to-height ratio of the button,
//         //>1 is a horizontal rectangle
//         children: List.generate(_isSelected.length, (index) {
//           return TextButton(
//             style: ButtonStyle(
//               shape: MaterialStateProperty.all<RoundedRectangleBorder>(
//                 RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(35),
//                     side: BorderSide(color: Colors.black)),
//               ),
//               fixedSize: MaterialStateProperty.all(Size(50, 25)),
//               backgroundColor: MaterialStateProperty.all(
//                 _isSelected[index] ? Color(0xffD6EAF8) : Colors.transparent,
//               ),
//             ),
//             child: Center(
//               child: Text(
//                 stringList[index],
//                 style: TextStyle(color: Colors.white),
//               ),
//             ),
//             onPressed: () {
//               setState(() {
//                 for (int indexBtn = 0;
//                     indexBtn < _isSelected.length;
//                     indexBtn++) {
//                   if (indexBtn == index) {
//                     _isSelected[indexBtn] = true;
//                   } else {
//                     _isSelected[indexBtn] = false;
//                   }
//                 }
//               });
//               widget.callback(HomeType.values[index]);
//             },
//           );
//         }),
//       ),
//     );
//     // return Material(
//     //   color: Colors.transparent,
//     //   child: ToggleButtons(
//     //     // borderRadius: BorderRadius.all(Radius.circular(20)),
//     //     renderBorder: false,
//     //     constraints: BoxConstraints.tightFor(),
//     //     // tapTargetSize: MaterialTapTargetSize.shrinkWrap,
//     //     children: <Widget>[
//     //       Container(
//     //         child: Text(HomeType.Apartment.name),
//     //         padding: const EdgeInsets.all(8.0),
//     //         decoration: BoxDecoration(
//     //             border: Border.all(color: Colors.blueAccent),
//     //             borderRadius: BorderRadius.all(Radius.circular(20))),
//     //       ),
//     //       Container(
//     //         child: Text(HomeType.House.name),
//     //         padding: const EdgeInsets.all(8.0),
//     //         decoration: BoxDecoration(
//     //             border: Border.all(color: Colors.blueAccent),
//     //             borderRadius: BorderRadius.all(Radius.circular(20))),
//     //       ),
//     //       Container(
//     //         child: Text(HomeType.Land.name),
//     //         padding: const EdgeInsets.all(8.0),
//     //       ),
//     //     ],
//     //     onPressed: (int index) {
//     //       setState(() {
//     //         _isSelected =
//     //             List.filled(_isSelected.length, false, growable: true);
//     //         _isSelected[index] = true;
//     //       });
//     //       widget.callback(HomeType.values[index]);
//     //       print(_isSelected);
//     //     },
//     //     isSelected: _isSelected,
//     //   ),
//     // );
//   }
// }
