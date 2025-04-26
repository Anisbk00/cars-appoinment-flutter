// ignore_for_file: file_names, library_private_types_in_public_api, deprecated_member_use

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class BookAppointmentScreen extends StatefulWidget {
  const BookAppointmentScreen({super.key});

  @override
  _BookAppointmentScreenState createState() => _BookAppointmentScreenState();
}

class _BookAppointmentScreenState extends State<BookAppointmentScreen> with SingleTickerProviderStateMixin {
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

  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
  }

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
            const Icon(Icons.check_circle_outline, size: 64, color: Colors.teal),
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
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
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
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        centerTitle: false,
        title: const Text(
          'Book an Appointment',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w500,
            color: Color.fromARGB(255, 73, 73, 73),
          ),
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFE0F7FA), Color(0xFFF1F8E9)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 10),
                _buildSectionTitle('Select Service'),
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
                      selectedColor: const Color.fromARGB(255, 67, 117, 111),
                      backgroundColor: Colors.white,
                      labelStyle: TextStyle(color: selected ? Colors.white : Colors.black87),
                      elevation: selected ? 4 : 0,
                      pressElevation: 8,
                    );
                  }).toList(),
                ),
                const SizedBox(height: 24),
                _buildSectionTitle('Pick Date & Time'),
                const SizedBox(height: 12),
                Card(
                  color:const Color.fromARGB(255, 109, 163, 155) ,
                  elevation: 4,
                  shadowColor: const Color.fromARGB(255, 67, 117, 111),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      children: [
                        ListTile(
                          leading: const Icon(Icons.calendar_today,color: Colors.white70,),
                          title: Text(
                            _selectedDate == null ? ('Select Date') : DateFormat.yMMMd().format(_selectedDate!),
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
                        const Divider(height: 6),
                        ListTile(
                          leading: const Icon(Icons.access_time,color:Colors.white70),
                          title: Text(
                            _selectedTime == null ? 'Select Time' : _selectedTime!.format(context),
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
                  style: const TextStyle(color: Color(0xFF1D1D1F)),
                  decoration: InputDecoration(
                    hintText: 'Additional notes...',
                    hintStyle: const TextStyle(color: Colors.black38),
                    filled: true,
                    fillColor: Colors.white.withOpacity(0.9),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
                  ),
                ),
                const SizedBox(height: 32),
                ElevatedButton(
                  onPressed: _confirmBooking,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 67, 117, 111),
                    minimumSize: const Size.fromHeight(50),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  ),
                  child: const Text('Confirm Booking', style: TextStyle(fontSize: 16,color: Colors.white70)),
                ),
                const SizedBox(height: 24),
                Center(
                  child: Column(
                    children: [
                      Image.asset('assets/OIP.jpg', height: 100, fit: BoxFit.contain),
                      const SizedBox(height: 16),
                      const Text(
                        'Drive with Confidence',
                        style: TextStyle(color: Colors.black54, fontSize: 16, fontWeight: FontWeight.w600),
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
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: const TextStyle(fontWeight: FontWeight.w500)),
          Text(value, style: const TextStyle(fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.bold,
        color: Color(0xFF1D1D1F),
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
