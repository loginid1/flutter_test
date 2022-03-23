import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:flutterpluginfidologinapi/flutterpluginfidologinapi.dart';
import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:crypto/crypto.dart';
import 'package:random_string/random_string.dart' as random;

void main() async {
  await dotenv.load(fileName: ".env");
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
  final txPayloadController = TextEditingController();
  final privateKey = dotenv.get("PRIVATE_KEY").replaceAll("\\n", "\n");
  final pubClientId = dotenv.get("PUBLIC_CLIENT_ID");
  final pubBaseUrl = dotenv.get("PUBLIC_BASE_URL");
  final privClientId = dotenv.get("PRIVATE_CLIENT_ID");
  final privBaseUrl = dotenv.get("PRIVATE_BASE_URL");
  var password = "Qwerty1!";
  var isLoggedIn = false;
  var needServiceToken = false;

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

  Future<void> _registerFido2Handler(BuildContext context) async {
    final String username = usernameController.text;

    RegistrationOptions options;
    if (needServiceToken) {
      options = RegistrationOptions.buildAuth(createServiceToken("auth.register"));
    }
    final RegisterResponse res = await FPLoginApi.registerWithFido2(username, options);

    try {
      if (res.success) {
        callAlertDialog(context, res.jwt);
          setState(() {
            isLoggedIn = true;
          });
      } else {
        callAlertDialog(context, res.errorMessage);
      }
    } on PlatformException catch (err) {
      callAlertDialog(context, err.message);
    }
  }

  Future<void> _loginFido2Handler(BuildContext context) async {
    final String username = usernameController.text;

    AuthenticationOptions options;
    if (needServiceToken) {
      options = AuthenticationOptions.buildAuth(createServiceToken("auth.login"));
    }
    final AuthenticateResponse res = await FPLoginApi.authenticateWithFido2(username, options);

    try {
      if (res.success == true) {
        final String _username = await FPLoginApi.getCurrentUsername();
        callAlertDialog(context, res.jwt);
        setState(() {
          isLoggedIn = true;
        });
      } else {
        callAlertDialog(context, res.errorMessage);
      }
    } on PlatformException catch (err) {
      callAlertDialog(context, err.message);
    }
  }

  Future<void> _registerPasswordHandler(BuildContext context) async {
    final String username = usernameController.text;

    RegistrationOptions options;
    if (needServiceToken) {
      options = RegistrationOptions.buildAuth(createServiceToken("auth.register"));
    }
    final RegisterResponse res = await FPLoginApi.registerWithPassword(username, password, password, options);

    try {
      if (res.success) {
        callAlertDialog(context, res.jwt);
        setState(() {
          isLoggedIn = true;
        });
      } else {
        callAlertDialog(context, res.errorMessage);
      }
    } on PlatformException catch (err) {
        callAlertDialog(context, res.errorMessage);
    }
  }

  Future<void> _loginPasswordHandler(BuildContext context) async {
    final String username = usernameController.text;

    AuthenticationOptions options;
    if (needServiceToken) {
      options = AuthenticationOptions.buildAuth(createServiceToken("auth.login"));
    }
    final AuthenticateResponse res = await FPLoginApi.authenticateWithPassword(username, password, options);

    try {
      if (res.success) {
        callAlertDialog(context, res.jwt);
          setState(() {
            isLoggedIn = true;
          });
      } else {
        callAlertDialog(context, res.errorMessage);
      }
    } on PlatformException catch (err) {
      callAlertDialog(context, err.message);
    }
  }

  Future<void> _txConfirmationHandler(BuildContext context) async {
    final String username = usernameController.text;
    final String data = txPayloadController.text;
    final String nonce = random.randomAlphaNumeric(16);

    TransactionOptions options;
    if (needServiceToken) {
      options = TransactionOptions.buildAuth(createServiceToken("tx.create", data, nonce, username));
    }
    TransactionPayload payload = TransactionPayload.build(nonce, data);
    final TransactionResponse res = await FPLoginApi.transactionConfirmation(username, payload, options);

    try {
      if (res.success) {
        callAlertDialog(context, res.jwt);
          setState(() {
            isLoggedIn = true;
          });
      } else {
        callAlertDialog(context, res.errorMessage);
      }
    } on PlatformException catch (err) {
      callAlertDialog(context, err.message);
    }
  }

  Future<void> _logoutButtonHandler(BuildContext context) async {
    await FPLoginApi.logout();
    setState(() {
      isLoggedIn = false;
    });
  }

  String createServiceToken(String type, [String payload = "", String nonce = "", String username = ""]) {
    final claims = {
      "scope": type,
      "iat": DateTime.now().millisecondsSinceEpoch,
      "nonce": nonce.isEmpty ? random.randomAlphaNumeric(16) : nonce
    };

    if (payload.length > 0) {
      var bytes = utf8.encode(payload);
      var digest = sha256.convert(bytes);
      var result = base64.encode(digest.bytes)
        .replaceAll("+", "-")
        .replaceAll("/", "_")
        .replaceAll("=", "");

      claims["payload_hash"] = result;
      claims["nonce"] = nonce;
    }

    if (username.length > 0) {
      claims["username"] = username;
    }

    final jwt = JWT(claims);

    final key = ECPrivateKey(privateKey);

    String serviceToken = jwt.sign(key, algorithm: JWTAlgorithm.ES256);
    return serviceToken;
  }

  void changeApplications(bool isPriv) async {
    if (isPriv) {
      await FPLoginApi.configure(privClientId, privBaseUrl);
    } else {
      await FPLoginApi.configure(pubClientId, pubBaseUrl);
    }
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
          new Text(
            "Credential",
            textAlign: TextAlign.center,
          ),
          new Switch(
            key: Key("credential_switch"),
            value: needServiceToken, 
            onChanged: (value) {
              setState(() {
                String clientId = apiKeyController.text;
                String baseURL = baseUriController.text;
                if (clientId.length > 0 || baseURL.length > 0) return;

                needServiceToken = value;
                changeApplications(value);
              });
            },
            activeTrackColor: Colors.lightGreenAccent,
            activeColor: Colors.green,
          ),
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
          new Container(
            margin: const EdgeInsets.only(bottom: 10.0),
            child: TextField(
              key: Key("tx_payload"),
              controller: txPayloadController,
              decoration: new InputDecoration(
                labelText: "Transaction Payload",
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
              key: Key("login_fido2"),
              onPressed: () {
                _loginFido2Handler(context);
              },
              child: Text("LOGIN")),
          ElevatedButton(
              key: Key("login_password"),
              onPressed: () {
                _loginPasswordHandler(context);
              },
              child: Text("LOGIN PASSWORD")),
          ElevatedButton(
              key: Key("register_fido2"),
              onPressed: () {
                _registerFido2Handler(context);
              },
              child: Text("REGISTER")),
          ElevatedButton(
              key: Key("register_password"),
              onPressed: () {
                _registerPasswordHandler(context);
              },
              child: Text("REGISTER PASSWORD")),
          ElevatedButton(
              key: Key("tx_confirmation"),
              onPressed: () {
                _txConfirmationHandler(context);
              },
              child: Text("TRANSACTION CREATE AND CONFIRM")),
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
