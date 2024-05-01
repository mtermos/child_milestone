import 'package:child_milestone/constants/strings.dart';
import 'package:child_milestone/logic/blocs/auth/auth_bloc.dart';
import 'package:child_milestone/logic/blocs/auth/auth_event.dart';
import 'package:child_milestone/logic/blocs/auth/auth_state.dart';
import 'package:child_milestone/logic/cubits/current_child/current_child_cubit.dart';
import 'package:child_milestone/presentation/common_widgets/app_button.dart';
import 'package:child_milestone/presentation/common_widgets/app_text.dart';
import 'package:child_milestone/presentation/screens/login/login_background.dart';
import 'package:child_milestone/presentation/styles/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:responsive_framework/responsive_framework.dart';

class LoginScreen extends StatefulWidget {
  LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  // final _formKey = GlobalKey<FormState>();
  final usernameController = TextEditingController();
  final passController = TextEditingController();
  var size;
  final regExp = RegExp(
      "^[a-zA-Z0-9.!#\$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)*\$");

  // _login() {
  //   if (_formKey.currentState!.validate()) {
  //     BlocProvider.of<AuthBloc>(context).add(LoginEvent(usernameController.text,passController.text));
  //   }
  // }

  String _validatorEmail(value) {
    if (!regExp.hasMatch(value)) {
      return AppLocalizations.of(context)!.invalidEmailAlert;
    }
    return "null";
  }

  // _forgotPassword() {
  //   if (regExp.hasMatch(loginController.text))
  //     Navigator.push(
  //         context,
  //         SlideDownRoute(
  //             page: ForgotPasswordScreen(
  //           email: loginController.text,
  //         )));
  //   else
  //     showDialog(
  //       context: context,
  //       builder: (context) => Alert(
  //         titleText: 'Alert',
  //         contentText:
  //             'Please type a valid Email in login field to change your password.',
  //       ),
  //     );
  // }

  // _signUp() {
  //   Navigator.push(context, SlideLeftRoute(page: SignUpScreen()));
  // }

  @override
  void initState() {
    super.initState();
    usernameController.text = '';
    passController.text = '';
    getTextFromStorage();
  }

  @override
  void dispose() {
    super.dispose();
    usernameController.dispose();
    passController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    final isMOBILE = ResponsiveBreakpoints.of(context).smallerThan(TABLET);
    final textScale = isMOBILE
        ? MediaQuery.of(context).size.height * 0.001
        : MediaQuery.of(context).size.height * 0.0011;

    return BlocConsumer<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is LoginErrorState) {
          var snackBar = SnackBar(
            content:
                Text(AppLocalizations.of(context)!.checkInternetConnection),
          );
          ScaffoldMessenger.of(context).showSnackBar(snackBar);
        }
      },
      builder: (context, state) {
        if (state is LoadingLoginState) {
          return Scaffold(
            body: SingleChildScrollView(
              child: LoginBackground(
                child: Center(
                  child: Padding(
                    padding: EdgeInsets.only(top: size.height * 0.2),
                    child: SizedBox(
                      width: isMOBILE ? size.width * 0.35 : size.width * 0.35,
                      child: const LoadingIndicator(
                        indicatorType: Indicator.circleStrokeSpin,
                        colors: [AppColors.primaryColor],
                        strokeWidth: 4,
                        backgroundColor: Colors.white,
                        pathBackgroundColor: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          );
        }
        return Scaffold(
          body: SingleChildScrollView(
            child: LoginBackground(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  SizedBox(height: size.height * 0.3),
                  Container(
                    padding:
                        EdgeInsets.symmetric(horizontal: size.width * 0.15),
                    child: loginTextWidget(textScale),
                  ),
                  SizedBox(height: size.height * 0.03),
                  Container(
                    alignment: Alignment.center,
                    margin: EdgeInsets.symmetric(horizontal: size.width * 0.15),
                    child: TextField(
                      controller: usernameController,
                      style: TextStyle(fontSize: textScale * 20),
                      decoration: InputDecoration(
                          labelStyle: TextStyle(fontSize: textScale * 20),
                          labelText: AppLocalizations.of(context)!.username),
                    ),
                  ),
                  SizedBox(height: size.height * 0.03),
                  Container(
                    alignment: Alignment.center,
                    margin: EdgeInsets.symmetric(horizontal: size.width * 0.15),
                    child: TextField(
                      style: TextStyle(fontSize: textScale * 20),
                      controller: passController,
                      decoration: InputDecoration(
                          labelStyle: TextStyle(fontSize: textScale * 20),
                          labelText: AppLocalizations.of(context)!.password),
                      obscureText: true,
                    ),
                  ),
                  // Container(
                  //   alignment: Alignment.centerRight,
                  //   margin: const EdgeInsets.symmetric(horizontal: 40, vertical: 10),
                  //   child: Text(
                  //     AppLocalizations.of(context)!.forgotPassword,
                  //     style: const TextStyle(fontSize: 12, color: Color(0XFF2661FA)),
                  //   ),
                  // ),
                  SizedBox(height: size.height * 0.05),
                  Container(
                    alignment: Alignment.centerRight,
                    margin: EdgeInsets.symmetric(
                        horizontal: size.width * 0.15,
                        vertical: size.height * 0.02),
                    child: loginButton(context, textScale),
                  ),
                  // Container(
                  //   alignment: Alignment.center,
                  //   margin: const EdgeInsets.symmetric(horizontal: 40, vertical: 10),
                  //   child: GestureDetector(
                  //     onTap: () => {
                  //       // print("register")
                  //       // Navigator.push(context, MaterialPageRoute(builder: (context) => RegisterScreen()))
                  //     },
                  //     child: Text(
                  //       AppLocalizations.of(context)!.noAccount,
                  //       style: const TextStyle(
                  //           fontSize: 12,
                  //           fontWeight: FontWeight.bold,
                  //           color: Color(0xFF2661FA)),
                  //     ),
                  //   ),
                  // )
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget loginButton(BuildContext context, double textScale) {
    Size size = MediaQuery.of(context).size;
    return AppButton(
      label: AppLocalizations.of(context)!.loginLabel,
      fontWeight: FontWeight.w600,
      fontSize: textScale * 20,
      padding: EdgeInsets.symmetric(vertical: size.height * 0.02),
      onPressed: () {
        BlocProvider.of<AuthBloc>(context).add(
          LoginEvent(AppLocalizations.of(context)!, usernameController.text,
              passController.text, () {
            BlocProvider.of<CurrentChildCubit>(context).setFirstChildCurrent(
              () {
                // Navigator.popUntil(context, (route) => false)
                Navigator.popAndPushNamed(context, Routes.home);
              },
            );
          }),
        );
      },
    );
  }

  Widget loginTextWidget(double textScale) {
    return AppText(
      text: AppLocalizations.of(context)!.loginLabel,
      fontSize: textScale * 40,
      fontWeight: FontWeight.w600,
      // color: Colors.white,
      color: const Color.fromRGBO(78, 76, 76, 1),
    );
  }

  getTextFromStorage() async {
    const storage = FlutterSecureStorage();
    usernameController.text =
        await storage.read(key: StorageKeys.username) ?? "";
    passController.text = await storage.read(key: StorageKeys.password) ?? "";
  }
}
