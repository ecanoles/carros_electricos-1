import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Car {
  final String id;
  final String placa;
  final String conductor;

  Car({required this.id, required this.placa, required this.conductor});

  factory Car.fromJson(Map<String, dynamic> json) {
    return Car(
      id: json['id'],
      placa: json['placa'] ?? 'N/A',
      conductor: json['conductor'] ?? 'N/A',
    );
  }
}

class CarListScreen extends StatefulWidget {
  const CarListScreen({super.key});

  @override
  _CarListScreenState createState() => _CarListScreenState();
}

class _CarListScreenState extends State<CarListScreen> {
  List<Car> _cars = [];
  bool _isLoading = true;
  String _errorMessage = '';

  @override
  void initState() {
    super.initState();
    _fetchCars();
  }

  Future<void> _fetchCars() async {
    try {
      final response = await http.get(
        Uri.parse('https://67f7d1812466325443eadd17.mockapi.io/carros'),
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        setState(() {
          _cars = data.map((json) => Car.fromJson(json)).toList();
          _isLoading = false;
        });
      } else {
        throw Exception('Failed to load cars');
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Error loading cars: ${e.toString()}';
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Mis Carros')),
      body:
          _isLoading
              ? const Center(child: CircularProgressIndicator())
              : _errorMessage.isNotEmpty
              ? Center(child: Text(_errorMessage))
              : ListView.builder(
                itemCount: _cars.length,
                itemBuilder: (context, index) {
                  final car = _cars[index];
                  return Card(
                    margin: const EdgeInsets.all(8.0),
                    child: ListTile(
                      leading: const Icon(Icons.electric_car, size: 40),
                      title: Text('Placa: ${car.placa}'),
                      subtitle: Text('Conductor: ${car.conductor}'),
                      trailing: const Icon(Icons.arrow_forward),
                    ),
                  );
                },
              ),
    );
  }
}
