
import 'package:flutter/material.dart';
import 'package:service_route/data/data.dart';
import 'package:service_route/infrastructure/infrastructure.dart';
import 'package:service_route/ui/ui.dart';
 

class ThemeTestPage extends StatefulWidget {
  @override
  _ThemeTestPageState createState() => _ThemeTestPageState();
}

class _ThemeTestPageState extends State<ThemeTestPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  AppTheme appTheme;
  DateTime selectedDate;
  TimeOfDay selectedTime;
  String selectedDropDownValue;
  CodeDescription selectedSearchDropDownValue;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    appTheme = context.getTheme();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
            title: Text('Theme Test View'),
            bottom: TabBar(
              tabs: [
                Tab(icon: Icon(AppIcons.earth), text: 'Tab 1'),
                Tab(icon: Icon(AppIcons.earth), text: 'Tab 2'),
                Tab(icon: Icon(AppIcons.earth), text: 'Tab 3'),
              ],
            )),
        body: ContentContainer(
          child: Builder(
              builder: (context) => SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        SizedBox(
                          height: 5,
                        ),
                        _buildImageNetwork(),
                        _buildButtonRow(),
                        _buildIconButtonRow(),
                        _buildChipRow(),
                        _buildChoiceChipRow(),
                        _buildCheckboxRow(),
                        _buildToggleButtonsRow(),
                        _buildTextInput(),
                        // _buildTabRow(context),
                        _buildBottomNavigation(),
                        _buildCard(),

                        _buildText(context),
                        Divider(
                          thickness: 3,
                        ),
                        _buildDialogMessages(),
                        Divider(
                          thickness: 3,
                        ),
                        _buildSheetMessages(),
                        Divider(
                          thickness: 3,
                        ),
                        _buildSnackBardMessages(context),
                        Divider(
                          thickness: 3,
                        ),
                        _buildNumberInputDialog(),
                        Divider(
                          thickness: 3,
                        ),
                        _buildTextInputDialog(),
                        Divider(
                          thickness: 3,
                        ),
                        _buildWaitDialog(),
                        Divider(
                          thickness: 3,
                        ),
                        _buildLogButton(),
                      ],
                    ),
                  )),
        ),
      ),
    );
  }

  /* Widget _buildTabRow(context) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: Container(
        child: TabBar(
          tabs: <Widget>[
            Tab(
              text: 'Tab 1',
              icon: Icon(AppIcons.accessibility),
            ),
            Tab(
              text: 'Tab 2',
              icon: Icon(AppIcons.accessibility),
            ),
            Tab(
              text: 'Tab 3',
              icon: Icon(AppIcons.accessibility),
            ),
          ],
        ),
      ),
    );
  }*/

  Row _buildCheckboxRow() {
    return Row(
      children: <Widget>[
        Checkbox(
          value: true,
          onChanged: (value) {},
        ),
        Checkbox(
          value: false,
          onChanged: (value) {},
        ),
        Checkbox(
          value: false,
          onChanged: null,
        ),
        Radio(
          value: true,
          groupValue: true,
          onChanged: (bool value) {},
        ),
        Radio(
          value: false,
          onChanged: (bool value) {},
          groupValue: null,
        ),
        Radio(
          value: false,
          onChanged: null,
          groupValue: null,
        ),
      ],
    );
  }

  Row _buildChoiceChipRow() {
    return Row(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.all(8),
          child: ChoiceChip(
            label: Text('Selected Chip'),
            selected: true,
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8),
          child: ChoiceChip(
            label: Text('Not Selected Chip'),
            selected: false,
          ),
        ),
      ],
    );
  }

  Row _buildChipRow() {
    return Row(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.all(8),
          child: Chip(
            label: Text('Chip'),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8),
          child: Chip(
            label: Text('Avatar Chip'),
            avatar: FlutterLogo(),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8),
          child: InputChip(
            label: Text('Input Chip'),
          ),
        ),
      ],
    );
  }

  List<bool> isSelected = <bool>[false, false, true];
  Row _buildToggleButtonsRow() {
    return Row(
      children: <Widget>[
        ToggleButtons(
          onPressed: (int index) {
            setState(() {
              isSelected[index] = !isSelected[index];
            });
          },
          isSelected: isSelected,
          children: <Widget>[
            Icon(Icons.ac_unit),
            Icon(Icons.call),
            Icon(Icons.cake),
          ],
        ),
      ],
    );
  }

  Row _buildIconButtonRow() {
    return Row(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.all(8),
          child: FloatingActionButton(
            onPressed: () {},
            child: Icon(AppIcons.human),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8),
          child: IconButton(
            icon: Icon(AppIcons.human),
            onPressed: () {},
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8),
          child: CircleAvatar(
            child: Text('AV'),
          ),
        )
      ],
    );
  }

  Row _buildButtonRow() {
    return Row(
      mainAxisSize: MainAxisSize.max,
      children: <Widget>[
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: ElevatedButton(
              onPressed: () {},
              child: Text('Raised'),
            ),
          ),
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: TextButton(
              onPressed: () {},
              child: Text('Flat'),
            ),
          ),
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: Badge(
              badgeContent: Text(
                '!',
                style: TextStyle(color: Colors.white),
              ),
              position: BadgePosition.topStart(start: 10, top: 0),
              child: OutlinedButton(
                style: OutlinedButton.styleFrom(onSurface: Colors.red),
                onPressed: () {},
                child: Text('OutLine'),
              ),
            ),
          ),
        )
      ],
    );
  }

  Widget _buildBottomNavigation() {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: BottomNavigationBar(
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(AppIcons.human),
            label: 'Item 1',
          ),
          BottomNavigationBarItem(
            icon: Icon(AppIcons.human),
            label: 'Item 2',
          ),
          BottomNavigationBarItem(
            icon: Icon(AppIcons.human),
            label: 'Item 3',
          ),
        ],
      ),
    );
  }

  Widget _buildCard() {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: Card(
        child: Container(
          height: 100,
          child: Center(
            child: Text('Material Card'),
          ),
        ),
      ),
    );
  }

  Widget _buildTextInput() {
    return Column(
      children: <Widget>[
        Padding(
          padding: EdgeInsets.all(8),
          child: TextField(
            key: Key('TextField2'),
            decoration: InputDecoration(
              hintText: 'A TextField',
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.all(8),
          child: TextField(
            key: Key('TextField2'),
            decoration: InputDecoration(
              errorText: 'Error Messages',
              hintText: 'Has Error TextField',
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.all(8),
          child: TextField(
            enabled: false,
            key: Key('TextField2'),
            decoration: InputDecoration(
              hintText: 'Disable TextField',
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.all(8),
          child: TimeField(
            hintText: 'Select Time',
            value: TimeOfDay.fromDateTime(Clock().now()),
            onChanged: (TimeOfDay date) {
              setState(() {
                selectedTime = date;
              });
            },
          ),
        ),
        Padding(
          padding: EdgeInsets.all(8),
          child: DateField(
            hintText: 'Select Date',
            value: selectedDate,
            onChanged: (DateTime date) {
              setState(() {
                selectedDate = date;
              });
            },
          ),
        ),
        Padding(
            padding: EdgeInsets.all(8),
            child: DropdownField<String>(
                hintText: 'DropDownField',
                value: selectedDropDownValue,
                items: <DropdownMenuItem<String>>[
                  DropdownMenuItem<String>(
                    value: 'one',
                    child: Text('Item 1'),
                  ),
                  DropdownMenuItem<String>(
                    value: 'two',
                    child: Text('Item 2'),
                  ),
                  DropdownMenuItem<String>(
                    value: 'three',
                    child: Text('Item 3'),
                  ),
                ],
                onChanged: (value) {
                  setState(() {
                    selectedDropDownValue = value;
                  });
                })),
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
            ))
      ],
    );
  }

  Widget _buildText(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            'headline1',
            style: appTheme.data.textTheme.headline1,
          ),
          Text(
            'headline2',
            style: appTheme.data.textTheme.headline2,
          ),
          Text(
            'headline3',
            style: appTheme.data.textTheme.headline3,
          ),
          Text(
            'headline4',
            style: appTheme.data.textTheme.headline4,
          ),
          Text(
            'headline5',
            style: appTheme.data.textTheme.headline5,
          ),
          Text(
            '*Title',
            style: appTheme.textStyles.title,
          ),
          Text(
            '*subtitleBold ',
            style: appTheme.textStyles.subtitleBold,
          ),
          Text(
            '*subtitle',
            style: appTheme.textStyles.subtitle,
          ),
          Text(
            '*bodyBold',
            style: appTheme.textStyles.bodyBold,
          ),
          Text(
            '*body',
            style: appTheme.textStyles.body,
          ),
          Text(
            'button',
            style: appTheme.data.textTheme.button,
          ),
          Text(
            '*overline',
            style: appTheme.textStyles.overline,
          ),
          Divider(
            thickness: 3,
          ),
          Text(
            '* app genelinde kullanılan ve theme.textStyles içerisinde tanımlı olanlar.',
            style: context.getTheme().textStyles.body,
          )
        ],
      ),
    );
  }

  Widget _buildDialogMessages() {
    return Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: <Widget>[
      TextButton(
        onPressed: () {
          MessageDialog.error(
              context: context, message: 'Lorem ipsum dolor sit amet, consectetur adipiscing elit.', title: 'Error');
        },
        child: Text(
          'Show Error Message',
          style: TextStyle(color: appTheme.colors.error),
        ),
      ),
      TextButton(
        onPressed: () {
          MessageDialog.info(
              context: context, content: 'Lorem ipsum dolor sit amet, consectetur adipiscing elit.', title: 'Info');
        },
        child: Text(
          'Show Info Message',
          style: TextStyle(color: appTheme.colors.info),
        ),
      ),
      TextButton(
        onPressed: () {
          MessageDialog.warning(
              context: context, message: 'Lorem ipsum dolor sit amet, consectetur adipiscing elit. ', title: 'Warning');
        },
        child: Text(
          'Show Warning Message',
          style: TextStyle(color: appTheme.colors.warning),
        ),
      ),
      TextButton(
        onPressed: () {
          MessageDialog.message(
              context: context, message: 'Lorem ipsum dolor sit amet, consectetur adipiscing elit.', title: 'Mesaj');
        },
        child: Text(
          'Show Message Message',
          style: TextStyle(color: appTheme.colors.primary),
        ),
      )
    ]);
  }

  Widget _buildSheetMessages() {
    return Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: <Widget>[
      TextButton(
        onPressed: () {
          MessageSheet.error(
              context: context, message: 'Lorem ipsum dolor sit amet, consectetur adipiscing elit. ', title: 'Hata');
        },
        child: Text(
          'Error Sheet',
          style: TextStyle(color: appTheme.colors.error),
        ),
      ),
      TextButton(
        onPressed: () {
          MessageSheet.info(
              context: context, message: 'Lorem ipsum dolor sit amet, consectetur adipiscing elit. ', title: 'Uyarı');
        },
        child: Text(
          'Show Info Sheet',
          style: TextStyle(color: appTheme.colors.info),
        ),
      ),
      TextButton(
        onPressed: () {
          MessageSheet.warning(
              context: context, message: 'Lorem ipsum dolor sit amet, consectetur adipiscing elit. ', title: 'Uyarı');
        },
        child: Text(
          'Show Warning Sheet',
          style: TextStyle(color: appTheme.colors.warning),
        ),
      ),
      TextButton(
        onPressed: () {
          MessageSheet.question(
              context: context, message: 'Lorem ipsum dolor sit amet, consectetur adipiscing elit. ', title: 'Soru');
        },
        child: Text(
          'Show Question Sheet',
          style: TextStyle(color: appTheme.colors.primary),
        ),
      ),
      TextButton(
        onPressed: () {
          MessageSheet.message(
              context: context, message: 'Lorem ipsum dolor sit amet, consectetur adipiscing elit. ', title: 'Mesaj');
        },
        child: Text(
          'Show Message Sheet',
          style: TextStyle(color: appTheme.colors.primary),
        ),
      )
    ]);
  }

  Widget _buildSnackBardMessages(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: <Widget>[
      TextButton(
        onPressed: () {
          SnackBarAlert.error(message: 'Lorem ipsum dolor sit amet, consectetur adipiscing elit.', context: context);
        },
        child: Text(
          'Show Error Snack',
          style: TextStyle(color: appTheme.colors.error),
        ),
      ),
      TextButton(
        onPressed: () {
          SnackBarAlert.info(context: context, message: 'Lorem ipsum dolor sit amet, consectetur adipiscing elit.');
        },
        child: Text(
          'Show Info Snack',
          style: TextStyle(color: appTheme.colors.info),
        ),
      ),
      TextButton(
        onPressed: () {
          SnackBarAlert.warning(context: context, message: 'Lorem ipsum dolor sit amet, consectetur adipiscing elit. ');
        },
        child: Text(
          'Show Warning Snack',
          style: TextStyle(color: appTheme.colors.warning),
        ),
      ),
    ]);
  }

  Widget _buildWaitDialog() {
    return Center(
      child: TextButton(
        onPressed: () async {
          var wait = WaitDialog(context);
          wait.show('Please Wait ...');
          await Future<dynamic>.delayed(Duration(seconds: 2));
          wait.update('Update Please Wait ...');
          await Future<dynamic>.delayed(Duration(seconds: 2));
          wait.hide();
        },
        child: Text(
          'Show Wait Dialog',
          style: TextStyle(color: appTheme.colors.primary),
        ),
      ),
    );
  }

  Widget _buildLogButton() {
    return Center(
      child: TextButton(
        onPressed: () async {
          var logger = AppService.get<Logger>();
          logger.trace('trace Mesaj');
          logger.debug('debug Mesaj');
          logger.information('information Mesaj');
          logger.warning('warning Mesaj');
          logger.error('error Mesaj');
          logger.critical('critical Mesaj');
          await MessageDialog.info(context: context, content: 'Look at the debug console', title: 'Info');
        },
        child: Text(
          'LogDebugPrint Test',
          style: TextStyle(color: appTheme.colors.primary),
        ),
      ),
    );
  }

  Widget _buildImageNetwork() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Container(
          color: appTheme.colors.canvas,
          child: ImageNetwork(
              height: 100,
              width: 100,
              src:
                  'https://upload.wikimedia.org/wikipedia/commons/thumb/b/b6/Image_created_with_a_mobile_phone.png/220px-Image_created_with_a_mobile_phone.png'),
        ),
        Container(color: appTheme.colors.canvas, child: ImageNetwork(height: 100, width: 100, src: 'eror')),
      ],
    );
  }

  Widget _buildNumberInputDialog() {
    return Center(
      child: TextButton(
        onPressed: () async {
          await NumberInputDialog.show(context, 'Number Input Dialog', value: 1, minValue: 1);
        },
        child: Text(
          'Show Number Input Dialog',
          style: TextStyle(color: appTheme.colors.primary),
        ),
      ),
    );
  }

  Widget _buildTextInputDialog() {
    return Center(
      child: TextButton(
        onPressed: () async {
          await TextInputDialog.show(context, 'Text Input Dialog');
        },
        child: Text(
          'Show Text Input Dialog',
          style: TextStyle(color: appTheme.colors.primary),
        ),
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
    return list.where((element) => element.code.containsIgnoreCase(filter)).toList();
  }
}
