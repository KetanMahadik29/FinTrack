class UserModel {
  final String id;
  final String name;
  final String email;
  final String currencyCode;
  final String currencySymbol;
  final bool isDarkMode;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    this.currencyCode = 'USD',
    this.currencySymbol = '\$',
    this.isDarkMode = false,
  });

  UserModel copyWith({
    String? id,
    String? name,
    String? email,
    String? currencyCode,
    String? currencySymbol,
    bool? isDarkMode,
  }) {
    return UserModel(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      currencyCode: currencyCode ?? this.currencyCode,
      currencySymbol: currencySymbol ?? this.currencySymbol,
      isDarkMode: isDarkMode ?? this.isDarkMode,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'currencyCode': currencyCode,
      'currencySymbol': currencySymbol,
      'isDarkMode': isDarkMode,
    };
  }

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] as String? ?? 'user_1',
      name: json['name'] as String? ?? 'Alex Johnson',
      email: json['email'] as String? ?? 'alex.johnson@fintrack.io',
      currencyCode: json['currencyCode'] as String? ?? 'USD',
      currencySymbol: json['currencySymbol'] as String? ?? '\$',
      isDarkMode: json['isDarkMode'] as bool? ?? false,
    );
  }
}
