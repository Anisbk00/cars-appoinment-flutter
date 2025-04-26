// ignore_for_file: deprecated_member_use, file_names

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';

class TechnicianAgendaPage extends StatefulWidget {
  const TechnicianAgendaPage({super.key});

  @override
  State<TechnicianAgendaPage> createState() => _TechnicianAgendaPageState();
}

class _TechnicianAgendaPageState extends State<TechnicianAgendaPage> {
  final List<Technician> _techs = [
    Technician('John Doe', 'assets/person.jpg', ['Engine', 'Diagnostics'], true),
    Technician('Jane Smith', 'assets/person.jpg', ['Bodywork', 'Paint'], false),
  ];
  Technician? _filterTech;

  final List<Appointment> _appts = [];
  CalendarFormat _format = CalendarFormat.week;
  DateTime _focused = DateTime.now();
  DateTime? _selected;

  @override
  void initState() {
    super.initState();
    _selected = _focused;
    _appts.addAll([
      Appointment('John', DateTime.now().add(const Duration(hours: 2)), 60, 'Oil Change', AppointmentStatus.completed, technician: _techs[0]),
      Appointment('Anis', DateTime.now().add(const Duration(hours: 4)), 90, 'Brakes', AppointmentStatus.confirmed, technician: _techs[1]),
      Appointment('zied', DateTime.now().add(const Duration(hours: 1)), 100, 'AC Service', AppointmentStatus.pending, technician: _techs[0]),
      Appointment('Chtioui', DateTime.now().add(const Duration(hours: 5)), 110, 'Diagnostics', AppointmentStatus.pending, technician: _techs[1]),
    ]);
  }

  List<Appointment> _events(DateTime day) => _appts.where((a) => _isSame(a.time, day) && (_filterTech == null || a.technician == _filterTech)).toList();





  @override
  Widget build(BuildContext context) => Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          'Technician Agenda',
          style: TextStyle(fontWeight: FontWeight.w100, fontSize: 24, color: Color.fromARGB(255, 73, 73, 73)),
        ),
          actions: [
            IconButton(icon: const Icon(Icons.today,color: Color.fromARGB(255, 73, 73, 73),), onPressed: _toToday),
          ],
      ),
        body: Container(
          width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
        ),
          child: Column(children: [
            _buildTechFilter(),
            _buildCalendar(),
            Expanded(child: _buildList()),
          ]),
        ),
      );

  Widget _buildTechFilter() => SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        child: Row(
          children: [
            ChoiceChip(
              label: const Text('All'),
              selected: _filterTech == null,
              onSelected: (_) => setState(() => _filterTech = null),
            ),
            ..._techs.map((t) => Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: ChoiceChip(
                    label: Text(t.name),
                    avatar: CircleAvatar(backgroundImage: AssetImage(t.image)),
                    selected: _filterTech == t,
                    onSelected: (_) => setState(() => _filterTech = t),
                  ),
                )),
          ],
        ),
      );

  Widget _buildCalendar() => TableCalendar(
        firstDay: DateTime.utc(2021, 1, 1),
        lastDay: DateTime.utc(2030, 12, 31),
        focusedDay: _focused,
        calendarFormat: _format,
        selectedDayPredicate: (d) => _isSame(d, _selected!),
        onDaySelected: (s, f) {
          setState(() => _selected = s);
          _focused = f;
        },
        onFormatChanged: (f) => setState(() => _format = f),
        calendarStyle: CalendarStyle(
          todayDecoration: BoxDecoration(color: Theme.of(context).colorScheme.primaryContainer, shape: BoxShape.circle),
          selectedDecoration: BoxDecoration(color: Theme.of(context).colorScheme.primary, shape: BoxShape.circle),
        ),
        eventLoader: _events,
      );

  Widget _buildList() {
    final ev = _events(_selected!);
    if (ev.isEmpty) return const Center(child: Text('No Appointments', style: TextStyle(color: Colors.grey)));
    return ListView.builder(
      itemCount: ev.length,
      itemBuilder: (ctx, i) {
        final a = ev[i];
        return Card(
          margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          child: ListTile(
            leading: const Icon(Icons.build),
            title: Text(a.service),
            subtitle: Text('${DateFormat.jm().format(a.time)} · ${a.technician?.name}'),
            trailing: Chip(label: Text(a.status.name), backgroundColor: a.status.color.withOpacity(0.4)),
            onTap: () => _show(a),
          ),
        );
      },
    );
  }



  void _show(Appointment a) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(a.service),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Client: ${a.clientName}'),
            Text('Time: ${DateFormat.yMMMd().add_jm().format(a.time)}'),
            Text('Duration: ${a.duration} min'),
            Text('Tech: ${a.technician?.name}'),
          ],
        ),
        actions: [TextButton(onPressed: () => Navigator.pop(context), child: const Text('Close'))],
      ),
    );
  }

  void _toToday() => setState(() => _focused = DateTime.now());

  bool _isSame(DateTime a, DateTime b) => a.year == b.year && a.month == b.month && a.day == b.day;
}

class Technician {
  final String name, image;
  final List<String> skills;
  final bool available;
  Technician(this.name, this.image, this.skills, this.available);
}

enum AppointmentStatus { pending, confirmed, completed }

extension AppointmentStatusColor on AppointmentStatus {
  Color get color {
    switch (this) {
      case AppointmentStatus.confirmed:
        return const Color.fromARGB(255, 151, 0, 0);
      case AppointmentStatus.pending:
        return Colors.orange;
      case AppointmentStatus.completed:
        return const Color.fromARGB(255, 66, 153, 48);
    }
  }
}

class Appointment {
  final String clientName, service;
  final DateTime time;
  final int duration;
  final AppointmentStatus status;
  final Technician? technician;
  Appointment(this.clientName, this.time, this.duration, this.service, this.status, {this.technician});
}
