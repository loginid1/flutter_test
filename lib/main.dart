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

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

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
	final Widget ok = FlatButton(
	  child: Text("OK"),
	  onPressed: () { Navigator.of(context).pop(); },
	);

	showDialog(
	  context: context,
	  builder: (BuildContext context) { 
		return AlertDialog(
		  title: Text("ALERT"),
		  content: Text(message),
		  actions: [ok,],
		  elevation: 5,
		);
	  },
	);
  }

  Future<void> _configureLoginID (BuildContext context) async {
    String clientId = apiKeyController.text;
    String baseURL = baseUriController.text;
	await FPLoginApi.configure(clientId, baseURL);
	callAlertDialog(context, "Configuration Successful!");
  }

  Future<void> _userInfo (BuildContext context) async { 
	final String hasAccount = await FPLoginApi.hasAccount() ? "yes" : "no";
	final String username = await FPLoginApi.getCurrentUsername();
	final String isLoggedIn = await FPLoginApi.isLoggedIn() ? "yes" : "no";
	final String token = await FPLoginApi.getCurrentToken();

	final String message = "hasAccount:${hasAccount}\n" +
					 "username:${username}\n" +
					 "isLoggedIn:${isLoggedIn}\n" +
					 "jwt:${token}\n";

	callAlertDialog(context, message);
  }

  Future<void> _registerButtonHandler (BuildContext context) async {
    String clientId = "gi4DN17MwjG1FPZGGDxJacXBaWIZgL8HcSB418Q2tBHyiTNMjzgMVGZ2vTOMOliG9xAFSWGoH-icgNzJA_sy6w==";
    String baseURL = "https://04c3a570-9621-11eb-9668-3d2d19cc8c42.sandbox-usw1.api.loginid.io";
    await FPLoginApi.configure(clientId,baseURL);

	final String username = usernameController.text;

    try {
      final RegisterResponse res = await FPLoginApi.registerWithUsername(username);
      if(res.success == true){
	  	callAlertDialog(context, "Successfully registered ${username}!");
		setState(() { 
		  isLoggedIn = true;
		});
      } else {
		callAlertDialog(context, "ERROR: ${res.errorMessage}");
      }
    } on PlatformException catch(err){
	  callAlertDialog(context, "ERROR: ${err.message}");
    }
  }

  Future<void> _loginButtonHandler (BuildContext context) async { 
	final String username = usernameController.text;
  	var res;

	try { 
	  if (!username.isEmpty) { 
		res = await FPLoginApi.loginWithUsername(username);
	  } else { 
		res = await FPLoginApi.login();
	  }

	  if (res.success == true) { 
		final String _username = await FPLoginApi.getCurrentUsername();
		callAlertDialog(context, "${_username} successfully logged in!");
		setState(() { 
		  isLoggedIn = true;
		});
	  } else { 
		callAlertDialog(context, "ERROR: ${res.errorMessage}");
	  }
	} on PlatformException catch(err) { 
	  callAlertDialog(context, "ERROR: ${err.message}");
	}
  }

  Future<void> _logoutButtonHandler (BuildContext context) async { 
	await FPLoginApi.logout();
	setState(() { 
	  isLoggedIn = false;
	});
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: ListView(
          padding: const EdgeInsets.all(15),
          children: [
            new Container(
              margin: const EdgeInsets.only(bottom: 10.0),
              child: TextField(controller: apiKeyController,decoration: new InputDecoration(
                labelText: "API Key",
                filled: true,
            ),),),
            new Container(
              margin: const EdgeInsets.only(bottom: 10.0),
              child: TextField(controller: baseUriController, decoration: new InputDecoration(
                labelText: "Base URI",
                filled: true,
              ),),),
            new Container(
              margin: const EdgeInsets.only(bottom: 10.0),
              child: TextField(controller: usernameController, decoration: new InputDecoration(
                labelText: "Username",
                filled: true,
              ),),),
            ElevatedButton(onPressed: () {
				_configureLoginID(context);
			}, child: Text("CONFIGURE")),	
            ElevatedButton(onPressed: () {
				_userInfo(context);
			}, child: Text("INFO")),
            ElevatedButton(onPressed: () {
				_loginButtonHandler(context);
			}, child: Text("LOGIN")),
            ElevatedButton(onPressed: () {
				_registerButtonHandler(context);
			}, child: Text("REGISTER")),
            isLoggedIn ? ElevatedButton(onPressed: () {
				_logoutButtonHandler(context);
			}, child: Text("LOGOUT")) : 
			SizedBox.shrink(),
          ],
        )
      ),
    );
  }
}
