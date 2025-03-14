import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'login.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Row(
          children: [
            Icon(Icons.electric_car, color: Colors.blue),
            SizedBox(width: 8),
            Text('Volticar', style: TextStyle(fontWeight: FontWeight.bold)),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const LoginScreen()),
              );
            },
            child: const Text('Iniciar sesión'),
          ),
          ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue,
              foregroundColor: Colors.white,
            ),
            child: const Text('Registrarse'),
          ),
          const SizedBox(width: 16),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.grey.shade100,
                    Colors.grey.shade200,
                  ],
                ),
              ),
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Gestiona tus carros eléctricos de manera sencilla y eficiente',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      height: 1.2,
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Volticar te permite asignar, monitorear y mantener tu flota de vehículos eléctricos con facilidad.',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.black54,
                    ),
                  ),
                  const SizedBox(height: 24),
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () {},
                          icon: const Icon(Icons.arrow_forward),
                          label: const Text('Comenzar ahora'),
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            backgroundColor: Colors.blue,
                            foregroundColor: Colors.white,
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () {},
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                          ),
                          child: const Text('Conocer más'),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 32),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.asset(
                      'assets/images/carro_electrico.webp',
                      width: double.infinity,
                      height: 200,
                      fit: BoxFit.cover,
                    ),
                  ),
                ],
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
                  const Text(
                    'Acerca de Volticar',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Volticar es una plataforma integral para la gestión de flotas de vehículos eléctricos empresariales. Nuestra solución permite asignar carros a empleados, registrar el estado del vehículo (llantas, chasis, puertas) y realizar un seguimiento detallado mediante tecnología de escaneo QR.',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.black54,
                      height: 1.5,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),

            Container(
              color: Colors.grey.shade100,
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
                  const Text(
                    'Características principales',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Descubre cómo Volticar simplifica la gestión de tu flota de vehículos eléctricos',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.black54,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 24),
                  const FeatureCard(
                    icon: Icons.qr_code,
                    title: 'Escaneo QR',
                    description: 'Identifica rápidamente cada vehículo mediante códigos QR, facilitando el registro y seguimiento.',
                  ),
                  const SizedBox(height: 16),
                  const FeatureCard(
                    icon: Icons.assignment,
                    title: 'Registro detallado',
                    description: 'Documenta el estado de llantas, chasis, puertas y añade observaciones específicas para cada vehículo.',
                  ),
                  const SizedBox(height: 16),
                  const FeatureCard(
                    icon: Icons.people,
                    title: 'Asignación a empleados',
                    description: 'Gestiona fácilmente qué empleado utiliza cada vehículo y mantén un historial completo de asignaciones.',
                  ),
                  const SizedBox(height: 16),
                  const FeatureCard(
                    icon: Icons.battery_charging_full,
                    title: 'Control de carga',
                    description: 'Monitorea el estado de carga de la batería y programa recargas de manera eficiente.',
                  ),
                  const SizedBox(height: 16),
                  const FeatureCard(
                    icon: Icons.electric_car,
                    title: 'Historial completo',
                    description: 'Accede al historial completo de cada vehículo, incluyendo mantenimientos, incidencias y asignaciones.',
                  ),
                ],
              ),
            ),

            Container(
              color: Colors.blue,
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
                  const Text(
                    'Comienza a gestionar tu flota hoy mismo',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Únete a las empresas que ya optimizan la gestión de sus vehículos eléctricos con Volticar',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white70,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                      backgroundColor: Colors.white,
                      foregroundColor: Colors.blue,
                    ),
                    child: const Text('Solicitar demostración'),
                  ),
                  const SizedBox(height: 12),
                  OutlinedButton(
                    onPressed: () {},
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                      side: const BorderSide(color: Colors.white),
                      foregroundColor: Colors.white,
                    ),
                    child: const Text('Contactar con ventas'),
                  ),
                ],
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Lo que dicen nuestros clientes',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Descubre cómo Volticar ha transformado la gestión de flotas eléctricas en diferentes empresas',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.black54,
                    ),
                  ),
                  const SizedBox(height: 24),
                  const TestimonialCard(
                    name: 'María Rodríguez',
                    position: 'Gerente de Flota, Empresa Energía Verde',
                    testimonial: '"Volticar ha simplificado enormemente nuestra gestión de vehículos eléctricos. El sistema de escaneo QR y el registro detallado nos permiten mantener un control preciso de nuestra flota."',
                  ),
                  const SizedBox(height: 16),
                  const TestimonialCard(
                    name: 'Carlos Méndez',
                    position: 'Director de Operaciones, Transportes Eléctricos S.A.',
                    testimonial: '"Desde que implementamos Volticar, hemos reducido los tiempos de asignación de vehículos y mejorado el mantenimiento preventivo. Una herramienta indispensable para nuestra operación diaria."',
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: const Footer(),
    );
  }
}

class FeatureCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;

  const FeatureCard({
    Key? key,
    required this.icon,
    required this.title,
    required this.description,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: Colors.blue, size: 24),
                const SizedBox(width: 12),
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              description,
              style: const TextStyle(
                fontSize: 14,
                color: Colors.black54,
                height: 1.5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class TestimonialCard extends StatelessWidget {
  final String name;
  final String position;
  final String testimonial;

  const TestimonialCard({
    Key? key,
    required this.name,
    required this.position,
    required this.testimonial,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  backgroundColor: Colors.grey.shade200,
                  child: const Icon(Icons.person, color: Colors.grey),
                ),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      position,
                      style: const TextStyle(
                        fontSize: 12,
                        color: Colors.black54,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              testimonial,
              style: const TextStyle(
                fontSize: 14,
                color: Colors.black54,
                fontStyle: FontStyle.italic,
                height: 1.5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class Footer extends StatelessWidget {
  const Footer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16),
      color: Colors.grey.shade200,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.electric_car, color: Colors.blue, size: 20),
              SizedBox(width: 8),
              Text(
                'Volticar',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            '© ${DateTime.now().year} Volticar. Todos los derechos reservados.',
            style: const TextStyle(
              fontSize: 12,
              color: Colors.black54,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}