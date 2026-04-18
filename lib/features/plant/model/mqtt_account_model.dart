class MqttAccount {
  final String username;
  final String password;

  MqttAccount({required this.username, required this.password});

  // Factory untuk menangani response dari RPC maupun Select
  factory MqttAccount.fromJson(Map<String, dynamic> json) {
    return MqttAccount(
      username: json['mqtt_username'] ?? json['username'] ?? '',
      password: json['mqtt_password_hash'] ?? json['password'] ?? '',
    );
  }
}
