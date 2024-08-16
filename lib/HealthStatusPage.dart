import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:untitled/health_report_page.dart';

class HealthStatusPage extends StatefulWidget {
  @override
  _HealthStatusPageState createState() => _HealthStatusPageState();
}

class _HealthStatusPageState extends State<HealthStatusPage> {
  List<dynamic> elderInfo = [];
  int currentIndex = 0;

  @override
  void initState() {
    super.initState();
    fetchElders();
  }

  void fetchElders() async {
    try {
      var response = await Dio().get('http://192.168.1.101:8001/elders');
      setState(() {
        elderInfo = response.data;
      });
    } catch (e) {
      print(e);
    }
  }

  void _switchElder() {
    setState(() {
      currentIndex = (currentIndex + 1) % elderInfo.length;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (elderInfo.isEmpty) {
      return Scaffold(
        appBar: AppBar(
          title: Text('健康数据'),
        ),
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    final elder = elderInfo[currentIndex];

    return Scaffold(
      appBar: AppBar(
        title: Text('健康数据'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // 顶部个人信息卡片
            Card(
              child: ListTile(
                leading: CircleAvatar(
                  backgroundImage: NetworkImage(elder['profile_image_url']),
                ),
                title: Text(elder['name']),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('${elder['age']} 岁'),
                    Text('${elder['height']} cm'),
                    Text('${elder['weight']} kg'),
                  ],
                ),
                trailing: IconButton(
                  icon: Icon(Icons.swap_horiz),
                  onPressed: _switchElder,
                ),
              ),
            ),
            SizedBox(height: 20),
            // 我的状态
            Text('我的状态', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            SizedBox(height: 10),
            Expanded(
              child: GridView.count(
                crossAxisCount: 2,
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                children: [
                  _buildStatusCard('步数', '${elder['step_count']} 步', Icons.directions_walk, Colors.blue),
                  _buildStatusCard('血压', '${elder['blood_pressure']} mmHg', Icons.favorite, Colors.red),
                  _buildStatusCard('心率', '${elder['heart_rate']} 次/分', Icons.favorite, Colors.orange),
                  _buildStatusCard('睡眠', '${elder['sleep_duration']} 小时', Icons.bed, Colors.purple),
                ],
              ),
            ),
            SizedBox(height: 20),
            // 我的体检报告
            Text('我的体检报告', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            SizedBox(height: 10),
            Card(
              child: ListTile(
                title: Text('全身体检报告'),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('广安市第三人民医院'),
                    Text('2023/11/23'),
                  ],
                ),
                trailing: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => HealthReportPage(elder: elder),
                      ),
                    );
                  },
                  child: Text('查看'),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusCard(String title, String value, IconData icon, Color color) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 40, color: color),
            SizedBox(height: 10),
            Text(title, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            Text(value, style: TextStyle(fontSize: 16)),
          ],
        ),
      ),
    );
  }
}
