import 'package:login_flutter/exceptions/CodeTypeException.dart';
import 'package:login_flutter/services/Fetch.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:login_flutter/services/Token.dart';

class LoginIDService extends Fetch {
  static Set codeType = <String>{ "short", "long", "phrase" };
  static Set codePurpose = <String>{ "temporary_authentication", "add_credential" };
  final String baseUrl = dotenv.get("PRIVATE_BASE_URL") + "/api/native";
  final String clientId = dotenv.get("BACKEND_CLIENT_ID");
  final tokenService = TokenService();

  _checkValidCodeType(String code) {
     if (!LoginIDService.codeType.contains(code)) {
       throw CodeTypeException(code);
     }
  }

  _checkValidCodePurpose(String purpose) {
    if (!LoginIDService.codePurpose.contains(purpose)) {
      throw CodeTypeException(purpose);
    }
  }

  _createCommonHeaders(String type) async {
    var serviceToken = await tokenService.createServiceToken(type);
    return {
      "Authorization": "Bearer ${serviceToken}"
  };
  }

  generateCode(String username, String codeType, bool authorize, String purpose) async {
    this._checkValidCodeType(codeType);
    this._checkValidCodePurpose(purpose);

    var url = "${this.baseUrl}/codes/${codeType}/generate";
    var headers = await this._createCommonHeaders("codes.generate");
    var body = {
      "client_id": this.clientId,
      "username": username,
      "purpose": purpose,
      "authorize": authorize
    };

    final response = await this.post(url, headers, body);
    return response["code"];
  }
}