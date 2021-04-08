import 'package:flutter_driver/flutter_driver.dart';
import 'package:test/test.dart';
import 'package:random_string/random_string.dart' as random;
import 'package:dotenv/dotenv.dart' show load, env;
import './pages/loginid.dart';
import './pages/Messages.dart';

void main() {
  load();
  final apiKey = env["API_KEY"];
  final baseUri = env["BASE_URI"];
  final platform = env["PLATFORM"];
  final mainUsername = random.randomAlphaNumeric(7);

  FlutterDriver driver;
  LoginID loginid;

  setUpAll(() async {
    driver = await FlutterDriver.connect();
    loginid = new LoginID(driver);
    await loginid.configure(apiKey, baseUri);
    await loginid.closeAlert();
  });

  group("Validations", () {
    group("Register", () {
      test("should not register a empty username", () async {
        await loginid.register("");
        final result = await loginid.getAlertText();
        expect(result, Messages.failedRegister);
      });

      test("should not register a username with one character", () async {
        await loginid.register(random.randomAlphaNumeric(1));
        final result = await loginid.getAlertText();
        expect(result, Messages.errorCharacters);
      });

      test("should not register a username with two characters", () async {
        await loginid.register(random.randomAlphaNumeric(2));
        final result = await loginid.getAlertText();
        expect(result, Messages.errorCharacters);
      });

      test("should not register a username with 129 characters", () async {
        await loginid.register(random.randomAlphaNumeric(129));
        final result = await loginid.getAlertText();
        expect(result, Messages.errorCharacters);
      });
    });

    group("Login", () {
      test("should not register a username with one character", () async {
        await loginid.login(random.randomAlphaNumeric(1));
        final result = await loginid.getAlertText();
        expect(result, Messages.errorCharacters);
      });

      test("should not register a username with two characters", () async {
        await loginid.login(random.randomAlphaNumeric(2));
        final result = await loginid.getAlertText();
        expect(result, Messages.errorCharacters);
      });

      test("should not register a username with 129 characters", () async {
        await loginid.login(random.randomAlphaNumeric(129));
        final result = await loginid.getAlertText();
        expect(result, Messages.errorCharacters);
      });
    });

    tearDown(() async {
      await loginid.closeAlert();
    });
  });

  group("Authentication", () {
    group("Register", () {
      test("should register a useranme with 3 characters", () async {
        final username = random.randomAlphaNumeric(3);
        await loginid.register(username);
        final result = await loginid.getAlertText();
        expect(result, Messages.successfulRegister(username));
      });

      test("should register a useranme with 128 characters", () async {
        final username = random.randomAlphaNumeric(128);
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

  tearDownAll(() async {
    await driver.close();
  });
}
