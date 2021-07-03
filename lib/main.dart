import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(new MaterialApp(title: 'Weather app', home: new Application()));
}

class Application extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: Container(
        child: Home(),
      ),
    );
  }
}

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  var temp;
  var description;
  var currently;
  var humidity;
  var windSpeed;
  static final DateTime now = new DateTime.now();
  static final DateTime date = new DateTime(now.year, now.month, now.day);

  Future getWeather() async {
    http.Response response = await http.get(Uri.parse(
        'https://api.openweathermap.org/data/2.5/weather?q=Lagos&units=metric&appid=75286b919e9062641220f939f9214e29'));
    var results = jsonDecode(response.body);
    setState(() {
      this.temp = results['main']['temp'];
      this.description = results['weather'][0]['description'];
      this.currently = results['weather'][0]['main'];
      this.humidity = results['main']['humidity'];
      this.windSpeed = results['wind']['speed'];
    });
  }

  @override
  void initState() {
    super.initState();
    this.getWeather();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        body: Column(
      children: [
        Container(
          height: MediaQuery.of(context).size.height / 3.0,
          width: MediaQuery.of(context).size.width,
          color: Colors.deepOrange,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                  padding: EdgeInsets.only(bottom: 10.0),
                  child: Text('Currently in Lagos',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18.0,
                        fontWeight: FontWeight.w600,
                      ))),
              Text(
                temp != null ? temp.toString() + '\u00B0 C' : 'Loading',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 30.0,
                    fontWeight: FontWeight.w600),
              ),
              Padding(
                  padding: EdgeInsets.only(top: 10.0),
                  child:
                      Text(currently != null ? currently.toString() : 'Loading',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 17.0,
                            fontWeight: FontWeight.w600,
                          ))),
              Text(
                date != null ? date.toString() : 'Loading',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 10.0,
                    fontWeight: FontWeight.w600),
              ),
            ],
          ),
        ),
        Expanded(
            child: Container(
          decoration: BoxDecoration(
              image: DecorationImage(
            image: AssetImage('assets/appimages/sunny.png'),
            fit: BoxFit.cover,
          )),
          child: Padding(
              padding: EdgeInsets.all(20.0),
              child: ListView(
                children: [
                  ListTile(
                    leading: FaIcon(FontAwesomeIcons.thermometerHalf),
                    title: Text('Temperature'),
                    trailing: Text(temp != null
                        ? temp.toString() + '\u00B0 C'
                        : 'Loading'),
                  ),
                  ListTile(
                    leading: FaIcon(FontAwesomeIcons.cloud),
                    title: Text('Weather'),
                    trailing: Text(description != null
                        ? description.toString()
                        : 'Loading'),
                  ),
                  ListTile(
                    leading: FaIcon(FontAwesomeIcons.solidSun),
                    title: Text('Humidity'),
                    trailing: Text(humidity != null
                        ? humidity.toString() + 'g/m \u00B3'
                        : 'Loading'),
                  ),
                  ListTile(
                    leading: FaIcon(FontAwesomeIcons.wind),
                    title: Text('Wind Speed'),
                    trailing: Text(windSpeed != null
                        ? windSpeed.toString() + 'km/h'
                        : 'Loading'),
                  )
                ],
              )),
        ))
      ],
    ));
  }
}
