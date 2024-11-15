import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(WeatherApp());
}

class WeatherApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'App clima do tempo',
      theme: ThemeData(
          primarySwatch: Colors.blue,
          scaffoldBackgroundColor: Colors.lightBlue[50]),
      home: WeatherHomePage(),
    );
  }
}

class WeatherHomePage extends StatefulWidget {
  @override
  _WeatherHomePageState createState() => _WeatherHomePageState();
}

class _WeatherHomePageState extends State<WeatherHomePage> {
  final TextEditingController _controller = TextEditingController();
  String _temperature = '';
  String _description = '';

  Future<void> fetchWeather(String city) async {
    final apiKey = '';
    final url =
        'https://api.openweathermap.org/data/2.5/weather?q=$city&appid=$apiKey&units=metric';

    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      setState(() {
        _temperature = '${data['main']['temp']}°C';
        _description = data['weather'][0]['description'];
      });
    } else {
      setState(() {
        _temperature = 'Erro';
        _description = 'Cidade nao encontrada';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Clima Atual'),
        backgroundColor: Colors.blue[700],
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Consulta de clima',
                style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue[900]),
              ),
              SizedBox(
                height: 20,
              ),
              TextField(
                controller: _controller,
                decoration: InputDecoration(
                  labelText: 'Digite o nome da cidade',
                  labelStyle: TextStyle(color: Colors.blue[700]),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.blue, width: 2),
                      borderRadius: BorderRadius.circular(10.0)),
                  prefixIcon:
                      Icon(Icons.location_city, color: Colors.blue[700]),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue[700],
                  padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
                onPressed: () {
                  fetchWeather(_controller.text);
                },
                child: Text(
                  'Consultar clima',
                  style: TextStyle(fontSize: 18),
                ),
              ),
              SizedBox(
                height: 30,
              ),
              if (_temperature.isNotEmpty && _description.isNotEmpty) ...[
                Icon(
                  Icons.wb_sunny_outlined,
                  size: 80,
                  color: Colors.orange,
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  _temperature,
                  style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  _description,
                  style: TextStyle(
                      fontSize: 24,
                      color: Colors.blue[900],
                      fontStyle: FontStyle.italic),
                )
              ],
              if (_temperature == 'Erro') ...[
                Icon(
                  Icons.error_outline,
                  size: 80,
                  color: Colors.red,
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  _description,
                  style: TextStyle(fontSize: 24, color: Colors.red),
                )
              ]
            ],
          ),
        ),
      ),
    );
  }
}
