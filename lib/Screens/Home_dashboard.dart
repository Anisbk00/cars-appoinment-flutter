// ignore_for_file: deprecated_member_use, file_names

import 'package:flutter/material.dart';

class HomeDashboard extends StatelessWidget {
  HomeDashboard({super.key});

  final List<Map<String, String>> vehicleData = [
    {'model': '103', 'year': '1971', 'image': 'assets/car4.jpg'},
    {'model': 'Fiat Punto', 'year': '1993', 'image': 'assets/car5.jpg'},
    {'model': 'BMW X5', 'year': '2022', 'image': 'assets/car3.jpg'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFB),
            appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Row(
          children: [
            SizedBox(height: 15,),
            CircleAvatar(
              radius: 26,
              backgroundImage: AssetImage('assets/samir.jpg'),
            ),
            SizedBox(width: 10),
            Text(
              'Samir pissiron',
              style: TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 16,
                color: Color(0xFF1D1D1F) ,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_none_outlined, color:Color(0xFF1D1D1F) ),
            onPressed: () => _showNotifications(context),
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _sectionTitle("Upcoming Appointments"),
              const SizedBox(height: 20),
              Expanded(
                flex: 2,
                child: ListView.separated(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: 3,
                  separatorBuilder: (_, __) => const SizedBox(height: 14),
                  itemBuilder: (_, index) {
                    final appointments = [
                      ['Feb 23', '10:00 AM', 'Oil Change', 'Jean Dupont'],
                      ['Feb 25', '2:30 PM', 'General Inspection', 'Marie Curie'],
                      ['Feb 27', '4:00 PM', 'Diagnostic', 'Jean Dupont'],
                    ];
                    final a = appointments[index];
                    return _appointmentCard(context, a[0], a[1], a[2], a[3]);
                  },
                ),
              ),
              const Divider(color: Color(0xFFE0E0E0), height: 32),
              _sectionTitle("My Vehicles"),
              const SizedBox(height: 8),
              SizedBox(
                height: 200,
                child: ListView.separated(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  scrollDirection: Axis.horizontal,
                  itemCount: vehicleData.length,
                  separatorBuilder: (_, __) => const SizedBox(width: 16),
                  itemBuilder: (_, index) {
                    final v = vehicleData[index];
                    return _vehicleCard(v['model']!, v['year']!, v['image']!);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _sectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Center(
        child: Text(
          title,
          style: const TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w700,
            color: Color.fromARGB(255, 73, 73, 73),
          ),
        ),
      ),
    );
  }

  Widget _appointmentCard(BuildContext context, String date, String time, String service, String tech) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        color: const Color.fromARGB(255, 67, 117, 111),
        boxShadow: [
          BoxShadow(
            color: const Color.fromARGB(255, 0, 0, 0).withOpacity(0.25),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: const Color(0xFFE8F0FE),
            borderRadius: BorderRadius.circular(12),
          ),
          child: const Icon(Icons.event_note, color: Color.fromARGB(255, 0, 0, 0), size: 28),
        ),
        title: Text(
          service,
          style: const TextStyle(
            color: Color.fromARGB(255, 255, 255, 255),
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        subtitle: Text(
          '$date · $time\nwith $tech',
          style: const TextStyle(
            color: Color.fromARGB(255, 238, 238, 238),
            height: 1.5,
            fontSize: 13,
          ),
        ),
        isThreeLine: true,
        trailing: const Icon(Icons.arrow_forward_ios, color: Color.fromARGB(255, 255, 255, 255), size: 18),
        onTap: () => _showAppointmentDetails(context, service, tech),
      ),
    );
  }

  Widget _vehicleCard(String model, String year, String image) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(18),
      child: Container(
        width: 170,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF6F6F6F).withOpacity(0.08),
              blurRadius: 12,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Column(
          children: [
            Expanded(
              child: Image.asset(image, fit: BoxFit.cover, width: double.infinity),
            ),
            Container(
              color: const Color.fromARGB(255, 117, 117, 117),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              width: double.infinity,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(model,
                      style: const TextStyle(
                          color: Color.fromARGB(255, 209, 209, 209), fontWeight: FontWeight.bold, fontSize: 14)),
                  Text('Year: $year',
                      style: const TextStyle(
                          color: Color.fromARGB(255, 204, 204, 204), fontSize: 12, height: 1.4)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showAppointmentDetails(BuildContext context, String service, String tech) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(
          service,
          style: const TextStyle(color: Color(0xFF1D1D1F), fontSize: 18),
        ),
        content: Text(
          'Technician: $tech',
          style: TextStyle(color: Colors.grey.shade600),
        ),
        actions: [
          TextButton(
            child: const Text('Close', style: TextStyle(color: Color(0xFF3366FF))),
            onPressed: () => Navigator.pop(context),
          ),
        ],
      ),
    );
  }
    void _showNotifications(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Notifications',
            style: TextStyle(color: Color(0xFF1D1D1F), fontSize: 18, fontWeight: FontWeight.bold)),
        content: const Text('You have no new notifications.',
            style: TextStyle(color: Color(0xFF606060))),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Close', style: TextStyle(color: Color(0xFF3366FF)))),
        ],
      ),
    );
  }
}
