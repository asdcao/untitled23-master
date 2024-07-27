import 'package:flutter/material.dart';
import 'package:untitled/CategoryPage.dart';

class DeliverFoodPage extends StatelessWidget {
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
      body: SingleChildScrollView(
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
              child: Image.asset(
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
            backgroundImage: AssetImage(category.imageUrl),
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
        leading: Image.asset(
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

class RestaurantPage extends StatelessWidget {
  final Restaurant restaurant;

  RestaurantPage({required this.restaurant});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(restaurant.name),
      ),
      body: ListView.builder(
        itemCount: recommendedDishes.length, // Replace with actual dishes of the restaurant
        itemBuilder: (context, index) {
          return _buildDishCard(context, recommendedDishes[index]);
        },
      ),
    );
  }

  Widget _buildDishCard(BuildContext context, Dish dish) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: ListTile(
        leading: Image.asset(
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
}

class FoodCategory {
  final String imageUrl;
  final String name;

  FoodCategory({required this.imageUrl, required this.name});
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

// 示例数据
final List<Restaurant> restaurantList = [
  Restaurant(imageUrl: 'assets/store3.webp', name: '健康餐厅1'),
  Restaurant(imageUrl: 'assets/store3.webp', name: '健康餐厅2'),
  Restaurant(imageUrl: 'assets/store3.webp', name: '健康餐厅3'),
  Restaurant(imageUrl: 'assets/store3.webp', name: '健康餐厅4'),
];

final List<FoodCategory> foodCategories = [
  FoodCategory(imageUrl: 'assets/food1.webp', name: '低盐菜'),
  FoodCategory(imageUrl: 'assets/food2.webp', name: '低糖菜'),
  FoodCategory(imageUrl: 'assets/food1.webp', name: '高纤维菜'),
  FoodCategory(imageUrl: 'assets/food2.webp', name: '高蛋白菜'),
];

final List<Dish> recommendedDishes = [
  Dish(imageUrl: 'assets/dish1.webp', name: '蒸蛋', description: '软嫩可口', price: 10.0),
  Dish(imageUrl: 'assets/dish2.webp', name: '清蒸鱼', description: '营养丰富', price: 25.0),
  Dish(imageUrl: 'assets/dish3.webp', name: '银耳羹', description: '润肺养颜', price: 15.0),
  Dish(imageUrl: 'assets/dish4.webp', name: '红枣粥', description: '滋补养生', price: 12.0),
];

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
                  leading: Image.asset(
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
