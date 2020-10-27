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
              color: appTheme.colors.canvas,
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
                  padding: const EdgeInsets.only(left: 25),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: <Widget>[
                      Text(
                        AppString.appName,
                        style: appTheme.data.textTheme.headline5.copyWith(fontWeight: FontWeight.bold),
                      ),
                      Text(
                        'by Özata Tur',
                        style: appTheme.data.textTheme.bodyText1.copyWith(color: appTheme.colors.fontPale),
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

  bool hidePassword = true;
  List<TransferRoute> serviceRoutes;
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
                    onPressed: (startProcessing, stopProcessing, isProcessing) async {
                      if (!userCredentialFormKey.currentState.validate()) {
                        return;
                      }

                      if (state is! Authenticating) {
                        try {
                          startProcessing();

                          var bloc = context.getBloc<AuthenticationBloc>();
                          await bloc.authentication(
                              AuthenticationModel(
                                userName: tecUserName.text,
                                password: tecPassword.text,
                              ), onSuccess: () async {
                            serviceRoutes = await serviceRouteRepository.getTransferRoutes();
                          });
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
    await navigator.pushAndRemoveUntilHome(context, serviceRoutes);
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
            onTab: onTabSuffixIcon, iconData: suffixIcon, iconEnabledColor: appTheme.colors.fontPale.lighten(0.3))
        : null;
    return TextFormField(
      decoration: DenseInputDecoration(
          hintText: hintText,
          helperText: ' ',
          prefixIcon: Icon(prefixIcon, color: appTheme.colors.primary.lighten(0.3), size: 18),
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
