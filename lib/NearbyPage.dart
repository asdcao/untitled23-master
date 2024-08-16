import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'hospital_detail_page.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: NearbyPage(),
    );
  }
}

class NearbyPage extends StatefulWidget {
  @override
  _NearbyPageState createState() => _NearbyPageState();
}

class _NearbyPageState extends State<NearbyPage> {
  List<Hospital> hospitals = [];
  String _selectedSort = '按评分排序';
  bool isLoading = true;  // 添加一个加载状态

  @override
  void initState() {
    super.initState();
    fetchHospitals();
  }

  Future<void> fetchHospitals() async {
    final response = await http.get(Uri.parse('http://192.168.1.101:8001/hospitals/'));

    if (response.statusCode == 200) {
      List<dynamic> data = jsonDecode(response.body);
      setState(() {
        hospitals = data.map((json) => Hospital.fromJson(json)).toList();
        _sortHospitals();
        isLoading = false;  // 数据加载完成
      });
    } else {
      throw Exception('Failed to load hospitals');
    }
  }

  void _sortHospitals() {
    setState(() {
      if (_selectedSort == '按评分排序') {
        hospitals.sort((a, b) => b.rating.compareTo(a.rating));
      } else if (_selectedSort == '按距离排序') {
        hospitals.sort((a, b) => a.distance.compareTo(b.distance));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('预约挂号'),
        backgroundColor: Colors.blue,
      ),
      body: isLoading ? Center(child: CircularProgressIndicator()) : Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              decoration: InputDecoration(
                hintText: '搜索医院/医生',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('排序:'),
                DropdownButton<String>(
                  value: _selectedSort,
                  items: <String>['按评分排序', '按距离排序']
                      .map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    setState(() {
                      _selectedSort = newValue!;
                      _sortHospitals();
                    });
                  },
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: hospitals.length,
              itemBuilder: (context, index) {
                final hospital = hospitals[index];
                return HospitalCard(hospital: hospital);
              },
            ),
          ),
        ],
      ),
    );
  }
}

class HospitalCard extends StatelessWidget {
  final Hospital hospital;

  const HospitalCard({required this.hospital});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: Icon(Icons.local_hospital),
        title: Text(hospital.name),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('评分: ${hospital.rating}'),
            Text('地址: ${hospital.address}'),
          ],
        ),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              '${hospital.distance} km',
              style: TextStyle(color: Colors.yellow),
            ),
            Icon(Icons.arrow_forward_ios),
          ],
        ),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => HospitalDetailPage(hospital: hospital),
            ),
          );
        },
      ),
    );
  }
}

class Hospital {
  final String name;
  final double rating;
  final double distance;
  final String address;
  final String imageUrl;

  Hospital({
    required this.name,
    required this.rating,
    required this.distance,
    required this.address,
    required this.imageUrl,
  });

  factory Hospital.fromJson(Map<String, dynamic> json) {
    return Hospital(
      name: json['name'],
      rating: json['rating'],
      distance: json['distance'],
      address: json['address'],
      imageUrl: json['image_url'],
    );
  }
}
