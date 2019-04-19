import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import './CupertinoLocalization.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:connectivity/connectivity.dart';

import './Localization.dart';
import './MainModel.dart';
import './pages/CheckerPage.dart';
import './pages/FlowerPage.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return MyAppState();
  }
}

class MyAppState extends State<MyApp> {
  MainModel _model = new MainModel();
  var subscription;

  @override
  void initState() {
    Connectivity().checkConnectivity().then((ConnectivityResult result){
      _model.connected(result != ConnectivityResult.none);
    });
    subscription = Connectivity().onConnectivityChanged.listen((ConnectivityResult result) {
      _model.connected(result != ConnectivityResult.none);
    });
  }

  @override
  void dispose() {
    subscription.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModel<MainModel>(
      model: _model,
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        onGenerateTitle: (BuildContext context) =>
        AppLocalizations.of(context).title,
        localizationsDelegates: [
          const AppLocalizationsDelegate(),
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          const CupertinoLocalizationsDelegate(),
        ],
        supportedLocales: [
          const Locale('en', ''),
          const Locale('ru', ''),
        ],
        theme: ThemeData(
            primarySwatch: Colors.lightGreen,
            accentColor: Colors.orange,
            textTheme: TextTheme(button: TextStyle(color: Colors.white))),
        routes: {
          '/': (context) {
            return CheckerPage();
          },
        },
        onGenerateRoute: (RouteSettings settings) {
          final List<String> pathElements = settings.name.split("/");
          if (pathElements[0] != '') return null;
          if (pathElements[1] == 'flowers') {
            final String barcode = pathElements[2];
            return MaterialPageRoute(builder: (BuildContext context){
              return FlowerPage(barcode, _model.getFlower);
            });
          }
          return null;
        },
        onUnknownRoute: (RouteSettings settings) {
          return MaterialPageRoute(builder: (context) {
            return CheckerPage();
          });
        },
      ),
    );
  }
}
