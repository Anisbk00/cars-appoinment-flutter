// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';

class TechnicianDashboard extends StatefulWidget {
  const TechnicianDashboard({super.key});

  @override
  _TechnicianDashboardState createState() => _TechnicianDashboardState();
}

class _TechnicianDashboardState extends State<TechnicianDashboard> {
  int _currentIndex = 0;
  final List<Appointment> _pendingAppointments = [
    Appointment(
      id: '1',
      serviceType: 'Oil Change',
      dateTime: DateTime.now().add(const Duration(days: 2)),
      customerName: 'John Doe',
      carModel: 'Toyota Camry 2020',
    ),
    Appointment(
      id: '2',
      serviceType: 'Brake Inspection',
      dateTime: DateTime.now().add(const Duration(days: 3)),
      customerName: 'Sarah Smith',
      carModel: 'Honda Civic 2022',
    ),
  ];

  final List<Appointment> _scheduledAppointments = [
    Appointment(
      id: '3',
      serviceType: 'Tire Rotation',
      dateTime: DateTime.now().add(const Duration(days: 1)),
      customerName: 'Mike Johnson',
      carModel: 'Ford F-150 2021',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tech Dashboard'),
        centerTitle: true,
      ),
      body: _currentIndex == 0
          ? AvailabilityManagementScreen(
              onAvailabilityPublished: (availability) {
                ScaffoldMessenger.of(context)
                  .showSnackBar(const SnackBar(
                    content: Text('Availability published successfully'),
                  ));
              },
            )
          : AppointmentRequestsScreen(
              appointments: _pendingAppointments,
              onAppointmentUpdated: (appointment, accepted) {
                setState(() {
                  _pendingAppointments.remove(appointment);
                  if (accepted) {
                    _scheduledAppointments.add(appointment);
                  }
                });
              },
            ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        onDestinationSelected: (index) => setState(() => _currentIndex = index),
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.calendar_month_outlined),
            selectedIcon: Icon(Icons.calendar_month),
            label: 'Availability',
          ),
          NavigationDestination(
            icon: Icon(Icons.list_alt_outlined),
            selectedIcon: Icon(Icons.list_alt),
            label: 'Requests',
          ),
        ],
      ),
    );
  }
}

class AvailabilityManagementScreen extends StatefulWidget {
  final void Function(Map<DateTime, List<TimeSlot>>) onAvailabilityPublished;

  const AvailabilityManagementScreen({super.key, required this.onAvailabilityPublished});

  @override
  _AvailabilityManagementScreenState createState() => _AvailabilityManagementScreenState();
}

class _AvailabilityManagementScreenState extends State<AvailabilityManagementScreen> {
  late DateTime _selectedDate;
  final Map<DateTime, List<TimeSlot>> _availability = {};

  DateTime _normalizeDate(DateTime date) {
    return DateTime(date.year, date.month, date.day);
  }

  @override
  void initState() {
    super.initState();
    _selectedDate = DateTime.now();
    // Initialize mock available slots for tomorrow
    final tomorrow = _normalizeDate(DateTime.now().add(const Duration(days: 1)));
    _availability[tomorrow] = [
      TimeSlot(
        start: const TimeOfDay(hour: 9, minute: 0),
        end: const TimeOfDay(hour: 10, minute: 0),
      ),
      TimeSlot(
        start: const TimeOfDay(hour: 14, minute: 0),
        end: const TimeOfDay(hour: 15, minute: 0),
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: SingleChildScrollView(
        child: Column(
          children: [
            _buildCalendar(),
            const SizedBox(height: 24),
            _buildTimeSlotsGrid(),
            const SizedBox(height: 24),
            _buildPublishButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildCalendar() {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: Colors.grey.shade200),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: TableCalendar(
          focusedDay: _selectedDate,
          firstDay: DateTime.now(),
          lastDay: DateTime.now().add(const Duration(days: 30)),
          headerStyle: const HeaderStyle(
            formatButtonVisible: false,
            titleCentered: true,
          ),
          calendarStyle: CalendarStyle(
            todayDecoration: BoxDecoration(
              color: Colors.blue.shade100,
              shape: BoxShape.circle,
            ),
            selectedDecoration: const BoxDecoration(
              color: Colors.blue,
              shape: BoxShape.circle,
            ),
          ),
          eventLoader: (day) => _availability[_normalizeDate(day)] ?? [],
          onDaySelected: (selectedDay, focusedDay) {
            setState(() {
              _selectedDate = _normalizeDate(selectedDay);
            });
          },
        ),
      ),
    );
  }

  Widget _buildTimeSlotsGrid() {
    final slots = _availability[_normalizeDate(_selectedDate)] ?? [];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Available Time Slots',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
        ),
        const SizedBox(height: 16),
        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: List.generate(24, (hour) {
            final time = TimeOfDay(hour: hour, minute: 0);
            final isSelected = slots.any((slot) => slot.start.hour == hour);
            return InputChip(
              label: Text(
                time.format(context),
                style: TextStyle(
                  color: isSelected ? Colors.white : Colors.blue,
                ),
              ),
              selected: isSelected,
              onSelected: (_) => _toggleTimeSlot(time),
              selectedColor: Colors.blue,
              showCheckmark: false,
              side: BorderSide(color: Colors.blue.shade100),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            );
          }),
        ),
      ],
    );
  }

  Widget _buildPublishButton() {
    return SizedBox(
      width: double.infinity,
      child: FilledButton.icon(
        icon: const Icon(Icons.cloud_upload_outlined),
        label: const Text('Publish Availability'),
        style: FilledButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        onPressed: () {
          widget.onAvailabilityPublished(_availability);
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Availability published successfully'),
              behavior: SnackBarBehavior.floating,
            ),
          );
        },
      ),
    );
  }

  void _toggleTimeSlot(TimeOfDay time) {
    setState(() {
      final dateKey = _normalizeDate(_selectedDate);
      _availability[dateKey] ??= [];
      final slot = TimeSlot(start: time, end: TimeOfDay(hour: time.hour + 1, minute: 0));
      if (_availability[dateKey]!.any((s) => s.start.hour == time.hour)) {
        _availability[dateKey]!.removeWhere((s) => s.start.hour == time.hour);
      } else {
        _availability[dateKey]!.add(slot);
      }
    });
  }
}

class AppointmentRequestsScreen extends StatelessWidget {
  final List<Appointment> appointments;
  final void Function(Appointment, bool) onAppointmentUpdated;

  const AppointmentRequestsScreen({super.key, required this.appointments, required this.onAppointmentUpdated});

  @override
  Widget build(BuildContext context) {
    if (appointments.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.assignment_outlined, size: 48, color: Colors.grey.shade400),
            const SizedBox(height: 16),
            Text(
              'No pending requests',
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: Colors.grey.shade600,
                  ),
            ),
          ],
        ),
      );
    }
    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: appointments.length,
      separatorBuilder: (_, __) => const SizedBox(height: 16),
      itemBuilder: (context, index) {
        final appointment = appointments[index];
        return _buildAppointmentCard(context, appointment);
      },
    );
  }

  Widget _buildAppointmentCard(BuildContext context, Appointment appointment) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: Colors.grey.shade200),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.blue.shade50,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(Icons.car_repair, color: Colors.blue),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        appointment.serviceType,
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                      ),
                      Text(
                        appointment.carModel,
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            _buildDetailRow(context, Icons.person_outline, appointment.customerName),
            _buildDetailRow(context, Icons.calendar_month_outlined,
                DateFormat('EEE, MMM d • hh:mm a').format(appointment.dateTime)),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    icon: const Icon(Icons.close, size: 18),
                    label: const Text('Reject'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.red,
                      side: const BorderSide(color: Colors.red),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                    onPressed: () => onAppointmentUpdated(appointment, false),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: FilledButton.icon(
                    icon: const Icon(Icons.check, size: 18),
                    label: const Text('Accept'),
                    style: FilledButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                    onPressed: () => onAppointmentUpdated(appointment, true),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(BuildContext context, IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Icon(icon, size: 18, color: Colors.grey),
          const SizedBox(width: 8),
          Text(
            text,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Colors.grey.shade600,
                ),
          ),
        ],
      ),
    );
  }
}

class Appointment {
  final String id;
  final String serviceType;
  final DateTime dateTime;
  final String customerName;
  final String carModel;

  Appointment({
    required this.id,
    required this.serviceType,
    required this.dateTime,
    required this.customerName,
    required this.carModel,
  });
}

class TimeSlot {
  final TimeOfDay start;
  final TimeOfDay end;

  TimeSlot({required this.start, required this.end});
}
