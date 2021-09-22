import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:flutterpluginfidologinapi/flutterpluginfidologinapi.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Login',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Login'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final apiKeyController = TextEditingController();
  final baseUriController = TextEditingController();
  final usernameController = TextEditingController();
  var isLoggedIn = false;

  callAlertDialog(BuildContext context, String message) {
    final Widget ok = TextButton(
      key: Key("ok"),
      child: Text("OK"),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("ALERT"),
          content: Text(message, key: Key("alert_text")),
          actions: [
            ok,
          ],
          elevation: 5,
        );
      },
    );
  }

  Future<void> _configureLoginID(BuildContext context) async {
    String clientId = apiKeyController.text;
    String baseURL = baseUriController.text;
    await FPLoginApi.configure(clientId, baseURL);
    callAlertDialog(context, "Configuration Successful!");
  }

  Future<void> _userInfo(BuildContext context) async {
    final String hasAccount = await FPLoginApi.hasAccount() ? "yes" : "no";
    final String username = await FPLoginApi.getCurrentUsername();
    final String isLoggedIn = await FPLoginApi.isLoggedIn() ? "yes" : "no";
    final String token = await FPLoginApi.getCurrentToken();

    final String message = "hasAccount:$hasAccount\n" +
        "username:$username\n" +
        "isLoggedIn:$isLoggedIn\n" +
        "jwt:$token\n";

    callAlertDialog(context, message);
  }

  Future<void> _registerButtonHandler(BuildContext context) async {
    String clientId =
        "gi4DN17MwjG1FPZGGDxJacXBaWIZgL8HcSB418Q2tBHyiTNMjzgMVGZ2vTOMOliG9xAFSWGoH-icgNzJA_sy6w==";
    String baseURL =
        "https://04c3a570-9621-11eb-9668-3d2d19cc8c42.sandbox-usw1.api.loginid.io";
    await FPLoginApi.configure(clientId, baseURL);

    final String username = usernameController.text;
  }

  Future<void> _loginButtonHandler(BuildContext context) async {
    final String username = usernameController.text;
    var res;

    try {
      if (username.isNotEmpty) {
        //res = await FPLoginApi.loginWithUsername(username);
      } else {
        //res = await FPLoginApi.login();
      }

      if (res.success == true) {
        final String _username = await FPLoginApi.getCurrentUsername();
        callAlertDialog(context, "$_username successfully logged in!");
        setState(() {
          isLoggedIn = true;
        });
      } else {
        callAlertDialog(context, "ERROR: ${res.errorMessage}");
      }
    } on PlatformException catch (err) {
      callAlertDialog(context, "ERROR: ${err.message}");
    }
  }

  Future<void> _logoutButtonHandler(BuildContext context) async {
    await FPLoginApi.logout();
    setState(() {
      isLoggedIn = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
          child: ListView(
        padding: const EdgeInsets.all(15),
        children: [
          new Container(
            margin: const EdgeInsets.only(bottom: 10.0),
            child: TextField(
              key: Key("api_key"),
              controller: apiKeyController,
              decoration: new InputDecoration(
                labelText: "API Key",
                filled: true,
              ),
            ),
          ),
          new Container(
            margin: const EdgeInsets.only(bottom: 10.0),
            child: TextField(
              key: Key("base_uri"),
              controller: baseUriController,
              decoration: new InputDecoration(
                labelText: "Base URI",
                filled: true,
              ),
            ),
          ),
          new Container(
            margin: const EdgeInsets.only(bottom: 10.0),
            child: TextField(
              key: Key("username"),
              controller: usernameController,
              decoration: new InputDecoration(
                labelText: "Username",
                filled: true,
              ),
            ),
          ),
          ElevatedButton(
              key: Key("configure"),
              onPressed: () {
                _configureLoginID(context);
              },
              child: Text("CONFIGURE")),
          ElevatedButton(
              key: Key("info"),
              onPressed: () {
                _userInfo(context);
              },
              child: Text("INFO")),
          ElevatedButton(
              key: Key("login"),
              onPressed: () {
                _loginButtonHandler(context);
              },
              child: Text("LOGIN")),
          ElevatedButton(
              key: Key("register"),
              onPressed: () {
                _registerButtonHandler(context);
              },
              child: Text("REGISTER")),
          isLoggedIn
              ? ElevatedButton(
                  key: Key("logout"),
                  onPressed: () {
                    _logoutButtonHandler(context);
                  },
                  child: Text("LOGOUT"))
              : SizedBox.shrink(),
        ],
      )),
    );
  }
}
