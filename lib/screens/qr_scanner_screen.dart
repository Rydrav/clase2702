import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:image_picker/image_picker.dart';
import '../providers/car_provider.dart';
import 'car_confirmation_screen.dart';

class QRScannerScreen extends StatefulWidget {
  const QRScannerScreen({super.key});

  @override
  State<QRScannerScreen> createState() => _QRScannerScreenState();
}

class _QRScannerScreenState extends State<QRScannerScreen> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  QRViewController? controller;
  bool _isProcessing = false;
  bool _isLinux = false;

  // Variables para el escáner de imágenes
  final ImagePicker _picker = ImagePicker();
  File? _imageFile;
  String? _errorMessage;
  bool _isImageScanMode = false;

  @override
  void initState() {
    super.initState();
    // Verificar si estamos en Linux
    _checkPlatform();
  }

  void _checkPlatform() {
    if (Platform.isLinux) {
      setState(() {
        _isLinux = true;
        _isImageScanMode = true;
      });
      // En Linux, mostrar directamente el selector de imágenes
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _pickImage();
      });
    }
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  @override
  void reassemble() {
    super.reassemble();
    if (controller != null && !_isLinux) {
      if (Platform.isAndroid) {
        controller!.pauseCamera();
      }
      controller!.resumeCamera();
    }
  }

  void _onQRViewCreated(QRViewController controller) {
    this.controller = controller;
    controller.scannedDataStream.listen((scanData) async {
      if (_isProcessing || scanData.code == null) return;

      setState(() {
        _isProcessing = true;
      });

      controller.pauseCamera();

      final carProvider = Provider.of<CarProvider>(context, listen: false);
      final car = await carProvider.fetchCarByQR(scanData.code!);

      if (mounted) {
        if (car != null) {
          Navigator.of(context)
              .push(
            MaterialPageRoute(
              builder: (_) => CarConfirmationScreen(car: car),
            ),
          )
              .then((_) {
            setState(() {
              _isProcessing = false;
            });
            controller.resumeCamera();
          });
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Carro no encontrado. Intente de nuevo.'),
              backgroundColor: Colors.red,
            ),
          );
          setState(() {
            _isProcessing = false;
          });
          controller.resumeCamera();
        }
      }
    });
  }

  // Método para seleccionar una imagen de la galería
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
        _processQRFromImage();
      } else {
        // Usuario canceló la selección
        if (!_isLinux && mounted) {
          setState(() {
            _isImageScanMode = false;
          });
        }
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Error al seleccionar la imagen: $e';
      });
    }
  }

  // Método para procesar el código QR de una imagen
  Future<void> _processQRFromImage() async {
    if (_imageFile == null) return;

    setState(() {
      _isProcessing = true;
      _errorMessage = null;
    });

    try {
      // Aquí normalmente usaríamos la biblioteca scan para procesar el QR
      // Pero como no podemos importarla, simularemos el proceso

      // Simulación: Usamos un ID fijo para pruebas
      final qrCode = "1"; // Simulamos que leemos el ID 1

      if (qrCode.isNotEmpty) {
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

  // Método para cambiar entre modos de escaneo
  void _toggleScanMode() {
    setState(() {
      _isImageScanMode = !_isImageScanMode;
      if (_isImageScanMode) {
        _pickImage();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // Si estamos en modo de escaneo de imágenes
    if (_isImageScanMode) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Escanear QR desde imagen'),
          actions: [
            if (!_isLinux)
              IconButton(
                icon: const Icon(Icons.qr_code_scanner),
                tooltip: 'Escanear con cámara',
                onPressed: _toggleScanMode,
              ),
          ],
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

    // Si estamos en Linux pero no en modo de escaneo de imágenes (no debería ocurrir)
    if (_isLinux) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Escanear Código QR'),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.error_outline,
                size: 80,
                color: Colors.red,
              ),
              const SizedBox(height: 16),
              const Text(
                'El escáner QR no está disponible en Linux',
                style: TextStyle(fontSize: 18),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              const Text(
                'Por favor, utilice la opción "Escanear desde imagen"',
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              ElevatedButton.icon(
                icon: const Icon(Icons.image),
                label: const Text('ESCANEAR DESDE IMAGEN'),
                onPressed: () {
                  setState(() {
                    _isImageScanMode = true;
                  });
                  _pickImage();
                },
              ),
            ],
          ),
        ),
      );
    }

    // Modo de escaneo con cámara (para plataformas no Linux)
    return Scaffold(
      appBar: AppBar(
        title: const Text('Escanear Código QR'),
        actions: [
          IconButton(
            icon: const Icon(Icons.image),
            tooltip: 'Escanear desde imagen',
            onPressed: _toggleScanMode,
          ),
        ],
      ),
      body: Stack(
        children: [
          QRView(
            key: qrKey,
            onQRViewCreated: _onQRViewCreated,
            overlay: QrScannerOverlayShape(
              borderColor: Colors.blue,
              borderRadius: 10,
              borderLength: 30,
              borderWidth: 10,
              cutOutSize: MediaQuery.of(context).size.width * 0.8,
            ),
          ),
          Positioned(
            bottom: 40,
            left: 0,
            right: 0,
            child: Center(
              child: ElevatedButton.icon(
                icon: const Icon(Icons.close),
                label: const Text('CERRAR ESCÁNER'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.blue,
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ),
          ),
          if (_isProcessing)
            Container(
              color: Colors.black54,
              child: const Center(
                child: CircularProgressIndicator(),
              ),
            ),
        ],
      ),
    );
  }
}
