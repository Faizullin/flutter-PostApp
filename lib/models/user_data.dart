class UserData {
  final String id;
  final String name;
  final String email;
  final String address;
  final String createdAt;


  const UserData({
    required this.id,
    required this.name,
    required this.email,
    required this.address,
    required this.createdAt,
  });

  factory UserData.fromJson(Map<String, dynamic> json) {
    if(!json.containsKey('address')){
      json['address'] = 'Unknown';
    }
    return UserData(
      id: '${json['id']}',
      name: json['name'],
      email: json['email'],
      address: json['address'],
      createdAt: json['created_at'],
    );
  }
}

