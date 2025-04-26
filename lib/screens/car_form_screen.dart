import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/car.dart';
import '../providers/car_provider.dart';
import '../viewmodels/car_form_view_model.dart';

class CarFormScreen extends StatelessWidget {
  final Car car;

  const CarFormScreen({super.key, required this.car});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => CarFormViewModel(
        car: car,
        carProvider: Provider.of<CarProvider>(context, listen: false),
      ),
      child: const _CarFormView(),
    );
  }
}

class _CarFormView extends StatelessWidget {
  const _CarFormView();

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<CarFormViewModel>(context);
    final car = viewModel.car;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Estado del Carro'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Form(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildCarInfoCard(car),
              const SizedBox(height: 24),
              _buildCarStateCard(context, viewModel),
              const SizedBox(height: 24),
              _buildSubmitButton(context, viewModel),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCarInfoCard(Car car) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Información del Carro',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade200,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(
                    Icons.electric_car,
                    size: 40,
                    color: Colors.blue,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Placa: ${car.placa}',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text('Conductor: ${car.conductor}'),
                      const SizedBox(height: 4),
                      Text('Empresa: ${car.empresa}'),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCarStateCard(BuildContext context, CarFormViewModel viewModel) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Estado del Carro',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Por favor, verifica el estado actual del carro:',
              style: TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 16),
            _buildSwitchListTile(
              title: 'Estado de las llantas',
              value: viewModel.llantas,
              onChanged: (value) => viewModel.llantas = value,
            ),
            const Divider(),
            _buildSwitchListTile(
              title: 'Estado del chasis',
              value: viewModel.chasis,
              onChanged: (value) => viewModel.chasis = value,
            ),
            const Divider(),
            _buildSwitchListTile(
              title: 'Estado de las puertas',
              value: viewModel.puertas,
              onChanged: (value) => viewModel.puertas = value,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: viewModel.observacionesController,
              decoration: const InputDecoration(
                labelText: 'Observaciones',
                alignLabelWithHint: true,
                border: OutlineInputBorder(),
                helperText: 'Obligatorio si algún estado es incorrecto',
              ),
              maxLines: 4,
            ),
            if (viewModel.errorMessage != null)
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Text(
                  viewModel.errorMessage!,
                  style: TextStyle(color: Theme.of(context).colorScheme.error),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildSwitchListTile({
    required String title,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return SwitchListTile(
      title: Text(title),
      subtitle: Text(value ? 'Correcto' : 'Incorrecto'),
      value: value,
      activeColor: Colors.green,
      onChanged: onChanged,
    );
  }

  Widget _buildSubmitButton(BuildContext context, CarFormViewModel viewModel) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: viewModel.isSubmitting
            ? null
            : () async {
                final success = await viewModel.submitForm();
                if (success && context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Carro tomado correctamente'),
                      backgroundColor: Colors.green,
                    ),
                  );
                  Navigator.of(context).popUntil((route) => route.isFirst);
                }
              },
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 16),
        ),
        child: viewModel.isSubmitting
            ? const SizedBox(
                height: 20,
                width: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: Colors.white,
                ),
              )
            : const Text('CONFIRMAR Y TOMAR CARRO'),
      ),
    );
  }
}
