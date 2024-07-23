import 'package:flutter/material.dart';

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

  final Map<String, List<Map<String, String>>> _foodRanking = {
    '蛋白质': [
      {'name': '鸡胸肉', 'value': '32.1g'},
      {'name': '牛排', 'value': '31.1g'},
      {'name': '三文鱼', 'value': '25.4g'},
      {'name': '金枪鱼', 'value': '29.9g'},
      {'name': '豆腐', 'value': '17.3g'},
      {'name': '扁豆', 'value': '9g'},
      {'name': '鸡蛋', 'value': '12.6g'},
      {'name': '乳清蛋白粉', 'value': '79g'},
      {'name': '奶酪', 'value': '25g'},
      {'name': '希腊酸奶', 'value': '10g'},
    ],
    '脂肪': [
      {'name': '肥牛肉', 'value': '45.1g'},
      {'name': '猪肋排', 'value': '39.2g'},
      {'name': '羊肋排', 'value': '35.6g'},
      {'name': '奶油', 'value': '81.1g'},
      {'name': '坚果', 'value': '49.9g'},
      {'name': '巧克力', 'value': '32.4g'},
      {'name': '芝士', 'value': '33.3g'},
      {'name': '火腿', 'value': '30.9g'},
      {'name': '香肠', 'value': '27.4g'},
      {'name': '黄油', 'value': '81.0g'},
    ],
    '碳水化合物': [
      {'name': '白米', 'value': '77.6g'},
      {'name': '面条', 'value': '74.1g'},
      {'name': '土豆', 'value': '17.6g'},
      {'name': '红薯', 'value': '20.1g'},
      {'name': '燕麦片', 'value': '66.3g'},
      {'name': '面包', 'value': '49.4g'},
      {'name': '玉米', 'value': '74.3g'},
      {'name': '小米', 'value': '72.9g'},
      {'name': '麦片', 'value': '66.6g'},
      {'name': '冬瓜', 'value': '4.3g'},
    ],
    '膳食纤维': [
      {'name': '燕麦', 'value': '10.6g'},
      {'name': '全麦面包', 'value': '6.9g'},
      {'name': '红薯', 'value': '3g'},
      {'name': '苹果', 'value': '2.4g'},
      {'name': '胡萝卜', 'value': '2.8g'},
      {'name': '豌豆', 'value': '5.1g'},
      {'name': '扁豆', 'value': '7.9g'},
      {'name': '糙米', 'value': '3.5g'},
      {'name': '花椰菜', 'value': '2.6g'},
      {'name': '菠菜', 'value': '2.2g'},
    ],
    '维生素A': [
      {'name': '胡萝卜', 'value': '835µg'},
      {'name': '红薯', 'value': '709µg'},
      {'name': '菠菜', 'value': '469µg'},
      {'name': '甘蓝', 'value': '681µg'},
      {'name': '南瓜', 'value': '426µg'},
      {'name': '鸡蛋', 'value': '149µg'},
      {'name': '奶酪', 'value': '263µg'},
      {'name': '鱼肝油', 'value': '30000µg'},
      {'name': '牛肝', 'value': '6582µg'},
      {'name': '杏', 'value': '96µg'},
    ],
    '维生素B1': [
      {'name': '猪肉', 'value': '0.9mg'},
      {'name': '全麦面包', 'value': '0.5mg'},
      {'name': '燕麦', 'value': '0.4mg'},
      {'name': '豌豆', 'value': '0.4mg'},
      {'name': '菠菜', 'value': '0.1mg'},
      {'name': '鸡蛋', 'value': '0.1mg'},
      {'name': '牛奶', 'value': '0.04mg'},
      {'name': '杏仁', 'value': '0.6mg'},
      {'name': '鳗鱼', 'value': '0.2mg'},
      {'name': '小麦胚芽', 'value': '2.0mg'},
    ],
    '维生素C': [
      {'name': '冬枣', 'value': '243mg'},
      {'name': '沙棘', 'value': '204mg'},
      {'name': '青枣', 'value': '200mg'},
      {'name': '彩椒', 'value': '104mg'},
      {'name': '苋菜', 'value': '76mg'},
      {'name': '大辣椒', 'value': '72mg'},
      {'name': '百香果', 'value': '70mg'},
      {'name': '番石榴', 'value': '68mg'},
    ],
    '维生素E': [
      {'name': '杏仁', 'value': '25.6mg'},
      {'name': '榛子', 'value': '15mg'},
      {'name': '花生油', 'value': '16.1mg'},
      {'name': '鳄梨', 'value': '2.1mg'},
      {'name': '菠菜', 'value': '2.1mg'},
      {'name': '南瓜', 'value': '1.1mg'},
      {'name': '红薯', 'value': '0.26mg'},
      {'name': '橄榄油', 'value': '14.4mg'},
      {'name': '鳗鱼', 'value': '2.9mg'},
      {'name': '鲑鱼', 'value': '2.9mg'},
    ],
    '烟酸': [
      {'name': '鸡胸肉', 'value': '14.8mg'},
      {'name': '牛肉', 'value': '8.6mg'},
      {'name': '猪肉', 'value': '8mg'},
      {'name': '鱼', 'value': '9.1mg'},
      {'name': '花生', 'value': '12.1mg'},
      {'name': '蘑菇', 'value': '5mg'},
      {'name': '牛肝', 'value': '17mg'},
      {'name': '芝麻', 'value': '4.5mg'},
      {'name': '豆腐', 'value': '1.3mg'},
      {'name': '腰果', 'value': '1.1mg'},
    ],
  };

  final Map<String, List<Map<String, String>>> _recipes = {
    '鸡胸肉': [
      {'name': '烤鸡胸肉', 'description': '简单健康的烤鸡胸肉配方，适合减脂。'},
      {'name': '鸡胸肉沙拉', 'description': '新鲜蔬菜搭配鸡胸肉，营养丰富。'},
    ],
    '牛排': [
      {'name': '煎牛排', 'description': '经典煎牛排，外焦里嫩。'},
      {'name': '黑胡椒牛排', 'description': '黑胡椒调味的牛排，风味独特。'},
    ],
    '三文鱼': [
      {'name': '烤三文鱼', 'description': '香烤三文鱼，营养丰富。'},
      {'name': '三文鱼刺身', 'description': '新鲜三文鱼刺身，口感嫩滑。'},
    ],
    // 添加更多食物的菜谱...
  };

  int _selectedIndex = 0;
  String _searchQuery = '';
  bool _isAscending = true;

  List<Map<String, String>> _selectedFoods = [];

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
                  builder: (context) => DailyPlanPage(selectedFoods: _selectedFoods, recipes: _recipes),
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
      body: Row(
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
                    builder: (context) => FoodDetailPage(food: filteredRanking[index], recipes: _recipes),
                  ),
                );
              },
              onLongPress: () {
                setState(() {
                  _selectedFoods.add(filteredRanking[index]);
                });
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('${filteredRanking[index]['name']} 已添加到饮食计划')),
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
