import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:cars_appointments/Screens/edit_appoinments.dart';

class AppointmentListScreen extends StatefulWidget {
  const AppointmentListScreen({super.key});

  @override
  State<AppointmentListScreen> createState() => _AppointmentListScreenState();
}

class _AppointmentListScreenState extends State<AppointmentListScreen> {
final List<Map<String, String>> _appointments = [
  {
    'service': 'Oil Change',
    'date': 'April 25, 2025',
    'time': '10:30 AM',
  },
  {
    'service': 'Tire Rotation',
    'date': 'April 28, 2025',
    'time': '2:00 PM',
  },
  {
    'service': 'Battery Check',
    'date': 'May 5, 2025',
    'time': '9:00 AM',
  },
  {
    'service': 'Brake Inspection',
    'date': 'May 8, 2025',
    'time': '1:00 PM',
  },
  {
    'service': 'Engine Diagnostics',
    'date': 'May 12, 2025',
    'time': '11:30 AM',
  },
  {
    'service': 'Transmission Service',
    'date': 'May 15, 2025',
    'time': '3:45 PM',
  },
  {
    'service': 'Air Filter Replacement',
    'date': 'May 20, 2025',
    'time': '12:00 PM',
  },
  {
    'service': 'Coolant Flush',
    'date': 'May 22, 2025',
    'time': '4:15 PM',
  },
  {
    'service': 'Wheel Alignment',
    'date': 'May 26, 2025',
    'time': '10:00 AM',
  },
  {
    'service': 'AC Performance Check',
    'date': 'May 30, 2025',
    'time': '2:30 PM',
  },
];


  void _editAppointment(BuildContext context, Map<String, String> appointment) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => EditAppointmentScreen(
          appointment: {
            'service': appointment['service'] ?? '',
            'date': appointment['date'] ?? '',
            'time': appointment['time'] ?? '',
          },
        ),
      ),
    );
  }

  void _confirmCancellation(BuildContext context, int index) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Cancel Appointment'),
        content: const Text('Are you sure you want to cancel this appointment?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('No',style: TextStyle(color: Color.fromARGB(179, 0, 0, 0)),),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() => _appointments.removeAt(index));
              Navigator.of(context).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Appointment canceled')),
              );
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Yes',style: TextStyle(color: Colors.white70),),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const Text(
          'My appointments',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w500,
            color: Color.fromARGB(255, 73, 73, 73),
          ),
        ),
        centerTitle: false,
      ),
      body: _appointments.isEmpty
          ? const Center(child: Text('No appointments available'))
          : Column(
              children: [
                _buildSwipeIndicator(),
                Expanded(
                  child: ListView.builder(
                    itemCount: _appointments.length,
                    itemBuilder: (context, index) => _buildSlidableAppointment(index),
                  ),
                ),
              ],
            ),
    );
  }

  Widget _buildSwipeIndicator() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
        ),
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Icon(Icons.arrow_right_alt, size: 18, color: Colors.blueAccent),
                SizedBox(width: 4),
                Text('Swipe right to Edit', style: TextStyle(fontSize: 12)),
              ],
            ),
            Row(
              children: [
                Text('Swipe left to Delete', style: TextStyle(fontSize: 12)),
                SizedBox(width: 4),
                Icon(Icons.arrow_left, size: 18, color: Colors.redAccent),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSlidableAppointment(int index) {
    final appointment = _appointments[index];

    return Slidable(
      key: ValueKey('${appointment['date']}_${appointment['time']}'),
      startActionPane: ActionPane(
        motion: const DrawerMotion(),
        children: [
          SlidableAction(
            onPressed: (_) => _editAppointment(context, appointment),
            backgroundColor: Colors.blue,
            foregroundColor: Colors.white,
            icon: Icons.edit,
            label: 'Edit',
          ),
        ],
      ),
      endActionPane: ActionPane(
        motion: const DrawerMotion(),
        children: [
          SlidableAction(
            onPressed: (_) => _confirmCancellation(context, index),
            backgroundColor: Colors.red,
            foregroundColor: Colors.white,
            icon: Icons.delete,
            label: 'Delete',
          ),
        ],
      ),
      child: _buildAppointmentCard(appointment),
    );
  }

  Widget _buildAppointmentCard(Map<String, String> appointment) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 3,
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        leading: const CircleAvatar(
          backgroundColor: Color.fromARGB(255, 67, 117, 111),
          child: Icon(Icons.calendar_today, color: Colors.white),
        ),
        title: Text(
          appointment['service'] ?? '',
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
        subtitle: Text('${appointment['date']} at ${appointment['time']}'),
      ),
    );
  }
}
