import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(FoodrankPage());
}

class FoodrankPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '营养排行榜',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: NutritionPage(),
    );
  }
}

class NutritionPage extends StatefulWidget {
  @override
  _NutritionPageState createState() => _NutritionPageState();
}

class _NutritionPageState extends State<NutritionPage> {
  final List<String> _nutrients = [
    '蛋白质',
    '脂肪',
    '碳水化合物',
    '膳食纤维',
    '维生素A',
    '胡萝卜素',
    '维生素B1',
    '维生素B2',
    '维生素C',
    '维生素E',
    '烟酸',
  ];

  Map<String, List<Map<String, String>>> _foodRanking = {};
  int _selectedIndex = 0;
  String _searchQuery = '';
  bool _isAscending = true;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchNutrients();
  }

  Future<void> fetchNutrients() async {
    final response = await http.get(Uri.parse('http://192.168.1.101:8001/nutrients/'));

    if (response.statusCode == 200) {
      Map<String, dynamic> data = jsonDecode(utf8.decode(response.bodyBytes));
      setState(() {
        _foodRanking = data.map((key, value) => MapEntry(
          key,
          (value as List).map((item) => Map<String, String>.from(item)).toList()
        ));
        _isLoading = false;
      });
    } else {
      throw Exception('Failed to load nutrients');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('营养排行榜'),
        actions: [
          IconButton(
            icon: Icon(_isAscending ? Icons.arrow_upward : Icons.arrow_downward),
            onPressed: () {
              setState(() {
                _isAscending = !_isAscending;
              });
            },
          ),
          IconButton(
            icon: Icon(Icons.list),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => DailyPlanPage(selectedFoods: [], recipes: {}),
                ),
              );
            },
          ),
        ],
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(48.0),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              decoration: InputDecoration(
                hintText: '搜索食物...',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.search),
              ),
              onChanged: (query) {
                setState(() {
                  _searchQuery = query;
                });
              },
            ),
          ),
        ),
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : Row(
              children: [
                NavigationRail(
                  selectedIndex: _selectedIndex,
                  onDestinationSelected: (int index) {
                    setState(() {
                      _selectedIndex = index;
                    });
                  },
                  labelType: NavigationRailLabelType.all,
                  destinations: _nutrients
                      .map((nutrient) => NavigationRailDestination(
                            icon: Icon(Icons.local_dining),
                            selectedIcon: Icon(Icons.local_dining),
                            label: Text(nutrient),
                          ))
                      .toList(),
                ),
                Expanded(
                  child: _buildFoodRanking(_nutrients[_selectedIndex]),
                ),
              ],
            ),
    );
  }

  Widget _buildFoodRanking(String nutrient) {
    final List<Map<String, String>> ranking = _foodRanking[nutrient] ?? [];
    List<Map<String, String>> filteredRanking = ranking
        .where((food) => food['name']!.contains(_searchQuery))
        .toList();

    filteredRanking.sort((a, b) {
      double aValue = double.tryParse(a['value']!.replaceAll(RegExp(r'[^0-9.]'), '')) ?? 0;
      double bValue = double.tryParse(b['value']!.replaceAll(RegExp(r'[^0-9.]'), '')) ?? 0;
      return _isAscending ? aValue.compareTo(bValue) : bValue.compareTo(aValue);
    });

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ListView.builder(
        itemCount: filteredRanking.length,
        itemBuilder: (BuildContext context, int index) {
          return Card(
            child: ListTile(
              leading: CircleAvatar(
                child: Text('${index + 1}'),
              ),
              title: Text(filteredRanking[index]['name']!),
              trailing: Text('${filteredRanking[index]['value']}'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => FoodDetailPage(food: filteredRanking[index], recipes: {}),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}

class FoodDetailPage extends StatelessWidget {
  final Map<String, String> food;
  final Map<String, List<Map<String, String>>> recipes;

  FoodDetailPage({required this.food, required this.recipes});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, String>> foodRecipes = recipes[food['name']] ?? [];

    return Scaffold(
      appBar: AppBar(
        title: Text(food['name']!),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('食物名称: ${food['name']}', style: TextStyle(fontSize: 18)),
            SizedBox(height: 8),
            Text('营养含量: ${food['value']}', style: TextStyle(fontSize: 18)),
            SizedBox(height: 16),
            Text('推荐菜谱:', style: TextStyle(fontSize: 18)),
            SizedBox(height: 8),
            Expanded(
              child: ListView.builder(
                itemCount: foodRecipes.length,
                itemBuilder: (BuildContext context, int index) {
                  return Card(
                    child: ListTile(
                      title: Text(foodRecipes[index]['name']!),
                      subtitle: Text(foodRecipes[index]['description']!),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class DailyPlanPage extends StatelessWidget {
  final List<Map<String, String>> selectedFoods;
  final Map<String, List<Map<String, String>>> recipes;

  DailyPlanPage({required this.selectedFoods, required this.recipes});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('每日饮食计划'),
      ),
      body: ListView.builder(
        itemCount: selectedFoods.length,
        itemBuilder: (BuildContext context, int index) {
          final food = selectedFoods[index];
          final List<Map<String, String>> foodRecipes = recipes[food['name']] ?? [];
          
          return Card(
            child: ExpansionTile(
              leading: CircleAvatar(
                child: Text('${index + 1}'),
              ),
              title: Text(food['name']!),
              subtitle: Text('${food['value']}'),
              children: foodRecipes.map((recipe) {
                return ListTile(
                  title: Text(recipe['name']!),
                  subtitle: Text(recipe['description']!),
                );
              }).toList(),
            ),
          );
        },
      ),
    );
  }
}
