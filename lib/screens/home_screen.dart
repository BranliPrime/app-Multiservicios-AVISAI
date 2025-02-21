import 'package:flutter/material.dart';
import 'calendar_screen.dart';
import 'profile_screen.dart';
import 'notifications_screen.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    final user = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;

    final List<Widget> _screens = [
      HomeContent(user: user),
      CalendarScreen(),
      ProfileScreen(),
      NotificationsScreen(),
    ];

    return Scaffold(
      body: _screens[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.black54,
        showUnselectedLabels: true,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Inicio"),
          BottomNavigationBarItem(icon: Icon(Icons.calendar_today), label: "Calendario"),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "Perfil"),
          BottomNavigationBarItem(icon: Icon(Icons.notifications), label: "Notificaciones"),
        ],
      ),
    );
  }
}

// Contenido principal de la pantalla de inicio
class HomeContent extends StatelessWidget {
  final Map<String, dynamic>? user;

  const HomeContent({Key? key, this.user}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: Text(
          "Biénvenido, ${user?['nombre'] ?? 'Usuario'}!",
          style: const TextStyle(color: Colors.white),
        ),
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(10),
              ),
              child: const TextField(
                decoration: InputDecoration(
                  icon: Icon(Icons.search, color: Colors.grey),
                  hintText: "Buscar",
                  border: InputBorder.none,
                ),
              ),
            ),
            const SizedBox(height: 10),


            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.asset('lib/assets/images/banner.png', fit: BoxFit.cover),
            ),
            const SizedBox(height: 10),

            const Text("Instalaciones programadas",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),

            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                _buildFilterButton("PENDIENTE", Colors.grey),
                const SizedBox(width: 10),
                _buildFilterButton("COMPLETADO", Colors.black),
              ],
            ),
            const SizedBox(height: 10),


            Expanded(
              child: GridView.count(
                crossAxisCount: 2,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                children: [
                  _buildInstallationCard("Instalación de puerta", "lib/assets/images/mapara.png"),
                  _buildInstallationCard("Instalación de ventana", "lib/assets/images/mapara.png"),
                  _buildInstallationCard("Instalación de Mampara", "lib/assets/images/mapara.png"),
                  _buildInstallationCard("Instalación de drywall", "lib/assets/images/mapara.png"),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterButton(String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(text, style: const TextStyle(color: Colors.white)),
    );
  }

  Widget _buildInstallationCard(String title, String imagePath) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(10)),
            child: Image.asset(imagePath, height: 100, width: double.infinity, fit: BoxFit.cover),
          ),
          const SizedBox(height: 5),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
          ),
          const Padding(
            padding: EdgeInsets.only(left: 8, bottom: 8),
            child: Text("Completado", style: TextStyle(color: Colors.grey)),
          ),
        ],
      ),
    );
  }
}
