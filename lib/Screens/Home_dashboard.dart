// ignore_for_file: deprecated_member_use, file_names

import 'package:flutter/material.dart';

class HomeDashboard extends StatelessWidget {
  HomeDashboard({super.key});

  final List<Map<String, String>> vehicleData = [
    {'model': 'Toyota Corolla', 'year': '2020', 'image': 'assets/car1.jpg'},
    {'model': 'Honda Civic', 'year': '2018', 'image': 'assets/car2.jpg'},
    {'model': 'BMW X5', 'year': '2022', 'image': 'assets/car3.jpg'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text("Dashboard", style: TextStyle(color: Colors.white)),
        centerTitle: true,
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF2A4B7C), Color(0xFF1A1A2F)],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Upcoming Appointments
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 20),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Upcoming Appointments',
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                ),
              ),
              Expanded(
                flex: 2,
                child: ListView(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  children: [
                    _appointmentCard(context, 'Feb 23', '10:00 AM', 'Oil Change', 'Jean Dupont'),
                    const SizedBox(height: 16),
                    _appointmentCard(context, 'Feb 25', '2:30 PM', 'General Inspection', 'Marie Curie'),
                  ],
                ),
              ),
              const Divider(color: Colors.white24, height: 1),
              // Vehicles Section
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 20),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'My Vehicles',
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                ),
              ),
              Expanded(
                flex: 1,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: vehicleData.length,
                  separatorBuilder: (_, __) => const SizedBox(width: 16),
                  itemBuilder: (_, index) {
                    final v = vehicleData[index];
                    return _vehicleCard(v['model']!, v['year']!, v['image']!);
                  },
                ),
              ),const SizedBox(height: 20,)
            ],
          ),
        ),
      ),
    );
  }

  Widget _appointmentCard(BuildContext context, String date, String time, String service, String tech) {
    return Card(
      color: Colors.white.withOpacity(0.1),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      child: ListTile(
        contentPadding: const EdgeInsets.all(16),
        leading: const Icon(Icons.calendar_today, color: Colors.white),
        title: Text(service, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        subtitle: Text('$date · $time\nwith $tech', style: const TextStyle(color: Colors.white70)),
        isThreeLine: true,
        trailing: const Icon(Icons.chevron_right, color: Colors.white70),
        onTap: () => _showAppointmentDetails(context, service, tech),
      ),
    );
  }

  Widget _vehicleCard(String model, String year, String image) {
    return SizedBox(
      width: 160,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.asset(image, fit: BoxFit.cover),
            ),
          ),
          const SizedBox(height: 8),
          Text(model, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
          Text('Year: $year', style: const TextStyle(color: Colors.white70, fontSize: 12)),
        ],
      ),
    );
  }

  void _showAppointmentDetails(BuildContext context, String service, String tech) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: const Color(0xFF1A1A2F),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(service, style: const TextStyle(color: Colors.white)),
        content: Text('Technician: $tech', style: const TextStyle(color: Colors.white70)),
        actions: [
          TextButton(
            child: const Text('Close', style: TextStyle(color: Colors.blueAccent)),
            onPressed: () => Navigator.pop(context),
          ),
        ],
      ),
    );
  }
}
