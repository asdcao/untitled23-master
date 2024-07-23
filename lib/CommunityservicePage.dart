import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:untitled/EntrustPage.dart';
import 'package:untitled/FoodrankPage.dart';
import 'CaregiverhirePage.dart';  // 引入新的页面
import 'deliverfoodpage.dart';

class CommunityservicePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('社区服务'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: GridView.count(
          crossAxisCount: 2,
          crossAxisSpacing: 8.0,
          mainAxisSpacing: 8.0,
          children: _buildServiceCards(context),
        ),
      ),
    );
  }

  List<Widget> _buildServiceCards(BuildContext context) {
    return [
      _buildServiceCard('起居照护', 'assets/3.jpg', context),
      _buildServiceCard('委托代办', 'assets/2.jpg', context),
      _buildServiceCard('饮食计划', 'assets/service7.png', context),
      _buildServiceCard('送餐服务', 'assets/service8.png', context),
    ];
  }

  Widget _buildServiceCard(String title, String imagePath, BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (title == '起居照护') {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => CaregiverHirePage()),
          );
        }
        if (title == '委托代办') {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => EntrustPage()),
          );
        }
        if (title == '饮食计划') {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => FoodrankPage()),
          );
        }
        if (title == '疾病预防') {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => FoodrankPage()),
          );
        }
        if (title == '送餐服务') {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) =>DeliverFoodPage() ),
          );
        }
        if (title == '文化娱乐') {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => FoodrankPage()),
          );
        }
      },
      child: Card(
        child: Column(
          children: [
            Expanded(
              child: Image.asset(
                imagePath,
                fit: BoxFit.cover,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                title,
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
