import 'package:child_milestone/logic/blocs/auth/auth_bloc.dart';
import 'package:child_milestone/logic/blocs/auth/auth_event.dart';
import 'package:child_milestone/presentation/common_widgets/app_button.dart';
import 'package:child_milestone/presentation/common_widgets/app_text.dart';
import 'package:child_milestone/presentation/screens/login/login_background.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'forgotPassword.dart';

class LoginScreen extends StatefulWidget {
  LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
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

    return Scaffold(
      body: LoginBackground(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SizedBox(height: size.height * 0.3),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 40),
              child: loginTextWidget(),
            ),
            SizedBox(height: size.height * 0.03),
            Container(
              alignment: Alignment.center,
              margin: const EdgeInsets.symmetric(horizontal: 40),
              child: TextField(
                controller: usernameController,
                decoration: InputDecoration(labelText: AppLocalizations.of(context)!.username),
              ),
            ),
            SizedBox(height: size.height * 0.03),
            Container(
              alignment: Alignment.center,
              margin: const EdgeInsets.symmetric(horizontal: 40),
              child: TextField(
                controller: passController,
                decoration: InputDecoration(labelText: AppLocalizations.of(context)!.password),
                obscureText: true,
              ),
            ),
            Container(
              alignment: Alignment.centerRight,
              margin: const EdgeInsets.symmetric(horizontal: 40, vertical: 10),
              child: Text(
                AppLocalizations.of(context)!.forgotPassword,
                style: TextStyle(fontSize: 12, color: Color(0XFF2661FA)),
              ),
            ),
            SizedBox(height: size.height * 0.05),
            Container(
              alignment: Alignment.centerRight,
              margin: const EdgeInsets.symmetric(horizontal: 40, vertical: 10),
              child: loginButton(context),
            ),
            Container(
              alignment: Alignment.center,
              margin: const EdgeInsets.symmetric(horizontal: 40, vertical: 10),
              child: GestureDetector(
                onTap: () => {
                  // print("register")
                  // Navigator.push(context, MaterialPageRoute(builder: (context) => RegisterScreen()))
                },
                child: Text(
                  AppLocalizations.of(context)!.noAccount,
                  style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF2661FA)),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget loginButton(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40),
      child: AppButton(
        label: AppLocalizations.of(context)!.loginLabel,
        fontWeight: FontWeight.w600,
        padding: const EdgeInsets.symmetric(vertical: 25),
        onPressed: () {
          BlocProvider.of<AuthBloc>(context).add(LoginEvent(
            usernameController.text,
            passController.text,
            () {
              Navigator.pushNamed(context, '/home');
            },
          ));
        },
      ),
    );
  }

  Widget loginTextWidget() {
    return AppText(
      text: AppLocalizations.of(context)!.loginLabel,
      fontSize: 36,
      fontWeight: FontWeight.w600,
      // color: Colors.white,
      color: Color.fromRGBO(78, 76, 76, 1),
    );
  }

  // @override
  // Widget build(BuildContext context) {
  //   size = MediaQuery.of(context).size;
  //   return Scaffold(
  //     // backgroundColor: AppColors.primaryColor,
  //     backgroundColor: Colors.white,
  //     body: Stack(
  //       children: [
  //         SvgPicture.asset(
  //           ellipse,
  //           alignment: Alignment.topCenter,
  //         ),
  //         // SvgPicture.asset(
  //         //   smile,
  //         //   alignment: Alignment.topCenter,
  //         // ),
  //         Container(
  //           margin: EdgeInsets.only(top: 60),
  //           decoration: BoxDecoration(
  //             image: DecorationImage(
  //               alignment: Alignment.topCenter,
  //               image: AssetImage(smiley_face),
  //               fit: BoxFit.scaleDown,
  //             ),
  //           ),
  //           child: Center(
  //             child: Column(
  //               mainAxisSize: MainAxisSize.max,
  //               children: [
  //                 const Spacer(),
  //                 Text("Login"),
  //                 const SizedBox(
  //                   height: 100,
  //                 ),
  //               ],
  //             ),
  //           ),
  //         ),
  //       ],
  //     ),
  //   );
  // }
  //   // return Scaffold(
  //   //   backgroundColor: ColorsCustom.loginScreenUp,
  //   //   body: Column(
  //   //     children: <Widget>[
  //   //       SizedBox(height: size.height * 0.0671),
  //   //       Container(
  //   //           height: size.height * 0.178,
  //   //           width: size.width * 0.316,
  //   //           child: Image.asset(
  //   //             'lib/assets/images/pebal.png',
  //   //             fit: BoxFit.contain,
  //   //           )),
  //   //       SizedBox(height: size.height * 0.085),
  //   //       Expanded(
  //   //         child: _formLogin(),
  //   //       ),
  //   //     ],
  //   //   ),
  //   // );
  // }

  // Widget _formLogin() {
  //   return BlocBuilder<BlocAuth, AuthState>(condition: (previousState, state) {
  //     if (state is LogedState) {
  //       Navigator.push(
  //           context, MaterialPageRoute(builder: (context) => HomeScreen()));
  //     }
  //     return;
  //   }, builder: (context, state) {
  //     if (state is ForcingLoginState) {
  //       return SizedBox(
  //         child: SpinKitWave(
  //           color: Colors.white,
  //         ),
  //       );
  //     } else {
  //       return Form(
  //         key: _formKey,
  //         child: Container(
  //           padding: EdgeInsets.symmetric(horizontal: 20),
  //           child: SingleChildScrollView(
  //             child: Column(
  //               children: <Widget>[
  //                 SizedBox(height: 20),
  //                 InputLogin(
  //                   validator: _validatorEmail,
  //                   prefixIcon: Icons.account_circle,
  //                   hint: 'Email',
  //                   keyboardType: TextInputType.emailAddress,
  //                   textEditingController: loginController,
  //                 ),
  //                 SizedBox(height: size.height * 0.03),
  //                 InputLogin(
  //                   prefixIcon: Icons.lock,
  //                   hint: 'Password',
  //                   obscureText: true,
  //                   textEditingController: passController,
  //                 ),
  //                 SizedBox(height: size.height * 0.035),
  //                 _buttonLogin(),
  //                 SizedBox(height: size.height * 0.01),
  //                 InkWell(
  //                   onTap: () => _forgotPassword(),
  //                   child: Text(
  //                     'Forgot Password?',
  //                     textAlign: TextAlign.center,
  //                     style: TextStylesLogin.textLink,
  //                   ),
  //                 ),
  //                 Padding(
  //                   padding:
  //                       EdgeInsets.symmetric(horizontal: size.height * 0.084),
  //                   child: Divider(
  //                     height: size.height * 0.14,
  //                     color: Colors.white,
  //                   ),
  //                 ),
  //                 InkWell(
  //                   onTap: () => _signUp(),
  //                   child: Text(
  //                     'SIGN UP with your email',
  //                     textAlign: TextAlign.right,
  //                     style: TextStylesLogin.textLink,
  //                   ),
  //                 ),
  //               ],
  //             ),
  //           ),
  //         ),
  //       );
  //     }
  //   });
  // }

  // Widget _buttonLogin() {
  //   return BlocBuilder<BlocAuth, AuthState>(
  //     builder: (context, state) {
  //       if (state is LoadingLoginState) {
  //         return ButtonLogin(
  //           isLoading: true,
  //           backgroundColor: Colors.white,
  //           label: 'LOGIN ...',
  //           mOnPressed: () => {},
  //         );
  //       } else if (state is LogedState) {
  //         return ButtonLogin(
  //           backgroundColor: Colors.white,
  //           label: 'CONECTED!',
  //           mOnPressed: () => {},
  //         );
  //       } else {
  //         return ButtonLogin(
  //           backgroundColor: Colors.white,
  //           label: 'SIGN IN',
  //           mOnPressed: () => _login(),
  //         );
  //       }
  //     },
  //   );
  // }

}
