import 'package:flutter/material.dart';
import '../models/car.dart';
import '../providers/car_provider.dart';

class CarFormViewModel with ChangeNotifier {
  final Car car;
  final CarProvider carProvider;
  final TextEditingController observacionesController = TextEditingController();

  bool _llantas = true;
  bool _chasis = true;
  bool _puertas = true;
  bool _isSubmitting = false;
  String? _errorMessage;

  CarFormViewModel({required this.car, required this.carProvider});

  // Getters
  bool get llantas => _llantas;
  bool get chasis => _chasis;
  bool get puertas => _puertas;
  bool get isSubmitting => _isSubmitting;
  String? get errorMessage => _errorMessage;
  bool get isFormValid => _validateForm();

  // Setters que notifican a los listeners
  set llantas(bool value) {
    _llantas = value;
    notifyListeners();
  }

  set chasis(bool value) {
    _chasis = value;
    notifyListeners();
  }

  set puertas(bool value) {
    _puertas = value;
    notifyListeners();
  }

  // Validación del formulario
  bool _validateForm() {
    if (!_llantas || !_chasis || !_puertas) {
      return observacionesController.text.isNotEmpty;
    }
    return true;
  }

  // Método para enviar el formulario
  Future<bool> submitForm() async {
    if (!_validateForm()) {
      _errorMessage =
          'Por favor, ingresa observaciones sobre los problemas encontrados';
      notifyListeners();
      return false;
    }

    _isSubmitting = true;
    _errorMessage = null;
    notifyListeners();

    try {
      // Asignar el carro al usuario
      carProvider.toggleCarAssignment(car.id);

      // Simulamos una operación asíncrona (como guardar en la base de datos)
      await Future.delayed(const Duration(milliseconds: 500));

      _isSubmitting = false;
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = 'Error al procesar la solicitud: $e';
      _isSubmitting = false;
      notifyListeners();
      return false;
    }
  }

  @override
  void dispose() {
    observacionesController.dispose();
    super.dispose();
  }
}
