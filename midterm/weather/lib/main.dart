// ignore_for_file: prefer_const_constructors

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:weather/weather.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Weather App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Weather App'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);
  final String title;

  // @override
  // void initState() {
  //   super.initState();
  // }

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  WeatherFactory wf = WeatherFactory('85bb8a59d4234c54d0297c062d392fb3');
  List<Weather>? weatherSearch;

  final StreamController<List<Weather>?> _controller = StreamController();
  Stream<List<Weather>?> get stream => _controller.stream;
  getWeather() {
    return "success";
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTextStyle(
      style: Theme.of(context).textTheme.headline2!,
      textAlign: TextAlign.center,
      child: StreamBuilder<List<Weather>?>(
        stream: _controller.stream,
        builder:
            (BuildContext context, AsyncSnapshot<List<Weather>?> snapshot) {
          List<Widget> children;
          if (!snapshot.hasData) {
            children = const <Widget>[
              SizedBox(
                width: 60,
                height: 60,
                child: CircularProgressIndicator(),
              ),
              Padding(
                padding: EdgeInsets.only(top: 16),
                child: Text('Awaiting result...'),
              )
            ];
          } else if (snapshot.hasError) {
            children = <Widget>[
              const Icon(
                Icons.error_outline,
                color: Colors.red,
                size: 60,
              ),
              Padding(
                padding: const EdgeInsets.only(top: 16),
                child: Text('Error: ${snapshot.error}'),
              )
            ];
          } else {}
          return weather(context, snapshot.data ?? []);
        },
      ),
    );
  }

  Future<void> citySearch(String city) async {
    if (city.trim() == '') {
      _controller.add(null);
      return;
    }
    try {
      _controller.add(null);
      weatherSearch = await wf.fiveDayForecastByCityName(city);
      _controller.add(weatherSearch);
    } catch (e) {
      return;
    }
  }

  final TextEditingController textEditingController = TextEditingController();
  Widget weather(BuildContext context, List<Weather> currentWeather) {
    return Scaffold(
      appBar: AppBar(
          // The search area here
          title: Container(
        width: double.infinity,
        height: 40,
        decoration: BoxDecoration(
            color: Colors.white, borderRadius: BorderRadius.circular(5)),
        child: Center(
          child: TextField(
            controller: textEditingController,
            decoration: InputDecoration(
              // prefixIcon: Icon(Icons.search),
              prefixIcon: IconButton(
                icon: Icon(Icons.search),
                onPressed: () {
                  setState(() {
                    citySearch(textEditingController.text);
                  });
                },
              ),
              hintText: 'Search...',
              border: InputBorder.none,
            ),
          ),
        ),
      )),
      body: Center(
        child: ListView.builder(
          itemCount: currentWeather.length,
          itemBuilder: (context, index) => Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(8.0),
              color: Colors.black12,
              child: Column(
                // ignore: prefer_const_literals_to_create_immutables
                children: [
                  Text(
                    currentWeather[index].temperature.toString(),
                    style: TextStyle(fontSize: 42),
                  ),
                  Image.network(
                    "http://openweathermap.org/img/wn/" +
                        currentWeather[index].weatherIcon.toString() +
                        "@2x.png",

                    // color: Colors.transparent,
                  ),
                  SizedBox(
                    height: 12,
                  ),
                  Text(
                    currentWeather[index].weatherDescription.toString(),
                    style: TextStyle(fontSize: 21),
                  ),
                  Text(
                    currentWeather[index].areaName.toString(),
                    style: TextStyle(fontSize: 32),
                  ),
                  Text(
                    currentWeather[index].date.toString(),
                    style: TextStyle(fontSize: 14),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
// Card(
//
//               ),
