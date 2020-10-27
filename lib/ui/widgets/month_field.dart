import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:aff/infrastructure.dart';
import 'package:aff/ui.dart';
import 'package:service_route/infrastructure/infrastructure.dart';

class MonthField extends StatefulWidget {
  MonthField({
    Key key,
    @required this.value,
    @required this.onChanged,
    this.hintText,
    this.errorText,
    this.enable = true,
    this.onClear,
  }) : super(key: key);

  /// Callback when datetime selected [DateTime]
  final ValueChanged<DateTime> onChanged;
  final VoidCallback onClear;

  /// Selected date;
  final DateTime value;

  final String hintText;
  final String errorText;
  final bool enable;

  @override
  _MonthFieldState createState() => _MonthFieldState();
}

class _MonthFieldState extends State<MonthField> {
  AppTheme appTheme;

  @override
  void didChangeDependencies() {
    appTheme = context.getTheme();
    super.didChangeDependencies();
  }

  Future<void> showPicker(BuildContext context) async {
    DateTime _selectedDateTime;

    final DateTime _selectedDate = await showDialog<DateTime>(
        context: context,
        builder: (context) {
          return MonthPickerDialog(
            value: widget.value,
          );
        });

    if (_selectedDate != null) {
      _selectedDateTime = _selectedDate;
    }

    if (_selectedDateTime != null) {
      widget.onChanged(_selectedDateTime);
    }
  }

  @override
  Widget build(BuildContext context) {
    String text;

    if (widget.value != null) {
      text = DateFormat.yMMMM().format(widget.value);
    }

    FieldButton suffixButton;
    if (widget.onClear != null && !text.isNullOrWhiteSpace()) {
      suffixButton = FieldButton.clear(onTab: widget.onClear, enable: widget.enable);
    } else {
      suffixButton = FieldButton.calender(enable: widget.enable);
    }

    return GestureDetector(
      onTap: widget.enable ? () async => showPicker(context) : null,
      child: InputDecorator(
        decoration: DenseInputDecoration(
          contentPadding: EdgeInsets.fromLTRB(10, 10, 10, 10),
          suffixIcon: suffixButton,
          errorText: widget.errorText,
          hintText: widget.hintText,
          border: widget.enable
              ? appTheme.data.inputDecorationTheme.enabledBorder
              : appTheme.data.inputDecorationTheme.disabledBorder,
        ),
        child: Text(
          text.isNullOrWhiteSpace() ? widget.hintText ?? '' : text,
          style: appTheme.textStyles.subtitle.copyWith(
              color: text.isNullOrWhiteSpace()
                  ? appTheme.data.inputDecorationTheme.hintStyle.color
                  : appTheme.colors.font),
        ),
      ),
    );
  }
}

class MonthPickerDialog extends StatefulWidget {
  const MonthPickerDialog({Key key, this.value}) : super(key: key);

  final DateTime value;

  @override
  _MonthPickerDialogState createState() => _MonthPickerDialogState();
}

class _MonthPickerDialogState extends State<MonthPickerDialog> {
  PageController pageController;
  DateTime selectedDate;
  int currentYear;
  AppTheme appTheme;

  @override
  void initState() {
    selectedDate = widget.value ?? Clock().now();
    pageController = PageController(initialPage: selectedDate.year);
    currentYear = selectedDate.year;
    super.initState();
  }

  @override
  void didChangeDependencies() {
    appTheme = context.getTheme();
    super.didChangeDependencies();
  }

  bool isSelectedMonth(DateTime date) {
    return date.month == selectedDate.month && date.year == selectedDate.year;
  }

  bool isCurrentMonth(DateTime date) {
    return date.month == DateTime.now().month && date.year == DateTime.now().year;
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: AnimatedContainer(
          width: 330,
          height: 296,
          duration: Duration(milliseconds: 400),
          curve: Curves.easeIn,
          child: Column(children: [
            Material(
              color: appTheme.colors.primary,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text('${DateFormat.y().format(DateTime(currentYear))}',
                            style: appTheme.textStyles.title.copyWith(color: appTheme.colors.fontLight)),
                        Row(
                          children: <Widget>[
                            IconButton(
                              icon: Icon(Icons.keyboard_arrow_up, color: appTheme.colors.fontLight),
                              onPressed: () => movePage(-1),
                            ),
                            IconButton(
                              icon: Icon(Icons.keyboard_arrow_down, color: appTheme.colors.fontLight),
                              onPressed: () => movePage(1),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            Container(
              color: Colors.white,
              height: 200,
              child: Theme(
                  data: Theme.of(context).copyWith(
                      buttonTheme: ButtonThemeData(padding: EdgeInsets.all(0), shape: CircleBorder(), minWidth: 1)),
                  child: PageView.builder(
                    controller: pageController,
                    scrollDirection: Axis.vertical,
                    onPageChanged: (index) {
                      setState(() {
                        currentYear = index;
                      });
                    },
                    itemBuilder: (context, year) {
                      return GridView.count(
                        padding: EdgeInsets.all(12),
                        physics: NeverScrollableScrollPhysics(),
                        crossAxisCount: 5,
                        children: List<int>.generate(12, (i) => i + 1)
                            .map((month) => DateTime(year, month))
                            .map(
                              (date) => Padding(
                                padding: EdgeInsets.all(4),
                                child: FlatButton(
                                  onPressed: () => setState(() {
                                    selectedDate = DateTime(date.year, date.month);
                                    Navigator.pop(context, selectedDate);
                                  }),
                                  color: isSelectedMonth(date) ? appTheme.colors.primary.withOpacity(0.1) : null,
                                  textColor: isSelectedMonth(date)
                                      ? appTheme.colors.primary
                                      : isCurrentMonth(date)
                                          ? appTheme.colors.primary
                                          : null,
                                  child: Text(
                                    DateFormat.MMM().format(date),
                                  ),
                                ),
                              ),
                            )
                            .toList(),
                      );
                    },
                  )),
            )
          ])),
    );
  }

  void movePage(int direction) {
    pageController.animateToPage(currentYear + direction,
        duration: Duration(milliseconds: 400), curve: Curves.easeInOut);
  }
}
