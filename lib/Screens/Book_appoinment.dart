// ignore_for_file: deprecated_member_use, library_private_types_in_public_api, file_names

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class BookAppointmentScreen extends StatefulWidget {
  const BookAppointmentScreen({super.key});

  @override
  _BookAppointmentScreenState createState() => _BookAppointmentScreenState();
}

class _BookAppointmentScreenState extends State<BookAppointmentScreen> {
  final List<Service> _services = [
    Service('Oil Change', Icons.local_car_wash, 49.99),
    Service('Tire Rotation', Icons.settings, 39.99),
    Service('Brake Check', Icons.car_repair, 89.99),
    Service('AC Service', Icons.ac_unit, 79.99),
    Service('Battery Check', Icons.battery_charging_full, 29.99),
    Service('Diagnostics', Icons.computer, 99.99),
  ];

  Service? _selectedService;
  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;
  final TextEditingController _notesController = TextEditingController();

  void _confirmBooking() {
    if (_selectedService == null || _selectedDate == null || _selectedTime == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please complete all fields')),
      );
      return;
    }

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
          top: 24,
          left: 24,
          right: 24,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.check_circle, size: 64, color: Colors.green),
            const SizedBox(height: 16),
            const Text('Appointment Confirmed!',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            _detailRow('Service', _selectedService!.name),
            _detailRow('Date', DateFormat.yMMMd().format(_selectedDate!)),
            _detailRow('Time', _selectedTime!.format(context)),
            _detailRow('Price', '\$${_selectedService!.price.toStringAsFixed(2)}'),
            if (_notesController.text.isNotEmpty)
              _detailRow('Notes', _notesController.text),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () => Navigator.pop(context),
              style: ElevatedButton.styleFrom(
                minimumSize: const Size.fromHeight(48),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              child: const Text('Done', style: TextStyle(fontSize: 16)),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: false,
        title: const Text(
          'Book an appointment ?',
          style: TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: 17,
            color: Color.fromARGB(255, 255, 255, 255),
          ),
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF2A4B7C), Color(0xFF1A1A2F)],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 5),
                const Text('Select Service',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white)),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 12,
                  runSpacing: 12,
                  children: _services.map((s) {
                    final selected = s == _selectedService;
                    return ChoiceChip(
                      label: Text(s.name),
                      avatar: Icon(s.icon, color: selected ? Colors.white : Colors.black54),
                      selected: selected,
                      onSelected: (_) => setState(() => _selectedService = s),
                      selectedColor: Colors.green,
                      backgroundColor: Colors.white,
                      labelStyle: TextStyle(color: selected ? Colors.white : Colors.black87),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 24),
                const Text('Pick Date & Time',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white)),
                const SizedBox(height: 12),
                Card(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      children: [
                        ListTile(
                          leading: const Icon(Icons.calendar_today),
                          title: Text(
                            _selectedDate == null
                                ? 'Select Date'
                                : DateFormat.yMMMd().format(_selectedDate!),
                          ),
                          onTap: () async {
                            final date = await showDatePicker(
                              context: context,
                              initialDate: DateTime.now(),
                              firstDate: DateTime.now(),
                              lastDate: DateTime.now().add(const Duration(days: 60)),
                            );
                            if (date != null) setState(() => _selectedDate = date);
                          },
                        ),
                        ListTile(
                          leading: const Icon(Icons.access_time),
                          title: Text(
                            _selectedTime == null
                                ? 'Select Time'
                                : _selectedTime!.format(context),
                          ),
                          onTap: () async {
                            final time = await showTimePicker(
                              context: context,
                              initialTime: TimeOfDay.now(),
                            );
                            if (time != null) setState(() => _selectedTime = time);
                          },
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                TextFormField(
                  controller: _notesController,
                  maxLines: 4,
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    hintText: 'Additional notes...',
                    hintStyle: const TextStyle(color: Colors.white70),
                    filled: true,
                    fillColor: Colors.white.withOpacity(0.1),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                ),
                const SizedBox(height: 32),
                ElevatedButton(
                  onPressed: _confirmBooking,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    minimumSize: const Size.fromHeight(48),
                    shape: const StadiumBorder(),
                  ),
                  child: const Text('Confirm Booking', style: TextStyle(fontSize: 16)),
                ),
                const SizedBox(height: 24),
                // Bottom Logo
                Center(
                  child: Column(
                    children: [
                      Image.asset(
                        'assets/OIP.jpg',
                        height: 100,
                        fit: BoxFit.contain,
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        'Drive with Confidence',
                        style: TextStyle(color: Colors.white70, fontSize: 14),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _detailRow(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [Text(title), Text(value, style: const TextStyle(fontWeight: FontWeight.bold))],
      ),
    );
  }
}

class Service {
  final String name;
  final IconData icon;
  final double price;

  Service(this.name, this.icon, this.price);
}
