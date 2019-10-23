import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart' show timeDilation;
import 'package:flutter/services.dart';
import 'package:flutter_provider_architecture/model/auth.dart';
import 'package:flutter_provider_architecture/provider_architecture/ui/base/base_model.dart';
import 'package:flutter_provider_architecture/provider_architecture/ui/base/base_view.dart';
import 'package:flutter_provider_architecture/provider_architecture/ui/user/login/LoginViewModel.dart';
import 'package:flutter_provider_architecture/provider_architecture/ui/widgets/animation/login_animation.dart';
import 'package:flutter_provider_architecture/utils/Utils.dart';
import 'package:flutter_provider_architecture/utils/theme.dart';
import 'package:wave/config.dart';
import 'package:wave/wave.dart';

class LoginView extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => LoginViewState();
}

class LoginViewState extends State<LoginView> with TickerProviderStateMixin {
  final Map<String, dynamic> _formData = {
    'email': null,
    'password': null,
    'confirm_password': null,
    'acceptTerms': true
  };
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _passwordTextController = TextEditingController();
  AuthMode authMode = AuthMode.Login;

  AnimationController _loginButtonController;
  var animationStatus = 0;

  @override
  void initState() {
    super.initState();
    _loginButtonController = new AnimationController(
        duration: new Duration(milliseconds: 3000), vsync: this);
  }

  @override
  void dispose() {
    _loginButtonController.dispose();
    super.dispose();
  }

  Future<Null> _playAnimation() async {
    try {
      await _loginButtonController.forward();
    } on TickerCanceled {}
  }

  Future<Null> _stopAnimation() async {
    try {
      await _loginButtonController.reverse();
    } on TickerCanceled {}
  }

  Widget _buildEmailTextField() {
    return TextFormField(
      keyboardType: TextInputType.emailAddress,
      validator: (value) {
        if (value.isEmpty ||
            !RegExp(r"[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&'*+/=?^_`{|}~-]+)*@(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?")
                .hasMatch(value)) {
          return 'Please enter a valid email';
        }
        return null;
      },
      onSaved: (String value) {
        _formData['email'] = value;
      },
      decoration: InputDecoration(
          prefixIcon: Icon(
            Icons.person,
            color: Colors.black26,
          ),
          suffixIcon: Icon(
            Icons.check_circle,
            color: Colors.black26,
          ),
          hintText: "Email",
          hintStyle: TextStyle(color: Colors.black26),
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderSide: BorderSide.none,
            borderRadius: BorderRadius.all(Radius.circular(40.0)),
          ),
          contentPadding:
              EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0)),
    );
  }

  Widget _buildPasswordTextField() {
    return TextFormField(
      obscureText: true,
      controller: _passwordTextController,
      validator: (String value) {
        if (value.isEmpty || value.length < 6) {
          return 'Password invalid';
        }
        return null;
      },
      onSaved: (String value) {
        _formData['password'] = value;
      },
      decoration: InputDecoration(
          prefixIcon: Icon(
            Icons.lock,
            color: Colors.black26,
          ),
          hintText: "Password",
          hintStyle: TextStyle(
            color: Colors.black26,
          ),
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderSide: BorderSide.none,
            borderRadius: BorderRadius.all(Radius.circular(40.0)),
          ),
          contentPadding:
              EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0)),
    );
  }

  Widget _buildPasswordConfirmTextField() {
    return TextFormField(
      obscureText: true,
      validator: (value) {
        if (_passwordTextController.text != value) {
          return 'Passwords do not match';
        }
        return null;
      },
      onSaved: (String value) {
        _formData['confirm_password'] = value;
      },
      decoration: InputDecoration(
          prefixIcon: Icon(
            Icons.lock,
            color: Colors.black26,
          ),
          hintText: "Confirm password",
          hintStyle: TextStyle(
            color: Colors.black26,
          ),
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderSide: BorderSide.none,
            borderRadius: BorderRadius.all(Radius.circular(40.0)),
          ),
          contentPadding:
              EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0)),
    );
  }

  void showMessage(LoginViewModel model) {
    try {
      Future.delayed(const Duration(milliseconds: 500), () {
        if (model.shouldShowMessage) {
          model.messageIsShown();
          Utils.showMessage(model.message);
        }
      });
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    timeDilation = 0.4;
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light);

    return BaseView<LoginViewModel>(
      onModelReady: (model) => LoginViewModel(),
      builder: (ctx, model, child) {
        showMessage(model);
        return Scaffold(
          body: Stack(
            alignment: AlignmentDirectional.center,
            children: <Widget>[
              Container(
                height: 600,
                child: RotatedBox(
                  quarterTurns: 2,
                  child: WaveWidget(
                    config: CustomConfig(
                      gradients: [
                        [
                          AppTheme.accentColor,
                          AppTheme.accentColorShade[200],
                        ],
                        [
                          AppTheme.primaryColor,
                          AppTheme.primaryColorShade[200],
                        ],
                      ],
                      durations: [19440, 10800],
                      heightPercentages: [0.20, 0.25],
                      blur: MaskFilter.blur(BlurStyle.solid, 10),
                      gradientBegin: Alignment.bottomLeft,
                      gradientEnd: Alignment.topRight,
                    ),
                    waveAmplitude: 0,
                    size: Size(
                      double.infinity,
                      double.infinity,
                    ),
                  ),
                ),
              ),
              Form(
                key: _formKey,
                child: ListView(
                  children: <Widget>[
                    Container(
                      margin: EdgeInsets.only(top: 30),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Text(
                              authMode == AuthMode.Login
                                  ? 'Login'
                                  : 'Create an account',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  color: Colors.white70,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 28.0)),
                          Card(
                            margin:
                                EdgeInsets.only(left: 30, right: 30, top: 30),
                            elevation: 11,
                            shape: RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(40))),
                            child: _buildEmailTextField(),
                          ),
                          Card(
                            margin:
                                EdgeInsets.only(left: 30, right: 30, top: 20),
                            elevation: 11,
                            shape: RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(40))),
                            child: _buildPasswordTextField(),
                          ),
                          authMode == AuthMode.Signup
                              ? Card(
                                  margin: EdgeInsets.only(
                                      left: 30, right: 30, top: 20),
                                  elevation: 11,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(40))),
                                  child: _buildPasswordConfirmTextField(),
                                )
                              : Container(),
                          StaggerAnimation(
                            titleButton: authMode == AuthMode.Login
                                ? 'Login'
                                : 'Register',
                            buttonController: _loginButtonController.view,
                            onTap: () {
                              if (model.state != ViewState.Busy) {
                                model.loginUser(
                                  _formData,
                                  _playAnimation,
                                  _stopAnimation,
                                  _formKey,
                                  authMode,
                                );
                              }
                            },
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: authMode == AuthMode.Login ? 121 : 50,
                    ),
                    Column(
                      children: <Widget>[
                        Text("or, connect with"),
                        SizedBox(
                          height: 20.0,
                        ),
                        Row(
                          children: <Widget>[
                            SizedBox(
                              width: 20.0,
                            ),
                            Expanded(
                              child: RaisedButton(
                                child: Text("Facebook"),
                                textColor: Colors.white,
                                color: Colors.blueAccent,
                                shape: RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(40)),
                                ),
                                onPressed: () {
                                  // model.customProgressDialog
                                  //     .showProgressDialog(context);
                                  if (model.state != ViewState.Busy) {
                                    model.loginWithFacebook(
                                        context,
                                        new FirebaseAnalytics(),
                                        _playAnimation,
                                        _stopAnimation);
                                  }
                                },
                              ),
                            ),
                            SizedBox(
                              width: 10.0,
                            ),
                            Expanded(
                              child: RaisedButton(
                                child: Text("Google"),
                                textColor: Colors.white,
                                color: Colors.red,
                                shape: RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(40)),
                                ),
                                onPressed: () {
                                  // model.customProgressDialog
                                  //     .showProgressDialog(context);
                                  if (model.state != ViewState.Busy) {
                                    model.loginViaGoogle(
                                        context,
                                        new FirebaseAnalytics(),
                                        _playAnimation,
                                        _stopAnimation);
                                  }
                                },
                              ),
                            ),
                            SizedBox(
                              width: 20.0,
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Text(authMode == AuthMode.Login
                                ? "Don't have an account"
                                : 'Already have an account'),
                            FlatButton(
                              child: Text(authMode == AuthMode.Login
                                  ? 'Register'
                                  : 'Login'),
                              textColor: AppTheme.accentColor,
                              onPressed: () {
                                setState(() {
                                  authMode = authMode == AuthMode.Login
                                      ? AuthMode.Signup
                                      : AuthMode.Login;
                                });
                              },
                            ),
                          ],
                        )
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
