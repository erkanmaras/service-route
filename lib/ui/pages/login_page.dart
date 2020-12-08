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
        serviceRouteRepository = AppService.get<IServiceRouteRepository>(),
        settingsRepository = AppService.get<ISettingsRepository>(),
        appContext = AppService.get<AppContext>();

  AppTheme appTheme;
  MediaQueryData mediaQuery;
  AppNavigator navigator;
  Logger logger;
  IServiceRouteRepository serviceRouteRepository;
  ISettingsRepository settingsRepository;
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
                create: (context) => AuthenticationBloc(
                      serviceRouteRepository: serviceRouteRepository,
                      settingsRepository: settingsRepository,
                      appContext: appContext,
                      logger: logger,
                    ),
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
                              Expanded(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    _LoginHeader(),
                                    SizedBox(
                                      height: mediaQuery.size
                                          .longestSidePercent(10),
                                    ),
                                    _LoginBody(),
                                  ],
                                ),
                              ),
                              Visibility(
                                  visible: !mediaQuery.keyboardVisible(),
                                  child: Container(
                                      height: 80,
                                      color: appTheme.colors.canvas,
                                      child: ClipPath(
                                        clipper: _HeaderClipper(
                                          yLine: 60,
                                          y1Bezier: 100,
                                          y2bezier: 0,
                                        ),
                                        child: Container(
                                          color: Colors.white,
                                        ),
                                      )))
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
    return Column(
      children: [
        Image.asset(
          AppImage.logo,
          fit: BoxFit.fitHeight,
          height: context.getMediaQuery().size.longestSidePercent(20),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 10),
          child: Text(
            AppString.appName,
            style: appTheme.data.textTheme.headline5
                .copyWith(fontWeight: FontWeight.bold),
          ),
        ),
      ],
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

  bool hidePassword = true;

  IServiceRouteRepository serviceRouteRepository;
  ISettingsRepository settingsRepository;
  AppNavigator navigator;
  AppContext appContext;

  @override
  void initState() {
    tecUserName.text = appContext.settings.user?.userName ?? '';
    super.initState();
  }

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
            Row(
              children: [
                Text(
                  AppString.loginForm,
                  style: appTheme.textStyles.bodyBold,
                  textAlign: TextAlign.start,
                ),
              ],
            ),
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
              obscureText: hidePassword,
              suffixIcon: hidePassword ? AppIcons.eye : AppIcons.eyeOff,
              onTabSuffixIcon: () {
                setState(() {
                  hidePassword = !hidePassword;
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
                    onPressed:
                        (startProcessing, stopProcessing, isProcessing) async {
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
                        } finally {
                          stopProcessing();
                        }
                      }
                    },
                    child: Text(
                      AppString.login,
                      style: appTheme.data.textTheme.headline6
                          .copyWith(color: appTheme.colors.fontLight),
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
    await navigator.pushAndRemoveUntilHome(context);
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
    var suffixIconWidget = suffixIcon != null
        ? FieldButton(
            onTab: onTabSuffixIcon,
            iconData: suffixIcon,
            iconEnabledColor: appTheme.colors.fontPale.lighten(0.3))
        : null;
    return TextFormField(
      decoration: DenseInputDecoration(
          hintText: hintText,
          helperText: ' ',
          prefixIcon: Icon(prefixIcon,
              color: appTheme.colors.primary.lighten(0.3), size: 18),
          suffixIcon: suffixIconWidget),
      focusNode: focusNode,
      validator: RequiredValidator<String>(errorText: AppString.requiredField),
      inputFormatters: inputFormatters,
      textInputAction: TextInputAction.done,
      controller: controller,
      obscureText: obscureText,
      onFieldSubmitted: onFieldSubmitted,
      enableInteractiveSelection: false,
    );
  }
}
