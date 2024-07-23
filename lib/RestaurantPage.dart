import 'package:flutter/material.dart';
import 'package:untitled/deliverfoodpage.dart';


class RestaurantPage extends StatelessWidget {
  final Restaurant restaurant;

  RestaurantPage({required this.restaurant});

  // 模拟数据
  final List<Dish> restaurantDishes = [
    Dish(imageUrl: 'assets/food1.png', name: '宫保鸡丁', description: '经典川菜', price: 28.0),
    Dish(imageUrl: 'assets/food2.png', name: '红烧肉', description: '美味佳肴', price: 35.0),
    Dish(imageUrl: 'assets/food1.png', name: '麻婆豆腐', description: '麻辣鲜香', price: 22.0),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(restaurant.name),
      ),
      body: ListView.builder(
        itemCount: restaurantDishes.length,
        itemBuilder: (context, index) {
          final dish = restaurantDishes[index];
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
              trailing: Text('¥${dish.price.toString()}'),
              onTap: () {
                // 可以添加点击事件，例如导航到该菜品的详细页面
              },
            ),
          );
        },
      ),
    );
  }
}
