import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static const String baseUrl = "http://192.168.1.101:8000/get_hospital_info/";

  Future<List<Hospital>> getHospitals() async {
    final response = await http.get(Uri.parse(baseUrl));

    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body)['hospitals'];
      return jsonResponse.map((hospital) => Hospital.fromJson(hospital)).toList();
    } else {
      throw Exception('Failed to load hospitals');
    }
  }
}

class Hospital {
  final String name;
  final double rating;
  final double distance;
  final String address;
  final String imageUrl;
  final String description; // 添加 description 字段

  Hospital({
    required this.name,
    required this.rating,
    required this.distance,
    required this.address,
    required this.imageUrl,
    required this.description, // 初始化 description 字段
  });

  factory Hospital.fromJson(Map<String, dynamic> json) {
    return Hospital(
      name: json['hospital_name'],
      rating: 9.5, // 假设所有的评分都是9.5，你可以从json中获取实际值
      distance: 1.0, // 假设所有的距离都是1.0，你可以从json中获取实际值
      address: json['hospital_address'],
      imageUrl: json['hospital_image_url'],
      description: json['hospital_description'], // 从 JSON 中解析 description
    );
  }
}
