// ignore_for_file: deprecated_member_use, file_names, library_private_types_in_public_api, camel_case_types

import 'package:cars_appointments/Screens/Book_appoinment.dart';
import 'package:cars_appointments/Screens/Home_dashboard.dart';
import 'package:cars_appointments/Screens/Profil.dart';
import 'package:cars_appointments/Screens/TechnicienAgenda.dart';
import 'package:flutter/material.dart';

class navHome extends StatefulWidget {
  const navHome({super.key});

  @override
  _navHomeState createState() => _navHomeState();
}

class _navHomeState extends State<navHome> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    HomeDashboard(),
    const BookAppointmentScreen(),
    const VehiclesPage(),
    const TechnicianAgendaPage(),
    const ProfileAppointmentsScreen(),
  ];

  void _onNavTap(int index) {
    setState(() => _currentIndex = index);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          'Bonjour, John',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.white),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_outlined, color: Colors.white),
            onPressed: () => _showNotifications(context),
          ),
        ],
      ),
      drawer: _buildSideMenu(),
      body: _pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: _onNavTap,
        type: BottomNavigationBarType.fixed,
        backgroundColor: const Color(0xFF1F2A44),
        selectedItemColor: Colors.teal,
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.dashboard), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.calendar_today), label: 'Appointments'),
          BottomNavigationBarItem(icon: Icon(Icons.directions_car), label: 'Vehicles'),
          BottomNavigationBarItem(icon: Icon(Icons.view_agenda_outlined), label: 'Agenda'),
          BottomNavigationBarItem(icon: Icon(Icons.person_outlined), label: 'Profile'),
        ],
      ),
    );
  }

  Drawer _buildSideMenu() {
    return Drawer(
      child: SafeArea(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(color: Colors.teal),
              child: Text('Menu', style: TextStyle(color: Colors.white, fontSize: 24)),
            ),
            ListTile(
              leading: const Icon(Icons.home),
              title: const Text('Home'),
              onTap: () => _onNavTap(0),
            ),
            ListTile(
              leading: const Icon(Icons.calendar_today),
              title: const Text('Appointments'),
              onTap: () => _onNavTap(1),
            ),
            ListTile(
              leading: const Icon(Icons.directions_car),
              title: const Text('Vehicles'),
              onTap: () => _onNavTap(2),
            ),
            ListTile(
              leading: const Icon(Icons.message),
              title: const Text('Messages'),
              onTap: () => _onNavTap(3),
            ),
            ListTile(
              leading: const Icon(Icons.settings),
              title: const Text('Settings'),
              onTap: () => _onNavTap(4),
            ),
          ],
        ),
      ),
    );
  }

  void _showNotifications(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Notifications'),
        content: const Text('You have no new notifications.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Close'))
        ],
      ),
    );
  }
}

// Placeholder pages
class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) => Center(child: Text('Dashboard', style: Theme.of(context).textTheme.headlineSmall));
}

class AppointmentsPage extends StatelessWidget {
  const AppointmentsPage({super.key});

  @override
  Widget build(BuildContext context) => Center(child: Text('Appointments', style: Theme.of(context).textTheme.headlineSmall));
}

class VehiclesPage extends StatelessWidget {
  const VehiclesPage({super.key});

  @override
  Widget build(BuildContext context) => Center(child: Text('Vehicles', style: Theme.of(context).textTheme.headlineSmall));
}

class MessagesPage extends StatelessWidget {
  const MessagesPage({super.key});

  @override
  Widget build(BuildContext context) => Center(child: Text('Messages', style: Theme.of(context).textTheme.headlineSmall));
}

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) => Center(child: Text('Settings', style: Theme.of(context).textTheme.headlineSmall));
}
