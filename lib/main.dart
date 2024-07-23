import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:untitled/UrgentPopupScreen.dart';
import 'package:untitled/chat_gpt_page.dart';
import 'SchedulePage.dart';
import 'NearbyPage.dart';
import 'LoginPage.dart';
import 'UrgenttackleScreen.dart';
import 'CameraViewScreen.dart';
import 'HealthStatusPage.dart';
import 'CommunityservicePage.dart';

import 'UrgentPopupScreen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '智慧养老',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        appBarTheme: AppBarTheme(
          color: Colors.blue[100],
        ),
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    HomeScreen(),
    CommunityservicePage(),
    CameraViewScreen(),
    LoginPage(),
  ];

  void _onItemTapped(int index) {
    if (index == 3) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => LoginPage()),
      );
    } else {
      setState(() {
        _currentIndex = index;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('智慧养老'),
        centerTitle: true,
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
              child: Text(
                '侧边栏',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
            ),
            ListTile(
              title: Text('选项1'),
              onTap: () {
                // 处理选项1的点击事件
              },
            ),
            ListTile(
              title: Text('选项2'),
              onTap: () {
                // 处理选项2的点击事件
              },
            ),
            // 添加更多的侧边栏选项...
          ],
        ),
      ),
      body: _pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _currentIndex,
        backgroundColor: Colors.blue[100],
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey,
        onTap: _onItemTapped,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: '主页',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.event),
            label: '社区服务',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.videocam),
            label: '摄像头观看',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: '设置',
          ),
        ],
      ),
    );
  }
}

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // 健康文章数据模型
  List<HealthArticle> healthArticles = [
    HealthArticle(
      imageUrl: 'assets/service1.png',
      title: '如何预防老年人骨质疏松',
      content: '骨质疏松是老年人常见的健康问题...',
    ),
    HealthArticle(
      imageUrl: 'assets/service2.png',
      title: '心血管疾病的早期预防与治疗',
      content: '心血管疾病是老年人的主要健康威胁之一...',
    ),
    // 添加更多文章数据
  ];

  // 用于显示完整文章内容的状态
  HealthArticle? _selectedArticle;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 250,
            width: double.infinity,
            child: Image.asset('assets/push.jpg', fit: BoxFit.cover),
          ),
          SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildCircleButton(context, Icons.schedule, '日程安排', SchedulePage()),
              _buildCircleButton(context, Icons.health_and_safety, '老人健康', HealthStatusPage()),
              _buildCircleButton(context, Icons.history, '历史记录', UrgenttackleScreen()),
              _buildCircleButton(context, Icons.location_on, '紧急处理', UrgentPopupScreen()),
              _buildCircleButton(context, Icons.person, '个人中心', LoginPage()),
            ],
          ),
          SizedBox(height: 30),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Text('医养服务', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          ),
          SizedBox(height: 5),
          Padding(
            padding: const EdgeInsets.all(2.0),
            child: GridView.count(
              crossAxisCount: 3,
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              crossAxisSpacing: 6,
              mainAxisSpacing: 0,
              children: [
                _buildServiceButton(context, '', 'assets/11.png', NearbyPage()),
                _buildServiceButton(context, '', 'assets/22.png', ChatGptPage()),
                _buildServiceButton(context, '', 'assets/33.png', HealthStatusPage()),
              ],
            ),
          ),
          SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Text('健康文章推送', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          ),
          SizedBox(height: 10),
          _selectedArticle != null ? _buildHealthArticleCard(_selectedArticle!) : Container(),
          ListView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: healthArticles.length,
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: () {
                  setState(() {
                    _selectedArticle = healthArticles[index];
                  });
                },
                child: Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  margin: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.vertical(top: Radius.circular(10)),
                        child: Image.asset(
                          healthArticles[index].imageUrl,
                          width: double.infinity,
                          height: 150,
                          fit: BoxFit.cover,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.all(8),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              healthArticles[index].title,
                              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                            SizedBox(height: 4),
                            Text(
                              healthArticles[index].content,
                              style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildCircleButton(BuildContext context, IconData icon, String label, Widget? page) {
    return Column(
      children: [
        InkWell(
          onTap: () {
            if (page != null) {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => page),
              );
            }
          },
          child: Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: Colors.lightBlueAccent,
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: Colors.white, size: 20),
          ),
        ),
        SizedBox(height: 8),
        Text(label, style: TextStyle(fontSize: 10)),
      ],
    );
  }

  Widget _buildServiceButton(BuildContext context, String label, String assetPath, Widget? page) {
    return Column(
      children: [
        InkWell(
          onTap: () {
            if (page != null) {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => page),
              );
            }
          },
          child: Container(
            width: double.infinity,
            height: 70,
            decoration: BoxDecoration(
              color: Colors.blue[100],
              borderRadius: BorderRadius.circular(10),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.asset(assetPath, fit: BoxFit.cover),
            ),
          ),
        ),
        SizedBox(height: 8),
        Text(label, style: TextStyle(fontSize: 10)),
      ],
    );
  }

  Widget _buildHealthArticleCard(HealthArticle article) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      margin: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.vertical(top: Radius.circular(10)),
            child: Image.asset(
              article.imageUrl,
              width: double.infinity,
              height: 150,
              fit: BoxFit.cover,
            ),
          ),
          Padding(
            padding: EdgeInsets.all(8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  article.title,
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 4),
                Text(
                  article.content,
                  style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class HealthArticle {
  final String imageUrl;
  final String title;
  final String content;

  HealthArticle({
    required this.imageUrl,
    required this.title,
    required this.content,
  });
}