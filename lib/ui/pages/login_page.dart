import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:service_route/data/data.dart';
import 'package:service_route/domain/domain.dart';
import 'package:service_route/infrastructure/infrastructure.dart';
import 'package:service_route/ui/ui.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  _LoginPageState()
      : navigator = AppService.get<AppNavigator>(),
        logger = AppService.get<Logger>(),
        authRepository = AppService.get<IAuthenticationRepository>(),
        appContext = AppService.get<AppContext>();

  AppTheme appTheme;
  MediaQueryData mediaQuery;
  AppNavigator navigator;
  Logger logger;
  IAuthenticationRepository authRepository;
  AppContext appContext;
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    mediaQuery = context.getMediaQuery();
    appTheme = context.getTheme();
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle(
          statusBarIconBrightness: Brightness.dark,
        ),
        child: Scaffold(
            backgroundColor: appTheme.colors.canvasLight,
            body: BlocProvider<AuthenticationBloc>(
                create: (context) =>
                    AuthenticationBloc(authRepository: authRepository, appContext: appContext, logger: logger),
                child: Builder(builder: (context) {
                  return SafeArea(
                      child: ScrollConfiguration(
                    behavior: RemoveEffectScrollBehavior(),
                    child: CustomScrollView(
                      slivers: [
                        SliverFillRemaining(
                          hasScrollBody: false,
                          child: Column(
                            children: [
                              _LoginHeader(),
                              SizedBox(
                                height: 10,
                              ),
                              Expanded(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    _LoginBody(),
                                  ],
                                ),
                              ),
                              Visibility(
                                visible: !mediaQuery.keyboardVisible(),
                                child: _LoginFooter(),
                              )
                            ],
                          ),
                        )
                      ],
                    ),
                  ));
                }))));
  }
}

class _HeaderClipper extends CustomClipper<Path> {
  const _HeaderClipper({
    @required this.yLine,
    @required this.y1Bezier,
    @required this.y2bezier,
  });

  final double yLine;
  final double y1Bezier;
  final double y2bezier;
  @override
  Path getClip(Size size) {
    var path = Path()
      ..lineTo(0, yLine)
      ..quadraticBezierTo(
        size.width / 2.2,
        y1Bezier,
        size.width,
        y2bezier,
      )
      ..lineTo(size.width, 0)
      ..close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return true;
  }
}

class _LoginHeader extends StatelessWidget {
  const _LoginHeader();

  @override
  Widget build(BuildContext context) {
    var appTheme = context.getTheme();
    return Container(
      height: 180,
      child: Stack(
        children: <Widget>[
          ClipPath(
            clipper: _HeaderClipper(
              yLine: 170,
              y1Bezier: 190,
              y2bezier: 54,
            ),
            child: Container(
              color: Color(0xFFF4F5F7),
            ),
          ),
          ClipPath(
            clipper: _HeaderClipper(
              yLine: 150,
              y1Bezier: 180,
              y2bezier: 52,
            ),
            child: Container(
              color: appTheme.colors.primary,
            ),
          ),
          ClipPath(
            clipper: _HeaderClipper(
              yLine: 130,
              y1Bezier: 170,
              y2bezier: 50,
            ),
            child: Container(
              color: appTheme.colors.canvasLight,
            ),
          ),
          Align(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 30),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        'Servis Rota',
                        style: Theme.of(context)
                            .textTheme
                            .headline5
                            .copyWith(color: Colors.black, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        '            by Öz Ata Tur',
                        style: Theme.of(context).textTheme.bodyText1.copyWith(color: Colors.black.withOpacity(0.5)),
                      ),
                    ],
                  ),
                ),
                Align(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 20, bottom: 20),
                    child: Transform.rotate(
                      angle: -pi / -4,
                      child: Icon(
                        AppIcons.mapMarkerMultipleOutline,
                        color: appTheme.colors.primary,
                        size: 80,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _LoginBody extends StatefulWidget {
  @override
  _LoginBodyState createState() => _LoginBodyState();
}

class _LoginBodyState extends State<_LoginBody> {
  _LoginBodyState()
      : serviceRouteRepository = AppService.get<IServiceRouteRepository>(),
        settingsRepository = AppService.get<ISettingsRepository>(),
        appContext = AppService.get<AppContext>(),
        navigator = AppService.get<AppNavigator>();

  final tecUserName = TextEditingController();
  final tecPassword = TextEditingController();
  final fnUserName = FocusNode();
  final fnPassword = FocusNode();
  final userCredentialFormKey = GlobalKey<FormState>();

  bool isPasswordVisible = false;

  IServiceRouteRepository serviceRouteRepository;
  ISettingsRepository settingsRepository;
  AppNavigator navigator;
  AppContext appContext;
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    var appTheme = context.getTheme();
    return Form(
      key: userCredentialFormKey,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30),
        child: Column(
          children: <Widget>[
            Text(AppString.loginForm, style: appTheme.textStyles.title),
            SizedBox(height: 10),
            Divider(),
            SizedBox(height: 20),
            _LoginFormInput(
              hintText: AppString.userName,
              prefixIcon: AppIcons.account,
              focusNode: fnUserName,
              inputFormatters: [LengthLimitingTextInputFormatter(15)],
              onFieldSubmitted: (value) {
                context.getFocusScope().requestFocus(fnPassword);
              },
              textInputAction: TextInputAction.next,
              controller: tecUserName,
            ),
            _LoginFormInput(
              focusNode: fnPassword,
              hintText: AppString.password,
              prefixIcon: AppIcons.keyVariant,
              controller: tecPassword,
              textInputAction: TextInputAction.done,
              inputFormatters: [LengthLimitingTextInputFormatter(30)],
              obscureText: isPasswordVisible,
              suffixIcon: isPasswordVisible ? AppIcons.eye : AppIcons.eyeOff,
              onTabSuffixIcon: () {
                setState(() {
                  isPasswordVisible = !isPasswordVisible;
                });
              },
            ),
            Divider(),
            SizedBox(height: 10),
            BlocConsumer<AuthenticationBloc, AuthenticationState>(
              listener: (context, state) async {
                if (state is AuthenticationFail) {
                  SnackBarAlert.error(context: context, message: state.reason);
                } else if (state is AuthenticationSuccess) {
                  await onLoginSuccess();
                }
              },
              builder: (context, state) {
                return SizedBox(
                  height: 40,
                  width: double.infinity,
                  child: ProgressButton(
                    indicatorColor: Colors.white,
                    onPressed: (startProcessing, stopProcessing, isProcessing) async {
                      if (!userCredentialFormKey.currentState.validate()) {
                        return;
                      }

                      if (state is! Authenticating) {
                        try {
                          startProcessing();

                          var bloc = context.getBloc<AuthenticationBloc>();
                          await bloc.authentication(AuthenticationModel(
                            userName: tecUserName.text,
                            password: tecPassword.text,
                          ));
                          var serviceRoutes = await serviceRouteRepository.getServiceRoutes();
                          await navigator.pushAndRemoveUntilHome(context, serviceRoutes);
                        } finally {
                          stopProcessing();
                        }
                      }
                    },
                    child: Text(
                      AppString.login,
                      style: appTheme.data.textTheme.headline6.copyWith(color: appTheme.colors.fontLight),
                    ),
                  ),
                );
              },
            )
          ],
        ),
      ),
    );
  }

  Future<void> onLoginSuccess() async {
    var userSettings = UserSettings(
      userName: tecUserName.text,
    );
    await settingsRepository.saveUser(userSettings);
    appContext.setAppSettings(user: userSettings);
  }
}

class _LoginFooter extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
        height: 80,
        color: Color(0xFFF4F5F7),
        child: ClipPath(
          clipper: _HeaderClipper(
            yLine: 60,
            y1Bezier: 100,
            y2bezier: 0,
          ),
          child: Container(
            color: Colors.white,
          ),
        ));
  }
}

class _LoginFormInput extends StatelessWidget {
  _LoginFormInput(
      {this.hintText,
      this.prefixIcon,
      this.suffixIcon,
      this.onTabSuffixIcon,
      this.focusNode,
      this.controller,
      this.inputFormatters,
      this.obscureText = false,
      this.textInputAction,
      this.onFieldSubmitted});

  final String hintText;
  final IconData prefixIcon;
  final VoidCallback onTabSuffixIcon;
  final IconData suffixIcon;
  final FocusNode focusNode;
  final TextEditingController controller;
  final List<TextInputFormatter> inputFormatters;
  final TextInputAction textInputAction;
  final ValueChanged<String> onFieldSubmitted;
  final bool obscureText;

  @override
  Widget build(BuildContext context) {
    var appTheme = context.getTheme();
    //var localizer = context.getLocalizer();
    var suffixIconWidget = suffixIcon != null
        ? FieldButton(onTab: onTabSuffixIcon, iconData: suffixIcon, iconEnabledColor: Colors.white54)
        : null;
    return TextFormField(
      decoration: DenseInputDecoration(
          hintText: hintText,
          helperText: ' ',
          prefixIcon: Icon(prefixIcon, color: appTheme.colors.primary.lighten(0.2), size: 18),
          suffixIcon: suffixIconWidget),
      focusNode: focusNode,
      validator: RequiredValidator<String>(errorText: AppString.requiredField),
      inputFormatters: inputFormatters,
      textInputAction: TextInputAction.done,
      controller: controller,
      obscureText: obscureText,
      onFieldSubmitted: onFieldSubmitted,
    );
  }
}
