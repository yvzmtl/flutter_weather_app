import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_weather_app_new/const/const.dart';
import 'package:flutter_weather_app_new/models/forecast_result.dart';
import 'package:flutter_weather_app_new/models/weather_result.dart';
import 'package:flutter_weather_app_new/network/open_weather_map_client.dart';
import 'package:flutter_weather_app_new/state/state.dart';
import 'package:flutter_weather_app_new/utils/utils.dart';
import 'package:flutter_weather_app_new/widget/fore_cast_tile_widget.dart';
import 'package:flutter_weather_app_new/widget/info_widget.dart';
import 'package:flutter_weather_app_new/widget/weather_tile_widget.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:location/location.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
        SystemUiOverlayStyle(statusBarColor: Color(colorBg1)));

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final controller = Get.put(MyStateController());
  var location = Location();
  late StreamSubscription listener;
  late PermissionStatus permissionStatus;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    WidgetsFlutterBinding.ensureInitialized()
        .addPersistentFrameCallback((_) async {
      await enableLocationListener();
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    listener.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Obx(
          () => Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                  tileMode: TileMode.clamp,
                  begin: Alignment.topRight,
                  end: Alignment.bottomRight,
                  colors: [Color(colorBg1), Color(colorBg2)]),
            ),
            child: controller.locationDate.value.latitude != null
                ? FutureBuilder(
                    future: OpenWeatherMapClient()
                        .getWeather(controller.locationDate.value),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(
                          child: CircularProgressIndicator(
                            color: Colors.white,
                          ),
                        );
                      } else if (snapshot.hasError) {
                        return Center(
                          child: Text(
                            snapshot.error.toString(),
                            style: TextStyle(color: Colors.white),
                          ),
                        );
                      } else if (!snapshot.hasData) {
                        return const Center(
                          child: Text(
                            'No Data',
                            style: TextStyle(color: Colors.white),
                          ),
                        );
                      } else {
                        var data = snapshot.data as WeatherResult;
                        return Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            SizedBox(
                              height: MediaQuery.of(context).size.height / 20,
                            ),
                            WeatherTileWidget(
                              context: context,
                              title: (data.name != null && data.name!.isEmpty)
                                  ? data.name
                                  : '${data.coord!.lat}/${data.coord!.lon}',
                              titleFontSize: 30.0,
                              subTitle: DateFormat('dd-MMM-yyyy').format(
                                  DateTime.fromMillisecondsSinceEpoch(
                                      (data.dt ?? 0) * 1000)),
                            ),
                            SizedBox(
                              height: MediaQuery.of(context).size.height / 15,
                            ),
                            Center(
                              child: CachedNetworkImage(
                                //imageUrl: 'https://openweatherapp.org/img/wn/11d@4x.png',
                                imageUrl:
                                    buildIcon(data.weather![0]!.icon ?? ''),
                                // 'https://upload.wikimedia.org/wikipedia/commons/thumb/e/e7/Weather-rain-thunderstorm.svg/431px-Weather-rain-thunderstorm.svg.png',
                                height: 100,
                                width: 100,
                                fit: BoxFit.fill,
                                progressIndicatorBuilder:
                                    (context, url, downloadProgress) =>
                                        const CircularProgressIndicator(),
                                errorWidget: (context, url, err) => const Icon(
                                  Icons.image,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            SizedBox(
                              height: MediaQuery.of(context).size.height / 20,
                            ),
                            WeatherTileWidget(
                                context: context,
                                title: "${data.main!.temp}°C",
                                titleFontSize: 60.0,
                                subTitle: '${data.weather![0]!.description}'),
                            SizedBox(
                              height: 30,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                SizedBox(
                                  width: MediaQuery.of(context).size.width / 8,
                                ),
                                InfoWidget(
                                  icon: FontAwesomeIcons.wind,
                                  text: '${data.wind!.speed}',
                                ),
                                InfoWidget(
                                  icon: FontAwesomeIcons.cloud,
                                  text: '${data.clouds!.all}',
                                ),
                                InfoWidget(
                                  icon: FontAwesomeIcons.snowflake,
                                  //text: '${data!.snow!.d1h}',
                                  text: '',
                                ),
                                SizedBox(
                                  width: MediaQuery.of(context).size.width / 8,
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 30,
                            ),
                            Expanded(
                                child: FutureBuilder(
                              future: OpenWeatherMapClient()
                                  .getForecast(controller.locationDate.value),
                              builder: (context, snapshot) {
                                if (snapshot.connectionState ==
                                    ConnectionState.waiting) {
                                  return const Center(
                                    child: CircularProgressIndicator(
                                      color: Colors.white,
                                    ),
                                  );
                                } else if (snapshot.hasError) {
                                  return Center(
                                    child: Text(
                                      snapshot.error.toString(),
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  );
                                } else if (!snapshot.hasData) {
                                  return const Center(
                                    child: Text(
                                      'No Data',
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  );
                                } else {
                                  var data = snapshot.data as ForecastResult;
                                  return ListView.builder(
                                    itemCount: data.list!.length ?? 0,
                                    scrollDirection: Axis.horizontal,
                                    itemBuilder: (context, index) {
                                      var item = data.list![index];
                                      return ForeCastTileWidget(
                                          temp: '${item.main!.temp}°C',
                                          imageUrl: buildIcon(
                                              item.weather![0].icon ?? '',
                                              isBigSize: false),
                                          time: DateFormat('HH:mm').format(
                                              DateTime
                                                  .fromMillisecondsSinceEpoch(
                                                      (item.dt ?? 0) * 1000)));
                                    },
                                  );
                                }
                              },
                            ))
                          ],
                        );
                      }
                    })
                : const Center(
                    child: Text(
                      'Bekleniyor...',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          controller.locationDate.value = await location.getLocation();
        },
        child: Icon(Icons.refresh),
      ),
    );
  }

  Future<void> enableLocationListener() async {
    controller.isEnableLocation.value = await location.serviceEnabled();
    if (!controller.isEnableLocation.value) {
      controller.isEnableLocation.value = await location.requestService();
      if (!controller.isEnableLocation.value) {
        return;
      }
    }

    permissionStatus = await location.hasPermission();
    if (permissionStatus == PermissionStatus.denied) {
      permissionStatus = await location.requestPermission();
      if (permissionStatus != PermissionStatus.granted) {
        return;
      }
    }

    controller.locationDate.value = await location.getLocation();
    listener = location.onLocationChanged.listen((event) {});
  }
}
