import 'dart:convert';
import 'dart:io';
import 'package:post_app/core/app_export.dart';
import 'package:post_app/models/filters.dart';
import 'package:post_app/models/post.dart';
import 'package:http/http.dart' as http;
import 'package:post_app/services/auth_provider.dart';

class PostService {
  final AuthProvider? authProvider;

  PostService({this.authProvider});

  String sortColumn = '';
  String sortOrder = '';


  int _currentPage = 1;
  void setPage(int page) {
    _currentPage = page;
  }
  int get currentPage => _currentPage;

  Future<Post> getPostById(String id, String token) async {
    final response = await http.get(
      Uri.parse('${Env.baseUrl}/api/post/$id'),
      headers: <String, String>{
        'Context-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json'
      },
    );
    if (response.statusCode == 200) {
      return Post.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load album');
    }
  }

  Future<List<Post>> getAllPosts() async {
    final response = await http.get(Uri.parse('${Env.baseUrl}/api/post'));

    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      return jsonResponse.map<Post>((data) => Post.fromJson(data)).toList();
    } else {
      throw Exception('Failed to load album');
    }
  }



  Future<Post> store(Map<String, dynamic> body,String token) async {
    var request = http.MultipartRequest('POST',
      Uri.parse('${Env.baseUrl}/api/post/create'),
    );
    body.forEach((key, value) {
      if(value is String || value is int || value is List) {
        request.fields[key] = value;
      }
    });
    var file = body['image'];
    // final imageStream = http.ByteStream(file.openRead());
    // final imageLength = await file.length();
    // final imageUpload = http.MultipartFile('image', imageStream, imageLength,
    //     filename: 'copper.jpg', contentType: MediaType('image', 'jpeg'));
    request.files.add(http.MultipartFile.fromBytes('picture', File(file!.path).readAsBytesSync(),filename: file!.path));
    request.headers.addAll({
      'Context-Type': 'application/json; charset=UTF-8',
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json'
    });

    var response = await request.send();
    print("response $response");

    if (response.statusCode == 200) {
      return Post.fromJson(jsonDecode('{}'));
    } else {
      throw Exception('Failed to load album');
    }
  }

  Future<Filters> getAllFilters() async {
    final response = await http.get(Uri.parse('${Env.baseUrl}/api/post/filters'));

    if (response.statusCode == 200) {
      Map<String, dynamic> jsonResponse = json.decode(response.body);
      return Filters.fromJson(jsonResponse);
    } else {
      throw Exception('Failed to load album');
    }
  }

  Future<List<Post>> applyFilters(SelectFilters filters) async {
    String url = '${Env.baseUrl}/api/post?';
    if (filters.categories.isNotEmpty) {
      url += "category=${filters.categories[filters.categories.length - 1].slug}&";
    }
    for (int i = 0; i < filters.tags.length; i++) {
      url += "tag[$i]=${filters.tags[i].slug}&";
    }
    if(filters.searchQuery != null && filters.searchQuery!.isNotEmpty){
      url += "search=${filters.searchQuery}&";
    }
    final response = await http.get(
      Uri.parse(url),
      headers: {"Accept": "application/json"},
    );

    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      return jsonResponse.map((data) => Post.fromJson(data)).toList();
    } else {
      throw Exception('Failed to load album');
    }
  }

  Future<List<Post>> applySearchSubmit(String value) async {
    final response = await http.get(
      Uri.parse('${Env.baseUrl}/api/post?search=$value'),
    );
    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      return jsonResponse.map((data) => Post.fromJson(data)).toList();
    } else {
      throw Exception('Failed to load album');
    }
  }

  Future<List<Post>> addToFiltersAndApply(Map<String,String> body, String token) async {
    sortColumn = body['sort_field']!;
    final response = await http.get(
      Uri.parse('${Env.baseUrl}/api/post?sort_field=$sortColumn'),//?sort_order=${body['sort_order']}&sort_column=${body['sort_column']}'),
      headers: <String, String>{
        'Context-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json'
      },
    );
    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      return jsonResponse.map((data) => Post.fromJson(data)).toList();
    } else {
      throw Exception('Failed to load album');
    }
  }
}
