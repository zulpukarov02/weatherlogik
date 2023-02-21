import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

import 'package:weatherlogik/components/custom.dart';
import 'package:weatherlogik/constants/app_colors.dart';
import 'package:weatherlogik/constants/app_textStyle.dart';
import 'package:weatherlogik/constants/appi.dart';
import 'package:weatherlogik/models/weather.dart';

const List cities = <String>[
  'bishkek',
  'osh',
  'jalal-abad',
  'karakol',
  'batken',
  'naryn',
  'talas',
  'tokmok'
];

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Weather? weather;

  Future<void> weatherLoction() async {
    setState(() {
      weather = null;
    });
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.always &&
          permission == LocationPermission.whileInUse) {
        Position position = await Geolocator.getCurrentPosition();
        final dio = Dio();
        final response = await dio
            .get(ApiConst.latLongaddres(position.latitude, position.longitude));
        print(response.data);
        if (response.statusCode == 200) {
          final Weather weather = Weather(
            id: response.data['current']['weather'][0]['id'],
            main: response.data['current']['weather'][0]['main'],
            description: response.data['current']['weather'][0]['description'],
            icon: response.data['current']['weather'][0]['icon'],
            city: response.data['timezone'],
            temp: response.data['current']['temp'],
          );
        }

        setState(() {});
      }
    } else {
      Position position = await Geolocator.getCurrentPosition();
      final dio = Dio();
      final response = await dio
          .get(ApiConst.latLongaddres(position.latitude, position.longitude));
      print(response.data);
      if (response.statusCode == 200) {
        final Weather weather = Weather(
          id: response.data['current']['weather'][0]['id'],
          main: response.data['current']['weather'][0]['main'],
          description: response.data['current']['weather'][0]['description'],
          icon: response.data['current']['weather'][0]['icon'],
          city: response.data['timezone'],
          temp: response.data['current']['temp'],
        );
      }
      print(weather);
      setState(() {});
      // print(position.latitude);
      // print(position.longitude);
    }
  }

  Future<void> weatherName([String? name]) async {
    // await Future.delayed(const Duration(seconds: 3));
    final dio = Dio();
    final response = await dio.get(ApiConst.address(name ?? 'bishkek'));
    if (response.statusCode == 200) {
      weather = Weather(
        id: response.data['weather'][0]['id'],
        main: response.data['weather'][0]['main'],
        description: response.data['weather'][0]['description'],
        icon: response.data['weather'][0]['icon'],
        city: response.data['name'],
        temp: response.data["main"]['temp'],
        country: response.data["sys"]['country'],
      );

      setState(() {});
    }
  }

  @override
  void initState() {
    super.initState();
    weatherName();
  }

  @override
  Widget build(BuildContext context) {
    log('max W ==> ${MediaQuery.of(context).size.width}');
    log('max H ==> ${MediaQuery.of(context).size.height}');
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        elevation: 0.0,
        title: const Text("WEATHER", style: AppTextStyle.appBartitle),
        centerTitle: true,
      ),
      body: weather == null
          ? Center(child: CircularProgressIndicator())
          : Container(
              // constraints: BoxConstraints.lerp(asc),
              width: double.infinity,
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/imeges/weatherfoto.jpg'),
                  fit: BoxFit.cover,
                ),
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      CustomButton(
                        onPressed: () async {
                          await weatherLoction();
                        },
                        icon: Icons.near_me,
                      ),
                      CustomButton(
                          onPressed: () {
                            showBottom();
                          },
                          icon: Icons.location_city)
                    ],
                  ),
                  Row(
                    children: [
                      Text(
                        "${(weather!.temp - 273.15).toInt()}°",
                        style: AppTextStyle.temp,
                      ),
                      const SizedBox(
                        width: 25,
                      ),
                      Image.network(
                        ApiConst.getIcon(weather!.icon, 4),
                      )
                    ],
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Expanded(
                    child: FittedBox(
                      child: Text(
                        weather!.description.replaceAll(' ', '\n'),
                        // "You'all need and".replaceAll(' ', '\n'),
                        style: AppTextStyle.centrtitle,
                        textAlign: TextAlign.right,
                      ),
                    ),
                  ),
                  Expanded(
                    child: FittedBox(
                      child: Text(
                        weather!.city,
                        style: TextStyle(fontSize: 80, color: AppColors.white),
                      ),
                    ),
                  )
                ],
              ),
            ),
    );
  }

  void showBottom() {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return Container(
          height: MediaQuery.of(context).size.height * 0.7,
          padding: const EdgeInsets.fromLTRB(15, 20, 15, 7),
          decoration: BoxDecoration(
            color: const Color.fromARGB(255, 18, 180, 230),
            border: Border.all(color: AppColors.white),
            borderRadius: const BorderRadius.only(
              topRight: Radius.circular(20.0),
              topLeft: Radius.circular(20.0),
            ),
          ),
          child: ListView.builder(
            itemCount: cities.length,
            itemBuilder: (BuildContext context, int index) {
              final city = cities[index];
              return Card(
                child: ListTile(
                  onTap: () async {
                    setState(() {
                      weather = null;
                    });
                    weatherName(city);
                    Navigator.pop(context);
                  },
                  title: Text(city),
                ),
              );
            },
          ),
        );
      },
    );
  }
}
      
          //   } else {
          //     return Text("Tehnicheskii ne ispravnost");
          //   }
          // } else {
          //   return Text("Tehnicheskii ne ispravnost");
          // }
        
 // body: FutureBuilder<Weather?>(
      //   future: fetchDate(),
      //   builder: (cnt, sn) {
      //     if (sn.connectionState == ConnectionState.waiting) {
      //       return const Center(
      //         child: CircularProgressIndicator(),
      //       );
      //     } else if (sn.connectionState == ConnectionState.none) {
      //       return Text("Povtorite popytku");
      //     } else if (sn.connectionState == ConnectionState.done) {
      //       if (sn.hasError) {
      //         return Text("${sn.hasError}");
      //       } else if (sn.hasData) {
      //         final weather = sn.data!;
      //         return Container(
      //           // constraints: BoxConstraints.lerp(asc),
      //           decoration: const BoxDecoration(
      //             image: DecorationImage(
      //               image: AssetImage('assets/imeges/weatherfoto.jpg'),
      //               fit: BoxFit.cover,
      //             ),
      //           ),
      //           child: Column(
      //             children: [
      //               Row(
      //                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
      //                 children: [
      //                   CustomButton(
      //                     onPressed: () async {
      //                       await weatherLoction();
      //                     },
      //                     icon: Icons.near_me,
      //                   ),
      //                   CustomButton(
      //                       onPressed: () {}, icon: Icons.location_city)
      //                 ],
      //               ),
      //               Row(
      //                 children: [
      //                   Text(
      //                     "${(weather.temp - 273.15).toInt()}°",
      //                     style: AppTextStyle.temp,
      //                   ),
      //                   const SizedBox(
      //                     width: 25,
      //                   ),
      //                   Image.network(
      //                     ApiConst.getIcon(weather.icon, 4),
      //                   )
      //                 ],
      //               ),
      //               const SizedBox(
      //                 height: 20,
      //               ),
      //               Expanded(
      //                 child: FittedBox(
      //                   child: Text(
      //                     weather.description.replaceAll(' ', '\n'),
      //                     // "You'all need and".replaceAll(' ', '\n'),
      //                     style: AppTextStyle.centrtitle,
      //                     textAlign: TextAlign.right,
      //                   ),
      //                 ),
      //               ),
      //               Expanded(
      //                 child: FittedBox(
      //                   child: Text(
      //                     weather.city,
      //                     style:
      //                         TextStyle(fontSize: 80, color: AppColors.white),
      //                   ),
      //                 ),
      //               )
      //             ],
      //           ),
      //         );