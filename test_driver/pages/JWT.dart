import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';
import 'package:dotenv/dotenv.dart' show env;

class JSONWebToken {
  static verifyJWT(String token) {
    try {
      final String publicKey = env["PUBLIC_KEY"]!;
      final key = ECPublicKey(publicKey);
      JWT.verify(token, key);
      return true;
    } on JWTError catch(err) {
      print(err.message);
      return false;
    } catch(err) {
      print(err.toString());
      return false;
    }
  }
}