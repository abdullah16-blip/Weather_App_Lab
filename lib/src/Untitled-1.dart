import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart';

class homepage extends StatefulWidget {
  const homepage({Key? key}) : super(key: key);

  @override
  State<homepage> createState() => _homepageState();
}

class _homepageState extends State<homepage> {
  @override
  void initState() {
    // TODO: implement initState
    getLocation();
    super.initState();
  }

  var iconId, temperature, description, currentCityName;
  TextEditingController cityNameController = new TextEditingController();
  var lati, longi;

  getWeather() async {
    print("clicked");
    String cityName = cityNameController.text;
    // String cityName = "dhaka";
    final queryparameter = {
      "q": cityName,
      "key": "fab373dba6fa48e39e241801222011"
    };
    Uri uri =
        new Uri.http("api.weatherapi.com", "/v1/current.json", queryparameter);
    final jsonData = await get(uri);
    final json = jsonDecode(jsonData.body);
    print(json);
    setState(() {
      currentCityName = json["location"]["name"];
      temperature = json["current"]["temp_c"];
      description = json["current"]["condition"]["text"];
      iconId = json["current"]["condition"]["icon"];
      iconId = iconId.substring(2);
      iconId = "https://" + iconId;
    });
    print(iconId);
  }

  getLocation() async {
    print("hello 0");
    LocationPermission permission = await Geolocator.requestPermission();
    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
    lati = position.latitude;
    longi = position.longitude;
    final queryparameter = {
      "q": lati,
      "q": longi,
      "key": "fab373dba6fa48e39e241801222011"
    };
    // Uri uri = new Uri.http("api.weatherapi.com","/v1/current.json",queryparameter);
    // final response = await get(uri);
    final response = await get(Uri.parse(
        "http://api.weatherapi.com/v1/current.json?key=fab373dba6fa48e39e241801222011&q=${lati},${longi}&aqi=no"));
    // final response = await get(Uri.encodeFull("api.weatherapi.com","/v1/current.json?key=fab373dba6fa48e39e241801222011&q=23.72,90.41"));
    final json = jsonDecode(response.body);
    // print(json);
    setState(() {
      currentCityName = json["location"]["name"];
      temperature = json["current"]["temp_c"];
      description = json["current"]["condition"]["text"];
      iconId = json["current"]["condition"]["icon"];
      iconId = iconId.substring(2);
      iconId = "https://" + iconId;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
      appBar: AppBar(
        title: Text("Weather App"),
      ),
      body: Center(
        child: Container(
          width: 500,
          height: 800,
          decoration: BoxDecoration(
            border: Border.all(color: Colors.black, width: 4),
            borderRadius: BorderRadius.all(Radius.circular(200)),
          ),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Image.network("http://"+iconId.toString()),
                // Image(image: NetworkImage("https://"+iconId)),
                // NetworkImage(iconId);

                // I tried to add icon but it is not working, I will try this again
                Container(
                  width: 64,
                  height: 64,
                  decoration: BoxDecoration(
                      image: DecorationImage(
                          image: NetworkImage((iconId == null
                                  ? "https://cdn.pixabay.com/photo/2015/04/23/22/00/tree-736885_960_720.jpg"
                                  : iconId)
                              // "https://cdn.weatherapi.com/weather/64x64/day/116.png"
                              // "https://cdn.pixabay.com/photo/2015/04/23/22/00/tree-736885_960_720.jpg"
                              ))),
                ),
                Text((currentCityName == null ? "loading" : currentCityName),
                    style: TextStyle(fontSize: 30)),
                Text(
                  (temperature == null ? "loading" : temperature.toString()) +
                      "\u00B0C",
                  style: TextStyle(fontSize: 40),
                ),
                SizedBox(
                  height: 20,
                ),
                Text(
                  (description == null ? "loading" : description.toString()),
                  style: TextStyle(fontSize: 30),
                ),
                SizedBox(
                  height: 10,
                ),
                SizedBox(
                    width: 300,
                    child: TextField(
                      controller: cityNameController,
                    )),

                SizedBox(
                  height: 30,
                ),
                ElevatedButton(
                  onPressed: getWeather,
                  child: Text(
                    "Search",
                    style: TextStyle(
                      fontSize: 25,
                    ),
                  ),
                ),
                SizedBox(
                  height: 60,
                ),
                ElevatedButton(
                    onPressed: getLocation,
                    child: Text(
                      "Get your Locatoin Weather",
                      style: TextStyle(fontSize: 20),
                    ))
                // this button is for fetch current location
                // ElevatedButton(onPressed: getLocation, child: Text("Get Current Location")),
              ],
            ),
          ),
        ),
      ),
    ));
  }
}
