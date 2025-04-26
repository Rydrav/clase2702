import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/car.dart';
import '../providers/car_provider.dart';
import 'car_form_screen.dart';

class CarConfirmationScreen extends StatelessWidget {
  final Car car;

  const CarConfirmationScreen({super.key, required this.car});

  @override
  Widget build(BuildContext context) {
    final carProvider = Provider.of<CarProvider>(context);
    final isAssigned = car.isAssigned;

    return Scaffold(
      appBar: AppBar(
        title: Text(isAssigned ? 'Devolver Carro' : 'Tomar Carro'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  children: [
                    const Icon(
                      Icons.electric_car,
                      size: 80,
                      color: Colors.blue,
                    ),
                    const SizedBox(height: 24),
                    Text(
                      isAssigned
                          ? '¿Desea devolver el carro?'
                          : '¿Desea tomar el carro?',
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Placa: ${car.placa}',
                      style: const TextStyle(fontSize: 18),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Conductor: ${car.conductor}',
                      style: const TextStyle(fontSize: 18),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Empresa: ${car.empresa}',
                      style: const TextStyle(fontSize: 18),
                    ),
                    const SizedBox(height: 32),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.grey,
                          ),
                          child: const Text('NO'),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            if (isAssigned) {
                              // Si ya está asignado, lo devolvemos directamente
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
                              Navigator.of(context).pushReplacement(
                                MaterialPageRoute(
                                  builder: (_) => CarFormScreen(car: car),
                                ),
                              );
                            }
                          },
                          child: const Text('SÍ'),
                        ),
                      ],
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
}
