// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:child_milestone/constants/monthly_periods.dart';
import 'package:child_milestone/constants/yearly_periods.dart';
import 'package:child_milestone/logic/blocs/vaccine/vaccine_bloc.dart';
import 'package:child_milestone/logic/shared/functions.dart';
import 'package:child_milestone/presentation/screens/vaccines/vaccine_item_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'package:child_milestone/constants/classes.dart';
import 'package:child_milestone/data/models/child_model.dart';
import 'package:child_milestone/logic/cubits/current_child/current_child_cubit.dart';
import 'package:child_milestone/presentation/common_widgets/app_text.dart';
import 'package:child_milestone/presentation/components/top_bar_view.dart';
import 'package:responsive_framework/responsive_framework.dart';

class VaccineScreen extends StatefulWidget {
  final int? periodId;
  VaccineScreen({
    Key? key,
    this.periodId,
  }) : super(key: key);

  @override
  _VaccineScreenState createState() => _VaccineScreenState();
}

class _VaccineScreenState extends State<VaccineScreen> {
  ChildModel? current_child;
  List<VaccineWithDecision> items = [];
  Period? currentPeriod;
  Period? selectedPeriod;
  @override
  void initState() {
    // selectedPeriod = periodFromID(widget.periodId ?? 1);
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    final isMOBILE = ResponsiveBreakpoints.of(context).smallerThan(TABLET);
    final textScale = isMOBILE
        ? MediaQuery.of(context).size.height * 0.001
        : MediaQuery.of(context).size.height * 0.0011;

// cagtegories:
//   1: movement
//   2: perception
//   3: communication
//   4: interaction

    return Scaffold(
      body: BlocBuilder<CurrentChildCubit, CurrentChildState>(
        builder: (context, state) {
          if (state is CurrentChildChangedState) {
            current_child = state.new_current_child;
            currentPeriod = periodCalculator(current_child!);
            if (selectedPeriod == null ||
                currentPeriod!.id < selectedPeriod!.id) {
              selectedPeriod = currentPeriod;
            }

            BlocProvider.of<VaccineBloc>(context).add(
                GetVaccinesWithDecisionsByPeriodEvent(
                    child: current_child!, periodId: selectedPeriod!.id));
          }
          return Column(
            children: [
              SizedBox(
                height: MediaQuery.of(context).padding.top,
              ),
              const TopBarView(hasBackBottun: true, hasDropDown: false),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      SizedBox(height: size.height * 0.02),
                      // periodDropDownList(2, size, textScale),
                      Container(
                        alignment: AlignmentDirectional.center,
                        padding:
                            EdgeInsets.symmetric(horizontal: size.width * 0.05),
                        child: AppText(
                          text: AppLocalizations.of(context)!.vaccineChecklist,
                          fontSize: textScale * 28,
                          textAlign: TextAlign.start,
                        ),
                      ),
                      SizedBox(height: size.height * 0.02),
                      periodDropDownList(
                          currentPeriod!.id, size, textScale, isMOBILE),
                      SizedBox(height: size.height * 0.02),
                      Container(
                        alignment: AlignmentDirectional.center,
                        padding:
                            EdgeInsets.symmetric(horizontal: size.width * 0.05),
                        child: AppText(
                          text: AppLocalizations.of(context)!.vaccinePageHeader,
                          fontSize: textScale * 20,
                          textAlign: TextAlign.start,
                        ),
                      ),
                      SizedBox(height: size.height * 0.04),
                      BlocBuilder<VaccineBloc, VaccineState>(
                        builder: (context, state) {
                          if (state
                              is LoadedVaccinesWithDecisionsByPeriodState) {
                            items = state.items;
                          }
                          return Column(
                            children: items
                                .map((e) => VaccineItemWidget(
                                      item: e,
                                      selectedPeriod: selectedPeriod!,
                                      key: ValueKey(e.vaccine.id.toString()),
                                    ))
                                .toList(),
                          );
                        },
                      )
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget periodDropDownList(
      int maxPeriod, Size size, double textScale, bool isMOBILE) {
    List<Period> periods = [];
    if (maxPeriod <= 10) {
      periods = monthlyPeriods.sublist(0, maxPeriod);
    } else if (maxPeriod == 11) {
      periods.addAll(monthlyPeriods);
      periods.add(yearlyPeriods[0]);
    } else if (maxPeriod == 12) {
      periods.addAll(monthlyPeriods);
      periods.addAll(yearlyPeriods);
    }
    return Container(
      margin: const EdgeInsets.all(15.0),
      padding: EdgeInsets.symmetric(
          vertical: isMOBILE ? size.height * 0.01 : size.height * 0.015,
          horizontal: size.width * 0.04),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.blueAccent, width: textScale * 1.5),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        mainAxisAlignment:
            MainAxisAlignment.center, //Center Row contents horizontally,
        crossAxisAlignment:
            CrossAxisAlignment.center, //Center Row contents vertically,

        children: [
          AppText(
            text: AppLocalizations.of(context)!.period + ":",
            fontSize: textScale * 28,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
          Expanded(
            child: Center(
              child: DropdownButtonHideUnderline(
                child: DropdownButton<Period>(
                  selectedItemBuilder: (context) => periods.map<Widget>((e) {
                    return Center(
                      child: AppText(
                        text: e.arabicNameNumbers,
                        fontSize: textScale * 24,
                        color: Colors.black,
                      ),
                    );
                  }).toList(),
                  value: selectedPeriod,
                  borderRadius: const BorderRadius.all(Radius.circular(10)),
                  icon: const Icon(
                    Icons.arrow_drop_down,
                    color: Colors.black,
                  ),
                  // alignment: AlignmentDirectional.center,
                  hint: AppText(
                    text: AppLocalizations.of(context)!.selectPeriod,
                    fontSize: textScale * 20,
                  ),
                  isExpanded: true,
                  items: periods.map<DropdownMenuItem<Period>>((Period value) {
                    return DropdownMenuItem<Period>(
                      value: value,
                      alignment: AlignmentDirectional.center,
                      child: Row(
                        children: [
                          AppText(
                            text: value.arabicNameNumbers,
                            fontSize: textScale * 24,
                            // color: widget.light
                            //     ? Colors.white
                            //     : Colors.black,
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                  onChanged: (Period? newValue) {
                    if (newValue != null) {
                      setState(() {
                        selectedPeriod = newValue;
                      });
                    }
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
    // return Center(
    //   child: DropdownButtonHideUnderline(
    //     child: DropdownButton<Period>(
    //       selectedItemBuilder: (context) => periods.map<Widget>((e) {
    //         return Center(
    //           child: AppText(
    //             text: e.arabicName,
    //             fontSize: textScale * 24,
    //             color: Colors.black,
    //           ),
    //         );
    //       }).toList(),
    //       value: selectedPeriod,
    //       borderRadius: const BorderRadius.all(Radius.circular(10)),
    //       icon: const Icon(
    //         Icons.arrow_drop_down,
    //         color: Colors.black,
    //       ),
    //       alignment: AlignmentDirectional.center,
    //       hint: AppText(
    //         text: AppLocalizations.of(context)!.selectPeriod,
    //         fontSize: textScale * 20,
    //       ),
    //       isExpanded: true,
    //       items: periods.map<DropdownMenuItem<Period>>((Period value) {
    //         return DropdownMenuItem<Period>(
    //           value: value,
    //           alignment: AlignmentDirectional.center,
    //           child: Row(
    //             children: [
    //               AppText(
    //                 text: value.arabicName,
    //                 fontSize: textScale * 24,
    //                 // color: widget.light
    //                 //     ? Colors.white
    //                 //     : Colors.black,
    //               ),
    //             ],
    //           ),
    //         );
    //       }).toList(),
    //       onChanged: (Period? newValue) {
    //         if (newValue != null) {
    //           setState(() {
    //             selectedPeriod = newValue;
    //           });
    //         }
    //       },
    //     ),
    //   ),
    // );
  }
}
