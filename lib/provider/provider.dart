import 'package:flutter/cupertino.dart';

import '../model/weather_class_model.dart';
import '../services/method_services.dart';

class ProviderClass extends ChangeNotifier {
  bool isLoading = false;
  WeatherClassModel? weatherClassModel;
  MethodServices services = MethodServices();
  getAPiDataRes(context, double lat, double lon) async {
    isLoading = true;
    weatherClassModel = await services.getApiRes(context, lat, lon);
    isLoading = false;
    notifyListeners();
  }
}
