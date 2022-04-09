import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:login_flutter/services/Fetch.dart';

class TokenService extends Fetch {
  final String baseUrl = "http://10.0.2.2:5000";
  final privateKey = dotenv.get("PRIVATE_KEY").replaceAll("\\n", "\n");

  createServiceToken(String type) async {
    final url = "${this.baseUrl}/token/create";
    final body = {
      "type": type,
      "private_key": this.privateKey
    };
    
    final response = await this.post(url, {}, body);
    return response["service_token"];
  }

  createTxToken(String txPayload) async {
    final url = "${this.baseUrl}/token/create";
    final body = {
      "type": "tx.create",
      "private_key": this.privateKey,
      "payload": {
        "tx_payload": txPayload
      }
    };

    final response = await this.post(url, {}, body);
    return response["service_token"];
  }
}