import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;

import '../model/weather_class_model.dart';

class MethodServices {
  Future<WeatherClassModel> getApiRes(context, double lat, double lon) async {
    WeatherClassModel? weatherClassModel;
    try {
      var BASE_URL =
          "https://api.openweathermap.org/data/2.5/forecast?lat=$lat&lon=$lon&appid=979b9c814b1159ab30fb20a8f07b0034";
      final res = await http.get(Uri.parse(BASE_URL));
      if (res.statusCode == 200) {
        weatherClassModel = weatherClassModelFromJson(res.body);
        if (kDebugMode) {
          print(weatherClassModel);
        }
      } else {
        if (kDebugMode) {
          print('erro come in apis');
          print(res.body);
        }
      }
    } on PlatformException catch (e) {
      if (kDebugMode) {
        print(e.message.toString());
      }
    }
    return weatherClassModel!;
  }
}
