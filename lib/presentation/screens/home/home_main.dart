import 'package:child_milestone/constants/strings.dart';
import 'package:child_milestone/presentation/screens/home/bottom_bar_view.dart';
import 'package:child_milestone/presentation/screens/home/tabIcon_data.dart';
import 'package:child_milestone/presentation/screens/home/tabs/appRate_tab.dart';
import 'package:child_milestone/presentation/screens/home/tabs/home_tab.dart';
import 'package:child_milestone/presentation/screens/home/tabs/notifications_tab.dart';
import 'package:child_milestone/presentation/screens/home/tabs/tips_tab.dart';
import 'package:child_milestone/presentation/components/top_bar_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../logic/cubits/internet_connectivity/internet_cubit.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  AnimationController? animationController;

  List<TabIconData> tabIconsList = TabIconData.tabIconsList;

  Widget tabBody = Container(
    color: Colors.white,
  );

  @override
  void initState() {
    for (var tab in tabIconsList) {
      tab.isSelected = false;
    }
    tabIconsList[0].isSelected = true;

    animationController = AnimationController(
        duration: const Duration(milliseconds: 600), vsync: this);
    tabBody = HomeTab(changeIndex: changeIndex);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      color: Colors.white,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            SizedBox(
              height: MediaQuery.of(context).padding.top,
            ),
            TopBarView(),
            Expanded(child: tabBody),
            bottomBar(),
            SizedBox(width: size.width * 0.12)
          ],
        ),
      ),
    );
  }

  void changeIndex(int index) {
    if (index == 0) {
      animationController?.reverse().then<dynamic>((data) {
        if (!mounted) {
          return;
        }
        setState(() {
          tabIconsList[0].isSelected = true;
          tabIconsList[1].isSelected = false;
          tabIconsList[2].isSelected = false;
          tabIconsList[3].isSelected = false;
          tabBody = HomeTab(changeIndex: changeIndex);
        });
      });
    } else if (index == 1) {
      animationController?.reverse().then<dynamic>((data) {
        if (!mounted) {
          return;
        }
        setState(() {
          tabIconsList[0].isSelected = false;
          tabIconsList[1].isSelected = true;
          tabIconsList[2].isSelected = false;
          tabIconsList[3].isSelected = false;
          tabBody = const NotificationTab();
        });
      });
    } else if (index == 2) {
      animationController?.reverse().then<dynamic>((data) {
        if (!mounted) {
          return;
        }
        setState(() {
          tabIconsList[0].isSelected = false;
          tabIconsList[1].isSelected = false;
          tabIconsList[2].isSelected = true;
          tabIconsList[3].isSelected = false;
          tabBody = const TipsTab();
        });
      });
    } else if (index == 3) {
      animationController?.reverse().then<dynamic>((data) {
        if (!mounted) {
          return;
        }
        setState(() {
          tabIconsList[0].isSelected = false;
          tabIconsList[1].isSelected = false;
          tabIconsList[2].isSelected = false;
          tabIconsList[3].isSelected = true;
          tabBody = const AppRateTab();
        });
      });
    }
  }

  Widget bottomBar() {
    return BottomBarView(
      tabIconsList: tabIconsList,
      addClick: () {
        Navigator.pushNamed(context, Routes.addChild);
      },
      changeIndex: changeIndex,
    );
  }

  // _logout() {
  //   return BlocBuilder<AuthBloc, AuthState>(condition: (previousState, state) {
  //     if (state is UnlogedState) {
  //       Navigator.pushReplacement(context, FadeRoute(page: LoginScreen()));
  //     }
  //     return;
  //   }, builder: (context, state) {
  //     if (state is LoadingLogoutState) {
  //       return SizedBox(
  //         child: SpinKitWave(
  //           color: Colors.white,
  //         ),
  //       );
  //     }
  //     return Center(
  //       child: InkWell(
  //         onTap: () => BlocProvider.of<AuthBloc>(context).add(LogoutEvent()),
  //         child: Text(
  //           "Logout",
  //           style: TextStyle(
  //               fontSize: 26,
  //               decoration: TextDecoration.underline,
  //               color: Colors.white),
  //         ),
  //       ),
  //     );
  //   });
  // }
}
