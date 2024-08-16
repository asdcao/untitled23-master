import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class SchedulePage extends StatefulWidget {
  @override
  _SchedulePageState createState() => _SchedulePageState();
}

class _SchedulePageState extends State<SchedulePage> {
  final List<Map<String, String>> _schedules = [];
  final TextEditingController _timeController = TextEditingController();
  final TextEditingController _eventController = TextEditingController();
  bool _isButtonEnabled = false;

  @override
  void initState() {
    super.initState();
    _fetchSchedules();
    _timeController.addListener(_updateButtonState);
    _eventController.addListener(_updateButtonState);
  }

  void _updateButtonState() {
    setState(() {
      _isButtonEnabled = _timeController.text.isNotEmpty && _eventController.text.isNotEmpty;
    });
  }

  void _fetchSchedules() async {
    try {
      final response = await http.post(
        Uri.parse('http://192.168.1.101:8001/day_click/'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'day': '2024-07-28'}),
      );

      if (response.statusCode == 200) {
        final List<dynamic> events = jsonDecode(response.body)['events'];
        setState(() {
          _schedules.clear();
          for (var event in events) {
            _schedules.add({
              'time': event['event_time'],
              'event': event['event_name'],
            });
          }
        });
      } else {
        print('Failed to load schedules: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching schedules: $e');
    }
  }

  void _addSchedule() async {
    if (_timeController.text.isNotEmpty && _eventController.text.isNotEmpty) {
      try {
        final response = await http.post(
          Uri.parse('http://192.168.1.101:8001/event_add/'),
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode({
            'event_name': _eventController.text,
            'event_detail': 'test',
            'event_day': '2024-07-28',
            'event_time': _timeController.text,
          }),
        );

        if (response.statusCode == 201) {
          setState(() {
            _schedules.add({'time': _timeController.text, 'event': _eventController.text});
            _timeController.clear();
            _eventController.clear();
          });
        } else {
          print('Failed to add schedule: ${response.statusCode}');
        }
      } catch (e) {
        print('Error adding schedule: $e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('日程管理'),
        backgroundColor: Colors.blue,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '日程安排',
              style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16.0),
            Expanded(
              child: ListView.builder(
                itemCount: _schedules.length,
                itemBuilder: (context, index) {
                  final schedule = _schedules[index];
                  return Card(
                    child: ListTile(
                      leading: Icon(Icons.access_time, color: const Color.fromARGB(255, 76, 120, 175)),
                      title: Text('${schedule['time']} - ${schedule['event']}'),
                    ),
                  );
                },
              ),
            ),
            Divider(height: 32.0, thickness: 2.0),
            Text(
              '添加新日程',
              style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8.0),
            _buildTextField('时间 (如: 08:00)', _timeController),
            _buildTextField('事件 (如: 吃药)', _eventController),
            SizedBox(height: 16.0),
            Center(
              child: ElevatedButton(
                onPressed: _isButtonEnabled ? _addSchedule : null,
                child: Text('添加'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 76, 114, 175),
                  padding: EdgeInsets.symmetric(horizontal: 32.0, vertical: 16.0),
                  textStyle: TextStyle(fontSize: 16.0),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          border: OutlineInputBorder(),
          labelText: label,
        ),
      ),
    );
  }

  @override
  void dispose() {
    _timeController.dispose();
    _eventController.dispose();
    super.dispose();
  }
}
