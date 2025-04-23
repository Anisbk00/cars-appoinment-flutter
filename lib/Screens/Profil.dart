// ignore_for_file: file_names, deprecated_member_use, depend_on_referenced_packages, library_private_types_in_public_api
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shimmer/shimmer.dart';

class ProfileAppointmentsScreen extends StatefulWidget {
  const ProfileAppointmentsScreen({super.key});

  @override
  _ProfileAppointmentsScreenState createState() => _ProfileAppointmentsScreenState();
}

class _ProfileAppointmentsScreenState extends State<ProfileAppointmentsScreen> {
  XFile? _profileImage;
  bool _isUrgent = false;
  bool _isEditing = false;

  final picker = ImagePicker();
  final Map<String, String> userDetails = {
    'Full Name': 'John Doe',
    'Email': 'john.doe@example.com',
    'Phone': '+1 (555) 123-4567',
    'Address': '123 Main St, Cityville',
  };
  final Map<String, String> carDetails = {
    'Model': 'Toyota Camry',
    'VIN': '1HGCM82633A123456',
    'Year': '2020',
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
      // save
      userDetails.forEach((k, _) => userDetails[k] = controllers[k]!.text);
      carDetails.forEach((k, _) => carDetails[k] = controllers[k]!.text);
    }
    setState(() => _isEditing = !_isEditing);
  }

  @override
  void dispose() {
    for (var c in controllers.values) {
      c.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text('Profile', style: Theme.of(context).textTheme.headlineLarge?.copyWith(color: Colors.white)),
        actions: [
          IconButton(
            icon: Icon(_isEditing ? Icons.save : Icons.edit, color: Colors.white),
            onPressed: _toggleEdit,
          )
        ],
      ),
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF3A6EA5), Color(0xFF1F2A44)],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
              child: Column(
                children: [
                  // Profile Photo
                  Stack(
                    children: [
                      CircleAvatar(
                        radius: 60,
                        backgroundColor: Colors.grey.shade200,
                        backgroundImage: _profileImage != null
                            ? FileImage(File(_profileImage!.path))
                            : const AssetImage('assets/person.jpg') as ImageProvider,
                        onBackgroundImageError: (_, __) => debugPrint("Failed to load asset image"),
                      ),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: InkWell(
                          onTap: _pickImage,
                          borderRadius: BorderRadius.circular(18),
                          child: const CircleAvatar(
                            radius: 18,
                            backgroundColor: Colors.white,
                            child: Icon(Icons.camera_alt, color: Colors.black87, size: 20),
                          ),
                        ),
                      ),
                      if (_profileImage == null)
                        Positioned.fill(
                          child: IgnorePointer(
                            ignoring: true,
                            child: Shimmer.fromColors(
                              baseColor: Colors.grey.shade300,
                              highlightColor: Colors.grey.shade100,
                              child: const CircleAvatar(radius: 60, backgroundColor: Colors.transparent),
                            ),
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    userDetails['Full Name']!,
                    style: Theme.of(context)
                        .textTheme
                        .titleLarge
                        ?.copyWith(color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 24),

                  // Urgent Toggle
                  Card(
                    color: _isUrgent ? Colors.redAccent : Colors.amber,
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    child: SwitchListTile(
                      title: const Text('Urgent Status', style: TextStyle(color: Colors.white)),
                      secondary: const Icon(Icons.warning, color: Colors.white),
                      value: _isUrgent,
                      onChanged: (v) => setState(() => _isUrgent = v),
                    ),
                  ),

                  // Info Sections
                  _buildInfoSection('Personal Information', userDetails),
                  _buildInfoSection('Vehicle Information', carDetails),

                  // Appointments
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
        child: Text(text, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white70)),
      );

  Widget _buildInfoSection(String title, Map<String, String> data) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _sectionHeader(title),
          ...data.entries.map((e) {
            return Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              elevation: 2,
              child: ListTile(
                leading: Icon(_getIcon(e.key), color: Colors.blueAccent),
                title: _isEditing
                    ? TextField(
                        controller: controllers[e.key],
                        decoration: InputDecoration(border: InputBorder.none, hintText: e.key),
                      )
                    : Text(e.value),
              ),
            );
          })
        ],
      );

  Widget _buildAppointmentCard(Appointment a) => Card(
        margin: const EdgeInsets.symmetric(vertical: 8),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        elevation: 3,
        child: ListTile(
          contentPadding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
          leading: CircleAvatar(
              backgroundColor: Theme.of(context).colorScheme.primary,
              child: const Icon(Icons.build, color: Colors.white)),
          title: Text(a.service, style: const TextStyle(fontWeight: FontWeight.bold)),
          subtitle: Text('${a.date} • ${a.time}'),
          trailing: Chip(
            label: Text(a.status),
            backgroundColor: a.status == 'Confirmed' ? Colors.green.shade100 : Colors.orange.shade100,
          ),
          onTap: () {},
        ),
      );

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
