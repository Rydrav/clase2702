import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../models/car.dart';

class CarProvider with ChangeNotifier {
  List<Car> _cars = [];
  Car? _selectedCar;
  bool _isLoading = false;

  List<Car> get cars => _cars;
  Car? get selectedCar => _selectedCar;
  bool get isLoading => _isLoading;

  // Obtener todos los carros
  Future<void> fetchCars() async {
    _isLoading = true;
    notifyListeners();

    try {
      final response = await http.get(
        Uri.parse('https://67f7d1812466325443eadd17.mockapi.io/carros'),
      );

      if (response.statusCode == 200) {
        final List<dynamic> carsJson = json.decode(response.body);
        _cars = carsJson.map((json) => Car.fromJson(json)).toList();
      } else {
        throw Exception('Error al cargar los carros');
      }
    } catch (e) {
      print('Error: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Obtener un carro por código QR
  Future<Car?> fetchCarByQR(String qrCode) async {
    _isLoading = true;
    notifyListeners();

    try {
      final response = await http.get(
        Uri.parse('https://67f7d1812466325443eadd17.mockapi.io/carros/$qrCode'),
      );

      if (response.statusCode == 200) {
        final carJson = json.decode(response.body);
        _selectedCar = Car.fromJson(carJson);
        return _selectedCar;
      } else {
        throw Exception('Carro no encontrado');
      }
    } catch (e) {
      print('Error: $e');
      return null;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Asignar o desasignar un carro
  void toggleCarAssignment(String carId) {
    final carIndex = _cars.indexWhere((car) => car.id == carId);
    if (carIndex != -1) {
      _cars[carIndex].isAssigned = !_cars[carIndex].isAssigned;
      notifyListeners();
    }
  }

  void clearSelectedCar() {
    _selectedCar = null;
    notifyListeners();
  }
}
