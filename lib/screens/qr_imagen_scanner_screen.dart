import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';
import 'package:scan/scan.dart';
import '../providers/car_provider.dart';
import 'car_confirmation_screen.dart';

class QRImageScannerScreen extends StatefulWidget {
  const QRImageScannerScreen({super.key});

  @override
  State<QRImageScannerScreen> createState() => _QRImageScannerScreenState();
}

class _QRImageScannerScreenState extends State<QRImageScannerScreen> {
  final ImagePicker _picker = ImagePicker();
  File? _imageFile;
  bool _isProcessing = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    // Mostrar el selector de imágenes automáticamente al abrir la pantalla
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _pickImage();
    });
  }

  Future<void> _pickImage() async {
    try {
      final XFile? pickedFile = await _picker.pickImage(
        source: ImageSource.gallery,
      );

      if (pickedFile != null) {
        setState(() {
          _imageFile = File(pickedFile.path);
          _errorMessage = null;
        });
        _scanQR();
      } else {
        // Usuario canceló la selección
        if (mounted) {
          Navigator.of(context).pop();
        }
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Error al seleccionar la imagen: $e';
      });
    }
  }

  Future<void> _scanQR() async {
    if (_imageFile == null) return;

    setState(() {
      _isProcessing = true;
      _errorMessage = null;
    });

    try {
      final qrCode = await Scan.parse(_imageFile!.path);

      if (qrCode != null && qrCode.isNotEmpty) {
        if (mounted) {
          final carProvider = Provider.of<CarProvider>(context, listen: false);
          final car = await carProvider.fetchCarByQR(qrCode);

          if (car != null) {
            if (mounted) {
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                  builder: (_) => CarConfirmationScreen(car: car),
                ),
              );
            }
          } else {
            setState(() {
              _errorMessage =
                  'Carro no encontrado. Intente con otro código QR.';
              _isProcessing = false;
            });
          }
        }
      } else {
        setState(() {
          _errorMessage = 'No se detectó ningún código QR en la imagen.';
          _isProcessing = false;
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Error al escanear el código QR: $e';
        _isProcessing = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Escanear QR desde imagen'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            if (_imageFile != null)
              Expanded(
                child: Center(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.file(
                      _imageFile!,
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
              )
            else
              const Expanded(
                child: Center(
                  child: Icon(
                    Icons.image_search,
                    size: 100,
                    color: Colors.grey,
                  ),
                ),
              ),
            if (_errorMessage != null)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: Text(
                  _errorMessage!,
                  style: const TextStyle(color: Colors.red),
                  textAlign: TextAlign.center,
                ),
              ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton.icon(
                  icon: const Icon(Icons.image),
                  label: const Text('SELECCIONAR OTRA IMAGEN'),
                  onPressed: _isProcessing ? null : _pickImage,
                ),
                ElevatedButton.icon(
                  icon: const Icon(Icons.close),
                  label: const Text('CERRAR'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.grey,
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ),
            if (_isProcessing)
              const Padding(
                padding: EdgeInsets.only(top: 16.0),
                child: CircularProgressIndicator(),
              ),
          ],
        ),
      ),
    );
  }
}
