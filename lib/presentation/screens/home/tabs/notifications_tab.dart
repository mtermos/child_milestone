import 'package:child_milestone/constants/classes.dart';
import 'package:child_milestone/logic/blocs/notification/notification_bloc.dart';
import 'package:child_milestone/presentation/common_widgets/app_text.dart';
import 'package:child_milestone/presentation/common_widgets/column_with_seprator.dart';
import 'package:child_milestone/presentation/styles/colors.dart';
import 'package:child_milestone/presentation/widgets/notification_item_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:responsive_framework/responsive_framework.dart';

class NotificationTab extends StatefulWidget {
  const NotificationTab({Key? key}) : super(key: key);

  @override
  _NotificationState createState() => _NotificationState();
}

class _NotificationState extends State<NotificationTab> {
  List<NotificationWithChildAndMilestone> notificationsItems = [];

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    final isMOBILE = ResponsiveWrapper.of(context).isSmallerThan(TABLET);
    final textScale = isMOBILE
        ? MediaQuery.of(context).size.height * 0.001
        : MediaQuery.of(context).size.height * 0.0011;
    BlocProvider.of<NotificationBloc>(context)
        .add(GetAllUnopenedNotificationsEvent());

    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            SizedBox(height: size.height * 0.02),
            Container(
              alignment: AlignmentDirectional.topStart,
              padding: EdgeInsets.only(
                  left: size.width * 0.05, right: size.width * 0.05),
              child: AppText(
                text: AppLocalizations.of(context)!.notifications,
                fontSize: textScale * 24,
                textAlign: TextAlign.start,
              ),
            ),
            SizedBox(height: size.height * 0.02),
            BlocBuilder<NotificationBloc, NotificationState>(
              builder: (context, state) {
                if (state is AllUnopenedNotificationsLoadedState) {
                  notificationsItems = state.notificationsWihChildren;
                }
                if (notificationsItems.isEmpty) {
                  return Column(
                    children: [
                      SizedBox(height: size.height * 0.2),
                      Center(
                        child: AppText(
                          text: "لا يوجد إشعارات",
                          fontSize: textScale * 40,
                          color: AppColors.primaryColor,
                        ),
                      ),
                    ],
                  );
                }
                return Column(
                  children: getChildrenWithSeperator(
                    addToFirstChild: false,
                    widgets: notificationsItems.map((e) {
                      return Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: size.width * 0.035,
                        ),
                        width: double.maxFinite,
                        child: NotificationItemWidget(item: e),
                      );
                    }).toList(),
                    seperator: const Divider(
                      thickness: 1,
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
