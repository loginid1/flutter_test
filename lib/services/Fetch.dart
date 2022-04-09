import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:login_flutter/exceptions/CodeTypeException.dart';

class Fetch {
   @protected
   post(String url, Map<String, String> headers, Map body) async {
     final parsedUrl = Uri.parse(url);
     final parsedBody = jsonEncode(body);

     headers["Content-Type"] = "application/json";

     final response = await http.post(
         parsedUrl,
         headers: headers,
         body: parsedBody
     );
     final data = jsonDecode(utf8.decode(response.bodyBytes)) as Map;

     if (response.statusCode >= 400) {
      throw ErrorResponseException(data["message"]);
     }

     return data;
  }
}