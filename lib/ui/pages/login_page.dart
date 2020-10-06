import 'dart:math';
import 'package:flutter/material.dart';
import 'package:service_route/ui/ui.dart';
import 'package:service_route/infrastructure/infrastructure.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
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
    return Scaffold(
      backgroundColor: kWhite,
      body: SafeArea(
        child: Column(
          children: [
            Container(
              height: 300,
              child: Stack(
                children: <Widget>[
                  ClipPath(
                    clipper: HeaderClipper(
                      yLine: 200,
                      y1Bezier: 220,
                      y2bezier: 84,
                    ),
                    child: Container(
                      color: kGrey,
                    ),
                  ),
                  ClipPath(
                    clipper: HeaderClipper(
                      yLine: 180,
                      y1Bezier: 210,
                      y2bezier: 82,
                    ),
                    child: Container(
                      color: kBlue,
                    ),
                  ),
                  ClipPath(
                    clipper: HeaderClipper(
                      yLine: 160,
                      y1Bezier: 200,
                      y2bezier: 80,
                    ),
                    child: Container(
                      color: kWhite,
                    ),
                  ),
                  Header(),
                ],
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: Column(
                  children: <Widget>[
                    LoginForm(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class HeaderClipper extends CustomClipper<Path> {
  const HeaderClipper({
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

class CustomInputField extends StatelessWidget {
  const CustomInputField({
    @required this.label,
    @required this.prefixIcon,
    this.obscureText = false,
  })  : assert(label != null),
        assert(prefixIcon != null);

  final String label;
  final IconData prefixIcon;
  final bool obscureText;

  @override
  Widget build(BuildContext context) {
    return TextField(
      decoration: InputDecoration(
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: Colors.black.withOpacity(0.12),
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: Colors.black.withOpacity(0.12),
          ),
        ),
        hintText: label,
        hintStyle: TextStyle(
          color: kBlack.withOpacity(0.5),
          fontWeight: FontWeight.w500,
        ),
        prefixIcon: Icon(
          prefixIcon,
          color: kBlack.withOpacity(0.5),
        ),
      ),
      obscureText: obscureText,
    );
  }
}

class Header extends StatelessWidget {
  const Header();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Logo(
            color: kBlue,
            size: 48,
          ),
          const SizedBox(height: kSpaceM),
          Text(
            'Servis Rotası',
            style: Theme.of(context)
                .textTheme
                .headline5
                .copyWith(color: kBlack, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: kSpaceS),
          Text(
            '                      by Öz ata Tur',
            style: Theme.of(context)
                .textTheme
                .bodyText1
                .copyWith(color: kBlack.withOpacity(0.5)),
          ),
        ],
      ),
    );
  }
}

// Colors
const Color kBlue = Color(0xFF306EFF);
const Color kLightBlue = Color(0xFF4985FD);
const Color kDarkBlue = Color(0xFF1046B3);
const Color kWhite = Color(0xFFFFFFFF);
const Color kGrey = Color(0xFFF4F5F7);
const Color kBlack = Color(0xFF2D3243);

// Spacing
const double kSpaceS = 8;
const double kSpaceM = 16;

class Logo extends StatelessWidget {
  const Logo({
    @required this.color,
    @required this.size,
  })  : assert(color != null),
        assert(size != null);

  final Color color;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Transform.rotate(
      angle: -pi / 4,
      child: Icon(
        Icons.format_bold,
        color: color,
        size: size,
      ),
    );
  }
}

class LoginForm extends StatefulWidget {
  LoginForm();

  @override
  _LoginFormState createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  CodeDescription selectedSearchDropDownValue;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Column(
        children: <Widget>[
          Padding(
              padding: EdgeInsets.all(8),
              child: SearchDropdownField<CodeDescription>(
                hintText: 'SearchDropdownField',
                dialogTitle: 'DialogCaption',
                onFind: searchDropdownFind,
                onChanged: (CodeDescription data) {
                  setState(() {
                    selectedSearchDropDownValue = data;
                  });
                },
                value: selectedSearchDropDownValue,
                autofocus: true,
              )),
          CustomInputField(
            label: 'Username or Email',
            prefixIcon: Icons.person,
            obscureText: true,
          ),
          SizedBox(height: 10),
          CustomInputField(
            label: 'Password',
            prefixIcon: Icons.lock,
            obscureText: true,
          ),
          SizedBox(height: 20),
          CustomButton(
            color: kBlue,
            textColor: kWhite,
            text: 'Login to continue',
            onPressed: () {},
          ),
        ],
      ),
    );
  }

  Future<List<CodeDescription>> searchDropdownFind(String filter) async {
    List<CodeDescription> list = <CodeDescription>[];
    list.add(CodeDescription('1', 'AAAAAAAAA'));
    list.add(CodeDescription('2', 'BBBBBBBBB'));
    list.add(CodeDescription('3', 'CCCCCCCCC'));
    list.add(CodeDescription('4', 'DDDDDDDDD'));
    list.add(CodeDescription('5', 'EEEEEEEEE'));
    list.add(CodeDescription('6', 'FFFFFFFFF'));
    if (filter.isNullOrWhiteSpace()) {
      return list;
    }
    return list
        .where((element) => element.code.containsIgnoreCase(filter))
        .toList();
  }
}

class CustomButton extends StatelessWidget {
  const CustomButton({
    @required this.color,
    @required this.textColor,
    @required this.text,
    @required this.onPressed,
    this.image,
  })  : assert(color != null),
        assert(textColor != null),
        assert(text != null),
        assert(onPressed != null);
  final Color color;
  final Color textColor;
  final String text;
  final Widget image;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints(
        minWidth: double.infinity,
      ),
      child: image != null
          ? OutlineButton(
              color: color,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(4),
              ),
              onPressed: onPressed,
              child: Row(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(right: 10),
                    child: image,
                  ),
                  Text(
                    text,
                    style: Theme.of(context).textTheme.subtitle1.copyWith(
                        color: textColor, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            )
          : FlatButton(
              color: color,
              padding: const EdgeInsets.all(10),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(4),
              ),
              onPressed: onPressed,
              child: Text(
                text,
                style: Theme.of(context)
                    .textTheme
                    .subtitle1
                    .copyWith(color: textColor, fontWeight: FontWeight.bold),
              ),
            ),
    );
  }
}

class CodeDescription {
  CodeDescription(this.code, this.description) {
    code ??= '';
    description ??= '';
  }
  String code;
  String description;

  bool containsIgnoreCase(String keyword) {
    if (keyword.isNullOrEmpty()) {
      return true;
    }
    return code.containsIgnoreCase(keyword) ||
        description.containsIgnoreCase(keyword);
  }

  @override
  bool operator ==(Object other) =>
      other is CodeDescription && code.equalsIgnoreCase(other.code);

  @override
  int get hashCode => code.hashCode;

  @override
  String toString() {
    return description;
  }
}
