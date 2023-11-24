import 'package:connectivity_widget/connectivity_widget.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_locales/flutter_locales.dart';
import 'package:provider/provider.dart';
import 'package:weather_icons/weather_icons.dart';

import '../provider/location_provider.dart';
import '../provider/provider.dart';
import '../uttils/app_utils.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      var provider = Provider.of<LocationProvider>(context, listen: false);
      context
          .read<LocationProvider>()
          .getCurrentPosition(context)
          .then((value) {
        context.read<ProviderClass>().getAPiDataRes(
            context,
            provider.currentPosition!.latitude,
            provider.currentPosition!.longitude);
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            const LocaleText("location"),
            Consumer<ProviderClass>(
              builder: (BuildContext context, value, Widget? child) {
                return value.weatherClassModel == null || value.isLoading
                    ? const SizedBox()
                    : Text(": ${value.weatherClassModel!.city.name}");
              },
            )
          ],
        ),
        actions: [
          PopupMenuButton(
              icon: const Icon(
                Icons.more_vert,
                color: Colors.white,
              ),
              itemBuilder: (context) {
                return const [
                  PopupMenuItem<int>(
                    value: 1,
                    child: Text("English"),
                  ),
                  PopupMenuItem<int>(
                    value: 2,
                    child: Text("Arabic"),
                  ),
                ];
              },
              onSelected: (val) {
                if (val == 1) {
                  LocaleNotifier.of(context)!.change('en');
                  setState(() {});
                  if (kDebugMode) {
                    print('english');
                  }
                }
                if (val == 2) {
                  LocaleNotifier.of(context)!.change('ar');
                  setState(() {});
                  if (kDebugMode) {
                    print('arabic');
                  }
                }
              }),
          const SizedBox(width: 2),
        ],
      ),
      body: ConnectivityWidget(
        onlineCallback: () {
          var provider = Provider.of<LocationProvider>(context, listen: false);
          context
              .read<LocationProvider>()
              .getCurrentPosition(context)
              .then((value) {
            context.read<ProviderClass>().getAPiDataRes(
                context,
                provider.currentPosition!.latitude,
                provider.currentPosition!.longitude);
          });
        },
        showOfflineBanner: true,
        builder: (BuildContext context, bool isOnline) {
          return isOnline
              ? Consumer<ProviderClass>(
                  builder: (BuildContext context, value, Widget? child) {
                    return value.weatherClassModel == null || value.isLoading
                        ? AppUtils.loading()
                        : ListView.builder(
                            itemCount: value.weatherClassModel!.list.length,
                            itemBuilder: (BuildContext context, int index) {
                              var cloud = value.weatherClassModel!.list[index]
                                  .weather.first.description
                                  .toString();
                              var finalCl = cloud.substring(12);
                              var data = value.weatherClassModel!.list[index];
                              var temp = data.main.temp.toInt();
                              double temperatureInCelsius = temp - 273.15;
                              double temperatureInFahrenheit =
                                  temp * 9 / 5 - 459.67;
                              return Card(
                                margin: const EdgeInsets.symmetric(
                                    vertical: 8, horizontal: 14),
                                child: ListTile(
                                  contentPadding: const EdgeInsets.symmetric(
                                      horizontal: 20),
                                  // title: Text(
                                  //     "Temperature ${temperatureInCelsius.toStringAsFixed(0)}°"),
                                  title: Row(
                                    children: [
                                      const LocaleText("temperature"),
                                      Text(
                                          " ${temperatureInCelsius.toStringAsFixed(0)}°")
                                    ],
                                  ),
                                  subtitle: Text(finalCl.replaceAll("_", ' ')),
                                  trailing: Icon(
                                    getWeatherIcon(data.weather.first.icon),
                                    size: 30,
                                    color: Colors.deepPurple,
                                  ),
                                ),
                              );
                            },
                          );
                  },
                )
              : const SizedBox(
                  child: Center(
                    child: Text("NO Internet Connection"),
                  ),
                );
        },
      ),
    );
  }

  IconData getWeatherIcon(String code) {
    switch (code) {
      case '01d':
        return WeatherIcons.day_sunny;
      case '02n':
        return WeatherIcons.cloud;
      case '03n':
        return WeatherIcons.cloudy;
      case '04n':
        return WeatherIcons.day_fog;
      // Add more cases for other weather codes if needed
      default:
        return WeatherIcons.sunset; // Default icon for unknown codes
    }
  }
}
