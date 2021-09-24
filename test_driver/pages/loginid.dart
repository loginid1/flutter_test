import 'package:flutter_driver/flutter_driver.dart';

class LoginID {
  final apiKeyInput = find.byValueKey("api_key");
  final baseUriInput = find.byValueKey("base_uri");
  final usernameInput = find.byValueKey("username");
  final txConfirmationInput = find.byValueKey("tx_confirmation");
  final configureBtn = find.byValueKey("configure");
  final infoBtn = find.byValueKey("info");
  final registerFido2Btn = find.byValueKey("register_fido2");
  final registerPasswordBtn = find.byValueKey("register_password");
  final loginFido2Btn = find.byValueKey("login_fido2");
  final loginPasswordBtn = find.byValueKey("login_password");
  final txConfirmationBtn = find.byValueKey("tx_confirmation");
  final logoutBtn = find.byValueKey("logout");
  final alertText = find.byValueKey("alert_text");
  final okBtn = find.byValueKey("ok");

  FlutterDriver _driver;

  LoginID(FlutterDriver driver) {
    this._driver = driver;
  }

  Future<void> configure(String apiKey, String baseURL) async {
    await this._driver.tap(this.apiKeyInput);
    await this._driver.enterText(apiKey);
    await this._driver.tap(this.baseUriInput);
    await this._driver.enterText(baseURL);
    await this._driver.tap(this.configureBtn);
  }

  Future<void> action(String username, SerializableFinder button) async {
    await this._driver.tap(this.usernameInput);
    await this._driver.enterText(username);
    await this._driver.tap(button);
  }

  Future<void> registerFido2(String username) async {
    await this.action(username, this.registerFido2Btn);
  }

  Future<void> registerPassword(String username) async {
    await this.action(username, this.registerPasswordBtn);
  }

  Future<void> loginFido2(String username) async {
    await this.action(username, this.loginFido2Btn);
  }

  Future<void> loginPassword(String username) async {
    await this.action(username, this.loginPasswordBtn);
  }

  Future<void> txConfirmation(String username, String payload) async {
    await this._driver.tap(this.usernameInput);
    await this._driver.enterText(username);
    await this._driver.tap(this.txConfirmationInput);
    await this._driver.enterText(payload);
    await this._driver.tap(this.txConfirmationBtn);
  }

  Future<void> logout() async {
    await this._driver.tap(this.logoutBtn);
  }

  Future<Map<String, String>> getUserInformation() async {
    final info = new Map<String, String>();

    await this._driver.tap(this.infoBtn);
    (await this.getAlertText())
        .split("\n")
        .map<List<String>>((e) => e.split(":"))
        .where((e) => e.length == 2)
        .forEach((e) => info[e[0]] = e[1]);
    return info;
  }

  Future<String> getAlertText() async {
    await this._driver.waitFor(this.alertText);
    return await this._driver.getText(this.alertText);
  }

  Future<void> closeAlert() async {
    await this._driver.waitFor(this.okBtn);
    // await Future.delayed(const Duration(seconds: 2), () {});
    await this._driver.tap(this.okBtn);
  }
}
