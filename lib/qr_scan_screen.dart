import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class CarDetail {
  final String id;
  final String placa;
  final String conductor;

  CarDetail({required this.id, required this.placa, required this.conductor});

  factory CarDetail.fromJson(Map<String, dynamic> json) {
    return CarDetail(
      id: json['id'],
      placa: json['placa'] ?? 'N/A',
      conductor: json['conductor'] ?? 'N/A',
    );
  }
}

class QrScanScreen extends StatefulWidget {
  const QrScanScreen({super.key});

  @override
  _QrScanScreenState createState() => _QrScanScreenState();
}

class _QrScanScreenState extends State<QrScanScreen> {
  MobileScannerController cameraController = MobileScannerController();
  bool _isLoading = false;
  CarDetail? _scannedCar;
  String _errorMessage = '';

  @override
  void dispose() {
    cameraController.dispose();
    super.dispose();
  }

  Future<void> _fetchCarByQr(String qrCode) async {
    setState(() {
      _isLoading = true;
      _errorMessage = '';
      _scannedCar = null;
    });

    try {
      final response = await http.get(
        Uri.parse('https://67f7d1812466325443eadd17.mockapi.io/carros/$qrCode'),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          _scannedCar = CarDetail.fromJson(data);
          _isLoading = false;
        });
      } else {
        throw Exception('Car not found');
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Error: ${e.toString()}';
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Escanear QR'),
        actions: [
          IconButton(
            icon: const Icon(Icons.flash_on),
            onPressed: () => cameraController.toggleTorch(),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            flex: 4,
            child: MobileScanner(
              controller: cameraController,
              onDetect: (capture) {
                if (_isLoading || _scannedCar != null) {
                  return; // Evita múltiples lecturas
                }
                try {
                  final List<Barcode> barcodes = capture.barcodes;
                  if (barcodes.isNotEmpty) {
                    final String? qrValue = barcodes.first.rawValue;
                    if (qrValue != null) {
                      _fetchCarByQr(qrValue);
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content: Text('QR no contiene datos válidos')),
                      );
                    }
                  }
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                        content: Text('Error al escanear: ${e.toString()}')),
                  );
                }
              },
            ),
          ),
          Expanded(flex: 2, child: _buildResultSection()),
        ],
      ),
    );
  }

  Widget _buildResultSection() {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_errorMessage.isNotEmpty) {
      return Center(child: Text(_errorMessage));
    }

    if (_scannedCar != null) {
      return Card(
        margin: const EdgeInsets.all(16.0),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.electric_car, size: 50),
              const SizedBox(height: 10),
              Text(
                'Placa: ${_scannedCar!.placa}',
                style: const TextStyle(fontSize: 18),
              ),
              Text('Conductor: ${_scannedCar!.conductor}'),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () => setState(() {
                  _scannedCar = null;
                  _errorMessage = '';
                }),
                child: const Text('Cerrar escaneo'),
              ),
            ],
          ),
        ),
      );
    }

    return const Center(
      child: Text('Escanea el código QR de un carro eléctrico'),
    );
  }
}
