import 'dart:math';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:weatherlogik/constants/appi.dart';
import 'package:weatherlogik/models/weather.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Future<Weather?> fetchDate() async {
    final dio = Dio();
    final response = await dio.get(ApiConst.api);
    print(response);
    if (response.statusCode == 200) {
      final Weather weather = Weather(
          main: response.data['weather'][0]['main'],
          description: response.data['weather'][0]['description'],
          icon: response.data['weather'][0]['icon'],
          name: response.data['name']);
      return weather;
    } else {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "WEATHER",
          style: TextStyle(fontSize: 28),
        ),
        centerTitle: true,
      ),
      body: FutureBuilder(
        future: fetchDate(),
        builder: (ctx, sn) {
          if (sn.hasData) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    sn.data!.main,
                    style: TextStyle(fontSize: 50),
                  ),
                  Text(sn.data!.description),
                  Text(sn.data!.icon),
                  Text(sn.data!.name),
                ],
              ),
            );
          } else if (sn.hasError) {
            return Text(sn.error.toString());
          } else {
            return const CircularProgressIndicator();
          }
        },
      ),
    );
  }
}
