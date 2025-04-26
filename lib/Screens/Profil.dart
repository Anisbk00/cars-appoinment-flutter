// ignore_for_file: file_names, deprecated_member_use, depend_on_referenced_packages, library_private_types_in_public_api
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ProfileAppointmentsScreen extends StatefulWidget {
  const ProfileAppointmentsScreen({super.key});

  @override
  _ProfileAppointmentsScreenState createState() => _ProfileAppointmentsScreenState();
}

class _ProfileAppointmentsScreenState extends State<ProfileAppointmentsScreen> with SingleTickerProviderStateMixin {
  XFile? _profileImage;
  bool _isUrgent = false;
  bool _isEditing = false;

  final picker = ImagePicker();
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 500),
  );
  final Map<String, String> userDetails = {
    'Full Name': 'Samir Pissiron',
    'Email': 'samir.doe@example.com',
    'Phone': '+1 (555) 123-4567',
    'Address': 'Sidi 3mor, lekram',
  };
  final Map<String, String> carDetails = {
    'Model': '103',
    'VIN': '1HGCM82633A123456',
    'Year': '1997',
  };

  late final Map<String, TextEditingController> controllers = {
    for (var k in [...userDetails.keys, ...carDetails.keys])
      k: TextEditingController(text: userDetails[k] ?? carDetails[k] ?? '')
  };

  final appointments = [
    Appointment('2023-08-15', '10:00 AM', 'Oil Change', 'Confirmed', 'AutoCare Center'),
    Appointment('2023-08-20', '2:30 PM', 'Brake Inspection', 'Pending', 'QuickFix Garage'),
  ];

  Future<void> _pickImage() async {
    final file = await picker.pickImage(source: ImageSource.gallery, imageQuality: 70);
    if (file != null) setState(() => _profileImage = file);
  }

  void _toggleEdit() {
    if (_isEditing) {
      userDetails.forEach((k, _) => userDetails[k] = controllers[k]!.text);
      carDetails.forEach((k, _) => carDetails[k] = controllers[k]!.text);
    }
    setState(() => _isEditing = !_isEditing);
  }

  @override
  void dispose() {
    _controller.dispose();
    for (var c in controllers.values) {
      c.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text(
          'Profil',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w500,
            color: Color.fromARGB(255, 73, 73, 73),
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(_isEditing ? Icons.save : Icons.edit, color: const Color.fromARGB(255, 73, 73, 73)),
            onPressed: _toggleEdit,
          )
        ],
      ),
      body: Stack(
        children: [
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                children: [
                  const SizedBox(height: 12),
                  GestureDetector(
                    onTap: _isEditing ?_pickImage:null,
                    child: AnimatedScale(
                      scale: _isEditing ? 1.05 : 1.0,
                      duration: const Duration(milliseconds: 300),
                      child: CircleAvatar(
                        radius: 105,
                        backgroundColor: const Color.fromARGB(255, 67, 117, 111),
                        child: CircleAvatar(
                          radius: 100,
                          backgroundImage: _profileImage != null
                              ? FileImage(File(_profileImage!.path))
                              : const AssetImage('assets/samir.jpg') as ImageProvider,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    userDetails['Full Name'] ?? '',
                    style: theme.textTheme.titleLarge?.copyWith(
                      color: const Color.fromARGB(255, 73, 73, 73),
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 20),
                  // Urgent Status
                  Card(
                    color: _isUrgent ? Colors.redAccent.withOpacity(0.8) : Colors.transparent,
                    child: ListTile(
                      leading: const Icon(Icons.warning, color: Color.fromARGB(255, 73, 73, 73)),
                      title: Text('Urgent Status', style: theme.textTheme.titleMedium?.copyWith(color: const Color.fromARGB(255, 73, 73, 73))),
                      trailing: Switch(
                        value: _isUrgent,
                        onChanged: (val) => setState(() => _isUrgent = val),
                        activeColor:Colors.transparent,
                      ),
                    ),
                  ),

                  _buildInfoSection('Personal Information', userDetails),
                  _buildInfoSection('Vehicle Information', carDetails),

                  Align(
                      alignment: Alignment.centerLeft,
                      child: _sectionHeader('Upcoming Appointments')),

                  ...appointments.map((a) => _buildAppointmentCard(a)),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _sectionHeader(String text) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 16),
        child: Text(
          text,
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w500, color: Color.fromARGB(255, 73, 73, 73)),
        ),
      );

  Widget _buildInfoSection(String title, Map<String, String> data) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _sectionHeader(title),
        ...data.entries.map((e) {
          return Card(
            margin: const EdgeInsets.symmetric(vertical: 4),
            color: _isEditing ? Colors.white10 : const Color.fromARGB(255, 67, 117, 111),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            child: ListTile(
              leading: Icon(_getIcon(e.key), color: Colors.black87),
              title: _isEditing
                  ? TextField(
                      controller: controllers[e.key],
                      style: const TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: e.key,
                        hintStyle: const TextStyle(color: Color.fromARGB(137, 255, 255, 255)),
                      ),
                    )
                  : Text(
                      e.value,
                      style: const TextStyle(color: Color.fromARGB(221, 255, 255, 255)),
                    ),
            ),
          );
        }),
      ],
    );
  }

  Widget _buildAppointmentCard(Appointment a) {
    return Card(
      color: Colors.white70,
      margin: const EdgeInsets.symmetric(vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 2,
      child: ExpansionTile(
        tilePadding: const EdgeInsets.symmetric(horizontal: 16),
        leading: CircleAvatar(
          backgroundColor: Theme.of(context).colorScheme.primary,
          child: const Icon(Icons.build, color: Colors.white),
        ),
        title: Text(a.service, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text('${a.date} • ${a.time}'),
        children: [
          ListTile(
            title: Text('Mechanic: ${a.mechanic}'),
            subtitle: Text('Status: ${a.status}'),
          )
        ],
      ),
    );
  }

  IconData _getIcon(String key) {
    switch (key) {
      case 'Full Name':
        return Icons.person;
      case 'Email':
        return Icons.email;
      case 'Phone':
        return Icons.phone;
      case 'Address':
        return Icons.home;
      case 'Model':
        return Icons.directions_car;
      case 'VIN':
        return Icons.confirmation_number;
      case 'Year':
        return Icons.calendar_today;
      default:
        return Icons.info;
    }
  }
}

class Appointment {
  final String date, time, service, status, mechanic;
  Appointment(this.date, this.time, this.service, this.status, this.mechanic);
}
