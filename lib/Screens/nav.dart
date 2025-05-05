// ignore_for_file: deprecated_member_use, file_names, library_private_types_in_public_api, camel_case_types

import 'package:cars_appointments/Screens/tech_dashboard.dart';
import 'package:flutter/material.dart';
import 'package:cars_appointments/Screens/Book_appoinment.dart';
import 'package:cars_appointments/Screens/Home_dashboard.dart';
import 'package:cars_appointments/Screens/Profil.dart';
import 'package:cars_appointments/Screens/TechnicienAgenda.dart';
import 'package:cars_appointments/Screens/my_appoinments.dart';

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
    const AppointmentListScreen(),
    const TechnicianAgendaPage(),
    const TechnicianDashboard(),
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
      body: _pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: _onNavTap,
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.transparent,
        selectedItemColor: const Color.fromARGB(255, 67, 117, 111),
        unselectedItemColor: const Color.fromARGB(179, 0, 0, 0),
        selectedFontSize: 16,
        unselectedFontSize: 12,
        iconSize: 24,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.dashboard_outlined), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.calendar_today_outlined), label: 'Services'),
          BottomNavigationBarItem(icon: Icon(Icons.directions_car_outlined), label: 'Appointments'),
          BottomNavigationBarItem(icon: Icon(Icons.view_agenda_outlined), label: 'Agenda'),
          BottomNavigationBarItem(icon: Icon(Icons.dashboard_outlined), label: 'tech dash'),
          BottomNavigationBarItem(icon: Icon(Icons.person_outline), label: 'Profile'),
        ],
      ),
    );
  }
}