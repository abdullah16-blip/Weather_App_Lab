import 'package:flutter/material.dart';
import 'package:http/http.dart' show get;
import 'dart:convert';
import 'models/weather_model.dart';
import 'package:geolocator/geolocator.dart';
import 'geolocation.dart';
import 'package:intl/intl.dart';

class App extends StatefulWidget {
  const App({super.key});

  @override
  State<StatefulWidget> createState() {
    return AppState();
  }
}

class AppState extends State<App> {
  var mycontroller = TextEditingController();
  WeatherModel? weatherModel;
  Position? position;
  var temp, desc, city, country;
  String deg = '°C';
  String far = '°F';
  String mestemp = "",
      mesdescription = "",
      meslongi = "",
      meslati = "",
      mescity = "",
      mescountry = "";
  var dateTime = DateFormat('dd-MM-yyyy hh:mm a').format(DateTime.now());

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Current Weather Data'),
        ),
        body: Center(
          child: Column(
            //crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              // _________________________________________________________________ Weather image
              Padding(
                padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                child: Center(
                  child: Image.network(
                    'https:${weatherModel?.current?.condition?.icon}',
                    height: 64,
                    width: 64,
                  ),
                ),
              ),

              //______________________________________________________________Show Temperature
              Center(
                child: Text(
                  mestemp,
                  style: const TextStyle(
                    fontSize: 35,
                  ),
                ),
              ),
              //_____________________________________________________________Show Description
              Center(
                child: Text(
                  mesdescription,
                  style: const TextStyle(fontSize: 20),
                ),
              ),
              Column(children: [
                Padding(
                  padding: const EdgeInsets.all(10),
                  child: Column(
                    children: [
                      Text(
                        '$mescity, $mescountry',
                        style: TextStyle(
                            height: 4,
                            fontSize: 24,
                            fontWeight: FontWeight.w400,
                            color: Colors.black),
                      ),
                      textfield(),
                      elevbutton(),
                    ],
                  ),
                ),
              ]),
              // Column(
              //   children: [
              //     Expanded(child: textfield()),
              //     Expanded(child: elevbutton()),
              //   ],
              // ),
              // //Date_______________________________________________________________date
              // Padding(
              //     padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
              //     child: Center(
              //       child: Text(
              //         "Date & Time: ${dateTime ?? 0}",
              //         style: TextStyle(
              //             height: 1,
              //             fontSize: 20,
              //             fontWeight: FontWeight.w400,
              //             color: Colors.black54),
              //       ),
              //     )),
              // // _________________________________________________________________ Humidity
              // Padding(
              //     padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
              //     child: Center(
              //       child: Text(
              //         "Humidity              ${weatherModel?.current?.humidity}%",
              //         style: TextStyle(
              //             height: 1,
              //             fontSize: 20,
              //             fontWeight: FontWeight.w400,
              //             color: Colors.black54),
              //       ),
              //     )),

              // _________________________________________________________________ Sunset & Sunrise
              // Padding(
              //     padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
              //     child: Center(
              //         child: Row(
              //       mainAxisAlignment: MainAxisAlignment.center,
              //       children: [
              //         Text(
              //           "Sunrise: ${formatted(weatherModel?.sys?.sunrise ?? 0)}            Sunset: ${formatted(weatherModel?.sys?.sunset ?? 0)}",
              //           style: TextStyle(
              //               height: 1,
              //               fontSize: 20,
              //               fontWeight: FontWeight.w400,
              //               color: Colors.black54),
              //         ),
              //       ],
              //     ))),
            ],
          ),
        ),
      ),
    );
  }

  // __________________________________________
  String formatted(timeStamp) {
    final DateTime date1 =
        DateTime.fromMillisecondsSinceEpoch(timeStamp * 1000);
    return DateFormat('hh:mm a').format(date1);
  }

//   Widget locbutton() {
//     return Padding(
//       padding: const EdgeInsets.all(10),
//       child: ElevatedButton.icon(
//           onPressed: () async {
//             position = await getLocation();
//             weatherModel = await getWeatherbyloc(
//                 position?.latitude.toString(), position?.longitude.toString());

//             temp = weatherModel?.current?.tempC;
//             desc = weatherModel?.current?.condition;
//             city = weatherModel?.location?.name;
//             country = weatherModel?.location?.country;

//             if (weatherModel != null) {
//               mestemp = temp.toString() + deg;
//               mesdescription = desc.toString();
//               mescity = city.toString();
//               mescountry = country.toString();
//             } else {
//               mestemp = 'Invalid city';
//               mesdescription = 'Invalid city';
//               mescity = 'Input a valid city name';
//               mescountry = '--';
//             }
//             if (position != null) {
//               meslongi = (position?.latitude).toString();
//               meslati = (position?.longitude).toString();
//             } else {
//               meslongi = 'Error';
//               meslati = 'Error';
//             }
//             setState(() {});
//           },
//           style: ElevatedButton.styleFrom(
//               backgroundColor: Color.fromARGB(255, 43, 1, 159),
//               fixedSize: Size.fromHeight(50)),
//           label: const Text(
//             'Location',
//             style: TextStyle(fontSize: 15),
//           ),
//           icon: Icon(Icons.location_pin)),
//     );
//   }

// //Locationview for info
//   Widget locationview() {
//     Widget expandtext(String text) {
//       return Expanded(
//           child: Text(
//         text,
//         textAlign: TextAlign.center,
//         style: TextStyle(fontSize: 18),
//       ));
//     }

//     Widget latloc = Row(
//       children: [
//         expandtext('Latitude--$meslati'),
//         //expandtext(),
//         expandtext('Longitude--$meslongi'),
//         //expandtext(),
//       ],
//     );

//TExtfield for input
  Widget textfield() {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: TextField(
        controller: mycontroller,
        decoration: const InputDecoration(
          border: OutlineInputBorder(),
          labelText: 'Enter City Name',
        ),
      ),
    );
  }

//get weather button
  Widget elevbutton() {
    return Padding(
        padding: EdgeInsets.all(10),
        child: ElevatedButton.icon(
          onPressed: () async {
            weatherModel = await getWeather(mycontroller.text);
            temp = weatherModel?.current?.tempC;
            desc = weatherModel?.current?.condition?.text;
            city = weatherModel?.location?.name;
            country = weatherModel?.location?.country;
            if (weatherModel != null) {
              mestemp = temp.toString() + deg;
              mesdescription = desc.toString();
              mescity = city.toString();
              mescountry = country.toString();
            } else {
              mestemp = 'Invalid city';
              mesdescription = 'Invalid city';
              mescity = 'Input a valid city name';
              mescountry = '--';
            }
            setState(() {});
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Color.fromARGB(255, 4, 166, 96),
            fixedSize: Size.fromHeight(50),
          ),
          label: const Text(
            'Get Weather Info',
            style: TextStyle(fontSize: 15),
          ),
          icon: Icon(Icons.search),
        ));
  }

  getWeather(String city) async {
    final url =
        'http://api.weatherapi.com/v1/current.json?key=1893906a851c461482471305222011&q=$city&aqi=no';
    try {
      var res = await get(Uri.parse(url));
      print(weatherModel?.current?.condition?.icon);
      //print(res.body);
      if (res.statusCode == 200) {
        return WeatherModel.fromJson(json.decode(res.body));
      }
    } catch (e) {
      print(e);
      return null;
    }
  }

  //call by location
  getWeatherbyloc(String? lat, String? lon) async {
    var url =
        "http://api.weatherapi.com/v1/current.json?key=1893906a851c461482471305222011&q=$lat,$lon&aqi=no";

    try {
      final response = await get(Uri.parse(url));
      if (response.statusCode == 200) {
        return WeatherModel.fromJson(json.decode(response.body));
      }
    } catch (e) {
      return null;
    }
  }
}
