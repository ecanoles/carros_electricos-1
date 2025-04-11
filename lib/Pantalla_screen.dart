import 'package:flutter/material.dart';
import 'car_list_screen.dart';
import 'qr_scan_screen.dart';

class PantallaScreen extends StatelessWidget {
  const PantallaScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('carros_electricos App')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const CarListScreen(),
                  ),
                );
              },
              child: const Text('Ver mis Carros'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const QrScanScreen()),
                );
              },
              child: const Text('Escanear QR'),
            ),
          ],
        ),
      ),
    );
  }
}
