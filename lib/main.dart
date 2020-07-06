import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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
    final pageView = Consumer<PageModel> (
      builder: (_, pageModel, __) =>
        PageView(model: pageModel),
    );

    final pageModelProvider = ChangeNotifierProxyProvider<UserSettings, PageModel> (
      create: (_) => PageModel(),
      update: (_, userSettings, pageModel) =>
        pageModel
          ..updateSettings(userSettings),
      child: pageView,
    );

    final userSettingsProvider = ChangeNotifierProvider<UserSettings> (
      create: (_) => UserSettings(),
      child: pageModelProvider,
    );

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),

      body: userSettingsProvider,
    );
  }
}

class UserSettings with ChangeNotifier {
  Map<String, String> settings;
  UserSettings()
  : settings = {
      'first_setting': 'UNINITIALIZED',
      'second_setting': 'UNINITIALIZED',
    }
  {
    getSettings();
  }

  UserSettings.clone(UserSettings original) {
    settings = Map.from(original.settings);
  }

  getSettings() async {
    print('starting to fetch settings from backend');
    await Future.delayed(const Duration(seconds: 2));
    print('finished fetching settings from backend');
    settings = {
      'first_setting': 'UPDATED_TO_INTERESTING_VALUE',
      'second_setting': 'UPDATED_TO_INTERESTING_VALUE',
    };
    print('notifying listeners of settings update');
    notifyListeners();
  }
}

class PageModel with ChangeNotifier {

  UserSettings userSettings;

  PageModel();

  updateSettings(UserSettings newSettings) {
    print('considering updating settings in PageModel');
    print('new settings are ${newSettings.settings}');
    if(userSettings != null)
      print('current settings are ${userSettings.settings}');
    if(userSettings != newSettings) {
      print('actually updating settings in PageModel');
      userSettings = UserSettings.clone(newSettings);
      notifyListeners();
    }
  }
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
