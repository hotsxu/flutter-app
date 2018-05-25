import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;

final String baseUrl = "https://api.unsplash.com/photos/";

final String _clientId =
    "ab708e05d77b0f3922cdfae6907b998f4fdd3a9ba46bf0eaa3279e0503912d92";

class Api {
  static Future get({Map map}) async {
    String url = baseUrl + "?client_id=$_clientId";
    if (map != null) {
      map.forEach((key, value) {
        url += "&$key$value";
      });
    }
    var response = await http.get(url);
    return json.decode(response.body);
  }
}
