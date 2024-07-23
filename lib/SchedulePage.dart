import 'package:flutter/material.dart';

class SchedulePage extends StatefulWidget {
  @override
  _SchedulePageState createState() => _SchedulePageState();
}

class _SchedulePageState extends State<SchedulePage> {
  final List<Map<String, String>> _schedules = [
    {'time': '08:00', 'event': '吃药'},
    {'time': '12:00', 'event': '午饭'},
    {'time': '18:00', 'event': '晚饭'},
    {'time': '20:00', 'event': '散步'},
  ];

  final TextEditingController _timeController = TextEditingController();
  final TextEditingController _eventController = TextEditingController();

  void _addSchedule() {
    if (_timeController.text.isNotEmpty && _eventController.text.isNotEmpty) {
      setState(() {
        _schedules.add({'time': _timeController.text, 'event': _eventController.text});
      });
      _timeController.clear();
      _eventController.clear();
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
                onPressed: _addSchedule,
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
}
