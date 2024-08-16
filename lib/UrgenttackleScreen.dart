import 'package:flutter/material.dart';
import 'package:dio/dio.dart';

class UrgenttackleScreen extends StatefulWidget {
  @override
  _UrgenttackleScreenState createState() => _UrgenttackleScreenState();
}

class _UrgenttackleScreenState extends State<UrgenttackleScreen> {
  List<Map<String, dynamic>> emergencyRecords = [];
  String _searchText = '';
  String _selectedType = '所有类型';
  String _selectedStatus = '所有状态';

  @override
  void initState() {
    super.initState();
    fetchEmergencyRecords();
  }

  void fetchEmergencyRecords() async {
    try {
      var response = await Dio().get('http://192.168.1.101:8001/emergency_records/');
      setState(() {
        emergencyRecords = List<Map<String, dynamic>>.from(response.data);
      });
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('紧急处理记录'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            _buildSearchAndFilter(),
            Expanded(
              child: ListView.builder(
                itemCount: _filteredRecords().length,
                itemBuilder: (context, index) {
                  return _buildEmergencyCard(_filteredRecords()[index]);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<Map<String, dynamic>> _filteredRecords() {
    return emergencyRecords.where((record) {
      final matchSearchText = _searchText.isEmpty ||
          record['type'].toLowerCase().contains(_searchText.toLowerCase());
      final matchType = _selectedType == '所有类型' || record['type'] == _selectedType;
      final matchStatus = _selectedStatus == '所有状态' || record['status'] == _selectedStatus;
      return matchSearchText && matchType && matchStatus;
    }).toList();
  }

  Widget _buildSearchAndFilter() {
    return Column(
      children: [
        TextField(
          decoration: InputDecoration(
            labelText: '搜索事件类型',
            border: OutlineInputBorder(),
            suffixIcon: Icon(Icons.search),
          ),
          onChanged: (value) {
            setState(() {
              _searchText = value;
            });
          },
        ),
        SizedBox(height: 10),
        Row(
          children: [
            Expanded(
              child: DropdownButton<String>(
                value: _selectedType,
                items: <String>['所有类型', '跌倒', '心率异常']
                    .map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    _selectedType = newValue!;
                  });
                },
              ),
            ),
            SizedBox(width: 10),
            Expanded(
              child: DropdownButton<String>(
                value: _selectedStatus,
                items: <String>['所有状态', '已处理', '未处理']
                    .map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    _selectedStatus = newValue!;
                  });
                },
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildEmergencyCard(Map<String, dynamic> record) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 8.0),
      child: ExpansionTile(
        title: Text(record['time']),
        subtitle: Text('${record['type']} - ${record['location']}'),
        children: [
          ListTile(
            title: Text('描述: ${record['description']}'),
            subtitle: Text('详情: ${record['details']}'),
            trailing: Text('状态: ${record['status']}'),
          ),
        ],
      ),
    );
  }
}
