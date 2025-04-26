import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/car.dart';
import '../providers/car_provider.dart';
import 'car_form_screen.dart';

class CarDetailScreen extends StatelessWidget {
  final Car car;

  const CarDetailScreen({super.key, required this.car});

  @override
  Widget build(BuildContext context) {
    final carProvider = Provider.of<CarProvider>(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Detalles del Carro')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      width: 120,
                      height: 120,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade200,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: const Icon(
                        Icons.electric_car,
                        size: 80,
                        color: Colors.blue,
                      ),
                    ),
                    const SizedBox(height: 24),
                    Text(
                      'Placa: ${car.placa}',
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Chip(
                      label: Text(car.isAssigned ? 'Asignado' : 'Disponible'),
                      backgroundColor:
                          car.isAssigned ? Colors.green : Colors.blue,
                      labelStyle: const TextStyle(color: Colors.white),
                    ),
                    const SizedBox(height: 24),
                    const Divider(),
                    const SizedBox(height: 16),
                    _buildInfoRow(Icons.person, 'Conductor', car.conductor),
                    const SizedBox(height: 16),
                    _buildInfoRow(Icons.business, 'Empresa', car.empresa),
                    const SizedBox(height: 24),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        icon: Icon(car.isAssigned ? Icons.logout : Icons.login),
                        label: Text(
                          car.isAssigned ? 'DEVOLVER CARRO' : 'TOMAR CARRO',
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              car.isAssigned ? Colors.orange : Colors.blue,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                        ),
                        onPressed: () {
                          if (car.isAssigned) {
                            // Si ya está asignado, lo devolvemos
                            carProvider.toggleCarAssignment(car.id);
                            Navigator.of(context).pop();
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Carro devuelto correctamente'),
                                backgroundColor: Colors.green,
                              ),
                            );
                          } else {
                            // Si no está asignado, vamos al formulario
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (_) => CarFormScreen(car: car),
                              ),
                            );
                          }
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(icon, color: Colors.blue),
        const SizedBox(width: 16),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: TextStyle(color: Colors.grey.shade600, fontSize: 14),
            ),
            Text(
              value,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ],
    );
  }
}
