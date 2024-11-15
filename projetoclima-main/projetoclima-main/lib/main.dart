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
        scaffoldBackgroundColor: Colors.lightBlue[50], // Cor do fundo
        textTheme: TextTheme(
          headline1: TextStyle(fontSize: 36, fontWeight: FontWeight.bold, color: Colors.blue[800]),
          bodyText1: TextStyle(fontSize: 18, color: Colors.blue[700]),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            primary: Colors.blue[700], // Cor do botão
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(25), // Bordas arredondadas
            ),
            padding: EdgeInsets.symmetric(vertical: 15, horizontal: 30),
          ),
        ),
      ),
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
  String _humidity = '';
  String _windSpeed = '';
  bool _isLoading = false;

  Future<void> fetchWeather(String city) async {
    setState(() {
      _isLoading = true;
    });

    final apiKey = 'SUA_API_KEY'; // Insira sua chave da API aqui
    final url =
        'https://api.openweathermap.org/data/2.5/weather?q=$city&appid=$apiKey&units=metric';

    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      setState(() {
        _temperature = '${data['main']['temp']}°C';
        _description = data['weather'][0]['description'];
        _humidity = '${data['main']['humidity']}%';
        _windSpeed = '${data['wind']['speed']} km/h';
        _isLoading = false;
      });
    } else {
      setState(() {
        _temperature = 'Erro';
        _description = 'Cidade não encontrada';
        _isLoading = false;
      });
    }
  }

  Widget _buildBackgroundImage(String description) {
    if (description.contains('clear')) {
      return Image.asset('assets/sunny.jpg', fit: BoxFit.cover);
    } else if (description.contains('rain')) {
      return Image.asset('assets/rainy.jpg', fit: BoxFit.cover);
    } else {
      return Image.asset('assets/cloudy.jpg', fit: BoxFit.cover);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Clima Atual'),
        backgroundColor: Colors.blue[700],
      ),
      body: Stack(
        children: [
          _buildBackgroundImage(_description), // Função para adicionar o fundo
          Center(
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
                      color: Colors.blue[900],
                    ),
                  ),
                  SizedBox(height: 20),
                  TextField(
                    controller: _controller,
                    decoration: InputDecoration(
                      labelText: 'Digite o nome da cidade',
                      labelStyle: TextStyle(color: Colors.blue[700]),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20.0),
                        borderSide: BorderSide(color: Colors.blue[700]!, width: 2),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.blue, width: 2),
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                      prefixIcon: Icon(Icons.location_city, color: Colors.blue[700]),
                      filled: true,
                      fillColor: Colors.white,
                    ),
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      fetchWeather(_controller.text);
                    },
                    child: Text(
                      'Consultar clima',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ),
                  SizedBox(height: 30),
                  if (_isLoading) 
                    CircularProgressIndicator() // Exibe o indicador de carregamento
                  else if (_temperature.isNotEmpty && _description.isNotEmpty) ...[
                    Icon(
                      Icons.wb_sunny_outlined,
                      size: 80,
                      color: Colors.orange,
                    ),
                    SizedBox(height: 10),
                    Text(
                      _temperature,
                      style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 10),
                    Text(
                      _description,
                      style: TextStyle(fontSize: 24, fontStyle: FontStyle.italic, color: Colors.blue[900]),
                    ),
                    SizedBox(height: 20),
                    Text(
                      'Umidade: $_humidity',
                      style: TextStyle(fontSize: 20),
                    ),
                    SizedBox(height: 10),
                    Text(
                      'Vento: $_windSpeed',
                      style: TextStyle(fontSize: 20),
                    ),
                  ],
                  if (_temperature == 'Erro') ...[
                    Icon(
                      Icons.error_outline,
                      size: 80,
                      color: Colors.red,
                    ),
                    SizedBox(height: 10),
                    Text(
                      _description,
                      style: TextStyle(fontSize: 24, color: Colors.red),
                    )
                  ]
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
