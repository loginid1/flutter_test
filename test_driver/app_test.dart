import 'package:flutter_driver/flutter_driver.dart';
import 'package:test/test.dart';
import 'package:random_string/random_string.dart' as random;
import 'package:dotenv/dotenv.dart' show load, env;
import './pages/loginid.dart';
import './pages/messages.dart';

void main() {
  load();
  final apiKey = env["API_KEY"];
  final baseUri = env["BASE_URI"];
  final mainUsername = random.randomAlphaNumeric(7);

  FlutterDriver? driver;
  late LoginID loginid;

  setUpAll(() async {
    driver = await FlutterDriver.connect();
    loginid = new LoginID(driver);
    await loginid.configure(apiKey!, baseUri!);
    await loginid.closeAlert();
  });
  
  group("Registration", () {
    test("Should register a user with FIDO2", () async {
        final username = random.randomAlphaNumeric(10);
        await loginid.registerFido2(username);
        final result = await loginid.getAlertText();
        expect(result, Messages.successfulRegister(username: username));
    });

    test("Should register a user with FIDO2", () async {
        final username = random.randomAlphaNumeric(10);
        await loginid.registerPassword(username);
        final result = await loginid.getAlertText();
        expect(result, Messages.successfulRegister(username: username));
    });
  });

/*
  group("Authentication", () {
    group("Register", () {
      test("should register a useranme with 3 characters", () async {
        final username = random.randomAlphaNumeric(3);
        await loginid.register(username);
        final result = await loginid.getAlertText();
        expect(result, Messages.successfulRegister(username));
      });

      tearDown(() async {
        await loginid.closeAlert();
        await loginid.logout();
      });
    });

    group("Login", () {
      setUpAll(() async {
        await loginid.register(mainUsername);
        await loginid.closeAlert();
        await loginid.logout();
      });

      test("should login a user with a registered username", () async {
        await loginid.login(mainUsername);
        final result = await loginid.getAlertText();
        expect(result, Messages.successfulLogin(mainUsername));

        await loginid.closeAlert();
        await loginid.logout();
      });

      test("should reauthenticate a user", () async {
        await loginid.login("");
        final result = await loginid.getAlertText();

        if (platform == "iOS") {
          expect(result, Messages.noUsername);
          await loginid.closeAlert();
        } else {
          //android code
        }
      });
    });
  });

  group("User Information", () {
    test("Logged Out", () async {
      final info = await loginid.getUserInformation();
      expect(info["hasAccount"], "yes");
      expect(info["username"], "null");
      expect(info["isLoggedIn"], "no");
      expect(info["jwt"], "null");
    });

    test("Logged In", () async {
      await loginid.login(mainUsername);
      await loginid.closeAlert();
      final info = await loginid.getUserInformation();
      expect(info["hasAccount"], "yes");
      expect(info["username"], mainUsername);
      expect(info["isLoggedIn"], "yes");
      expect(info["jwt"], isNot("null"));
    });

    tearDown(() async {
      await loginid.closeAlert();
    });
  });
  */  

  tearDownAll(() async {
    await driver!.close();
  });
}
