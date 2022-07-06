import 'package:child_milestone/data/models/child_model.dart';
import 'package:child_milestone/logic/blocs/auth/auth_bloc.dart';
import 'package:child_milestone/logic/blocs/child/child_bloc.dart';
import 'package:child_milestone/logic/cubits/current_child/current_child_cubit.dart';
import 'package:child_milestone/presentation/screens/home/bottom_bar_view.dart';
import 'package:child_milestone/presentation/screens/home/tabIcon_data.dart';
import 'package:child_milestone/presentation/screens/home/tabs/appRate/appRate_tab.dart';
import 'package:child_milestone/presentation/screens/home/tabs/home_tab.dart';
import 'package:child_milestone/presentation/screens/home/tabs/notifications_tab.dart';
import 'package:child_milestone/presentation/screens/home/tabs/tips_tab.dart';
import 'package:child_milestone/presentation/components/top_bar_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../logic/blocs/auth/auth_state.dart';
// import 'package:flutter_bloc_login_example/bloc/auth/auth_bloc.dart';
// import 'package:flutter_bloc_login_example/bloc/auth/auth_event.dart';
// import 'package:flutter_bloc_login_example/bloc/auth/auth_state.dart';
// import 'package:flutter_bloc_login_example/screens/login/main.dart';
// import 'package:flutter_bloc_login_example/shared/colors.dart';
// import 'package:flutter_bloc_login_example/shared/screen_transitions/fade.transition.dart';
// import 'package:flutter_spinkit/flutter_spinkit.dart';

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
    tabIconsList.forEach((TabIconData tab) {
      tab.isSelected = false;
    });
    tabIconsList[0].isSelected = true;

    animationController = AnimationController(
        duration: const Duration(milliseconds: 600), vsync: this);
    tabBody = HomeTab();
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
          ],
        ),
      ),
    );
  }

  Widget bottomBar() {
    return BottomBarView(
      tabIconsList: tabIconsList,
      addClick: () {
        Navigator.pushNamed(context, '/add_child');
      },
      changeIndex: (int index) {
        if (index == 0) {
          animationController?.reverse().then<dynamic>((data) {
            if (!mounted) {
              return;
            }
            setState(() {
              tabBody = HomeTab();
            });
          });
        } else if (index == 1) {
          animationController?.reverse().then<dynamic>((data) {
            if (!mounted) {
              return;
            }
            setState(() {
              tabBody = NotificationTab();
            });
          });
        } else if (index == 2) {
          animationController?.reverse().then<dynamic>((data) {
            if (!mounted) {
              return;
            }
            setState(() {
              tabBody = TipsTab();
            });
          });
        } else if (index == 3) {
          animationController?.reverse().then<dynamic>((data) {
            if (!mounted) {
              return;
            }
            setState(() {
              tabBody = AppRateTab();
            });
          });
        }
      },
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
