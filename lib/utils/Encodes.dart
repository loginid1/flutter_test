import 'dart:convert';
import 'dart:io';

import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:random_string/random_string.dart' as random;
import 'package:crypto/crypto.dart';

class Encodes {
  static final privateKey = dotenv.get("PRIVATE_KEY").replaceAll("\\n", "\n");

  static createServiceToken(String type, [String payload = "", String nonce = "", String username = ""]) {
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
    final key = ECPrivateKey(Encodes.privateKey);

    String serviceToken = jwt.sign(key, algorithm: JWTAlgorithm.ES256);
    return serviceToken;
  }
}