// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class EditAppointmentScreen extends StatefulWidget {
  final Map<String, dynamic> appointment;

  const EditAppointmentScreen({super.key, required this.appointment});

  @override
  _EditAppointmentScreenState createState() => _EditAppointmentScreenState();
}

class _EditAppointmentScreenState extends State<EditAppointmentScreen> {
  late String selectedService;
  late DateTime selectedDate;
  late TimeOfDay selectedTime;
  bool notify = false;

  final List<String> services = [
  'Oil Change',
  'Tire Rotation',
  'Battery Check',
  'Brake Inspection',
  'Engine Diagnostics',
  'Transmission Service',
  'Air Filter Replacement',
  'Coolant Flush',
  'Wheel Alignment',
  'AC Performance Check',
  'Spark Plug Replacement',
  'Suspension Check',
  'Timing Belt Replacement',
  'Windshield Wiper Replacement',
  'Car Wash and Detailing',
  'Headlight Restoration',
  'Fuel System Cleaning',
  'Exhaust System Repair',
  'Tire Balancing',
  'Alignment Check'
];

  @override
  void initState() {
    super.initState();
    selectedService = widget.appointment['service'];

    selectedDate = DateFormat('MMMM d, yyyy').parse(widget.appointment['date']);
    // Parsing time
    selectedTime = TimeOfDay(
      hour: int.parse(widget.appointment['time'].split(":")[0]),
      minute: int.parse(widget.appointment['time'].split(":")[1].split(" ")[0]),
    );
    notify = widget.appointment['notify'] ?? false;
  }

  Future<void> _pickDate() async {
    DateTime? date = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );
    if (date != null) setState(() => selectedDate = date);
  }

  Future<void> _pickTime() async {
    TimeOfDay? time = await showTimePicker(
      context: context,
      initialTime: selectedTime,
    );
    if (time != null) setState(() => selectedTime = time);
  }

  void _saveAppointment() {
    // Here you would normally update to backend
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Appointment updated")),
    );
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Appointment'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            DropdownButtonFormField<String>(
              value: selectedService,
              items: services.map((service) {
                return DropdownMenuItem(value: service, child: Text(service));
              }).toList(),
              onChanged: (value) => setState(() => selectedService = value!),
              decoration: const InputDecoration(labelText: 'Service Type'),
            ),
            const SizedBox(height: 16),
            ListTile(
              title: Text('Date: ${selectedDate.toLocal().toString().split(' ')[0]}'),
              trailing: const Icon(Icons.calendar_today),
              onTap: _pickDate,
            ),
            ListTile(
              title: Text('Time: ${selectedTime.format(context)}'),
              trailing: const Icon(Icons.access_time),
              onTap: _pickTime,
            ),
            SwitchListTile(
              value: notify,
              onChanged: (val) => setState(() => notify = val),
              title: const Text('Notify Me'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _saveAppointment,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromARGB(255, 38, 117, 30),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              child: const Text('Save Changes',style: TextStyle(color: Colors.white70),),
            )
          ],
        ),
      ),
    );
  }
}
