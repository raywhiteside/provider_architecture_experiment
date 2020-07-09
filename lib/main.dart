import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:state_notifier/state_notifier.dart';
import 'package:flutter_state_notifier/flutter_state_notifier.dart';

//##############################################################################
// UNINTERESTING BOILERPLATE START
//##############################################################################

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

//##############################################################################
// UNINTERESTING BOILERPLATE END
//##############################################################################

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    final userSettingsProvider = StateNotifierProvider <
      UserSettingsController, UserSettings
    > (
      create: (_) => UserSettingsController(),
      builder: (context, _) {
        return StateNotifierBuilder<UserSettings> (
          stateNotifier: context.watch<UserSettingsController>(),
          builder: (_, userSettings, __) {
            print('rebuilding widget tree due to change of state');
            return PageView(model: PageModel(userSettings));
          },
        );
      },
    );

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),

      body: userSettingsProvider,
    );
  }
}

class UserSettings {
  final Map<String, String> settings;
  const UserSettings(this.settings);
}

class UserSettingsController extends StateNotifier<UserSettings> {

  static const Map<String, String> initialSettings = {
    'first_setting': 'UNINITIALIZED',
    'second_setting': 'UNINITIALIZED',
  };

  UserSettingsController() : super(UserSettings(initialSettings))
  {
    getSettings();
  }

  @override
  @protected
  set state(UserSettings newSettings) {
    super.state = newSettings;
    print('controller state updated');
  }

  getSettings() async {
    print('starting to fetch settings from backend');
    await Future.delayed(const Duration(seconds: 2));
    print('finished fetching settings from backend');
    final newSettings = {
      'first_setting': 'UPDATED_TO_INTERESTING_VALUE',
      'second_setting': 'UPDATED_TO_INTERESTING_VALUE',
    };
    state = UserSettings(newSettings);
  }

}

class PageModel {

  final UserSettings userSettings;

  const PageModel(this.userSettings);

}

class PageView extends StatelessWidget {

  final PageModel model;

  const PageView ({
    Key key,
    this.model,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text('first setting is ${model.userSettings.settings['first_setting']}');
  }

}
