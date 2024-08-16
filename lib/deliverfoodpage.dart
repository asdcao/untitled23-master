import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:untitled/RestaurantPage.dart';

class DeliverFoodPage extends StatefulWidget {
  @override
  _DeliverFoodPageState createState() => _DeliverFoodPageState();
}

class _DeliverFoodPageState extends State<DeliverFoodPage> {
  List<Restaurant> restaurantList = [];
  List<FoodCategory> foodCategories = [];
  List<Dish> recommendedDishes = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    final restaurantResponse = await http.get(Uri.parse('http://192.168.1.101:8001/restaurants/'));
    final categoryResponse = await http.get(Uri.parse('http://192.168.1.101:8001/categories/'));
    final recommendedDishesResponse = await http.get(Uri.parse('http://192.168.1.101:8001/recommended-dishes/'));

    if (restaurantResponse.statusCode == 200 &&
        categoryResponse.statusCode == 200 &&
        recommendedDishesResponse.statusCode == 200) {
      setState(() {
        restaurantList = (jsonDecode(utf8.decode(restaurantResponse.bodyBytes)) as List)
            .map((data) => Restaurant.fromJson(data))
            .toList();
        foodCategories = (jsonDecode(utf8.decode(categoryResponse.bodyBytes)) as List)
            .map((data) => FoodCategory.fromJson(data))
            .toList();
        recommendedDishes = (jsonDecode(utf8.decode(recommendedDishesResponse.bodyBytes)) as List)
            .map((data) => Dish.fromJson(data))
            .toList();
        _isLoading = false;
      });
    } else {
      throw Exception('Failed to load data');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('送餐服务'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.shopping_cart),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => CartPage()),
              );
            },
          ),
        ],
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 搜索框
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: TextField(
                      decoration: InputDecoration(
                        hintText: '搜索餐厅或菜品',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.search),
                      ),
                    ),
                  ),
                  // 推荐餐厅
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Text(
                      '推荐餐厅',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ),
                  SizedBox(height: 10),
                  Container(
                    height: 180,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: restaurantList.length,
                      itemBuilder: (context, index) {
                        return _buildRestaurantCard(context, restaurantList[index]);
                      },
                    ),
                  ),
                  // 菜品分类
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
                    child: Text(
                      '菜品分类',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ),
                  GridView.count(
                    crossAxisCount: 3,
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    children: foodCategories.map((category) {
                      return _buildFoodCategoryCard(context, category);
                    }).toList(),
                  ),
                  // 推荐菜品
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
                    child: Text(
                      '推荐菜品',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ),
                  ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: recommendedDishes.length,
                    itemBuilder: (context, index) {
                      return _buildDishCard(context, recommendedDishes[index]);
                    },
                  ),
                ],
              ),
            ),
    );
  }

  Widget _buildRestaurantCard(BuildContext context, Restaurant restaurant) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => RestaurantPage(restaurant: restaurant),
          ),
        );
      },
      child: Card(
        margin: EdgeInsets.only(right: 10),
        child: Column(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.vertical(top: Radius.circular(10)),
              child: Image.network(
                restaurant.imageUrl,
                width: 120,
                height: 120,
                fit: BoxFit.cover,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                restaurant.name,
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFoodCategoryCard(BuildContext context, FoodCategory category) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => CategoryPage(category: category),
          ),
        );
      },
      child: Column(
        children: [
          CircleAvatar(
            radius: 30,
            backgroundImage: NetworkImage(category.imageUrl),
          ),
          SizedBox(height: 8),
          Text(
            category.name,
            style: TextStyle(fontSize: 14),
          ),
        ],
      ),
    );
  }

  Widget _buildDishCard(BuildContext context, Dish dish) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: ListTile(
        leading: Image.network(
          dish.imageUrl,
          width: 50,
          height: 50,
          fit: BoxFit.cover,
        ),
        title: Text(dish.name),
        subtitle: Text(dish.description),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('¥${dish.price.toString()}'),
            IconButton(
              icon: Icon(Icons.add_shopping_cart),
              onPressed: () {
                cart.add(dish);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('${dish.name} 已添加到购物车')),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class Restaurant {
  final String imageUrl;
  final String name;

  Restaurant({required this.imageUrl, required this.name});

  factory Restaurant.fromJson(Map<String, dynamic> json) {
    return Restaurant(
      imageUrl: json['imageUrl'],
      name: json['name'],
    );
  }
}

class FoodCategory {
  final String imageUrl;
  final String name;

  FoodCategory({required this.imageUrl, required this.name});

  factory FoodCategory.fromJson(Map<String, dynamic> json) {
    return FoodCategory(
      imageUrl: json['imageUrl'],
      name: json['name'],
    );
  }
}

class Dish {
  final String imageUrl;
  final String name;
  final String description;
  final double price;

  Dish({
    required this.imageUrl,
    required this.name,
    required this.description,
    required this.price,
  });

  factory Dish.fromJson(Map<String, dynamic> json) {
    return Dish(
      imageUrl: json['imageUrl'],
      name: json['name'],
      description: json['description'],
      price: json['price'] is String ? double.parse(json['price']) : json['price'],
    );
  }
}

class Cart {
  List<Dish> _items = [];

  void add(Dish dish) {
    _items.add(dish);
  }

  void remove(Dish dish) {
    _items.remove(dish);
  }

  List<Dish> get items => _items;
}

final Cart cart = Cart();

class CartPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('购物车'),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: cart.items.length,
              itemBuilder: (context, index) {
                final dish = cart.items[index];
                return ListTile(
                  leading: Image.network(
                    dish.imageUrl,
                    width: 50,
                    height: 50,
                    fit: BoxFit.cover,
                  ),
                  title: Text(dish.name),
                  subtitle: Text(dish.description),
                  trailing: Text('¥${dish.price.toString()}'),
                  onTap: () {
                    // 这里可以添加点击事件，例如导航到该菜品的详细页面
                  },
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
              onPressed: () {
                // 这里可以添加结算功能
              },
              child: Text('结算'),
            ),
          ),
        ],
      ),
    );
  }
}

class CategoryPage extends StatelessWidget {
  final FoodCategory category;

  CategoryPage({required this.category});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(category.name),
      ),
      body: FutureBuilder(
        future: fetchCategoryDishes(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Failed to load dishes'));
          } else {
            final List<Dish> categoryDishes = snapshot.data as List<Dish>;
            return ListView.builder(
              itemCount: categoryDishes.length,
              itemBuilder: (context, index) {
                final dish = categoryDishes[index];
                return Card(
                  margin: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                  child: ListTile(
                    leading: Image.network(
                      dish.imageUrl,
                      width: 50,
                      height: 50,
                      fit: BoxFit.cover,
                    ),
                    title: Text(dish.name),
                    subtitle: Text(dish.description),
                    trailing: Text('¥${dish.price.toString()}'),
                    onTap: () {
                      // 可以添加点击事件，例如导航到该菜品的详细页面
                    },
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }

  Future<List<Dish>> fetchCategoryDishes() async {
    final response = await http.get(Uri.parse('http://192.168.1.101:8001/dishes?category=${category.name}'));
    if (response.statusCode == 200) {
      return (jsonDecode(utf8.decode(response.bodyBytes)) as List)
          .map((data) => Dish.fromJson(data))
          .toList();
    } else {
      throw Exception('Failed to load dishes');
    }
  }
}
