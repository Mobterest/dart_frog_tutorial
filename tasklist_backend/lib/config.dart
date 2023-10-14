import 'dart:convert';
import 'dart:io';

/// Configuration class
class Configuration {
  /// Read configurations from config.json
  Future<Map<String, dynamic>> getRedisConfigurations() async {
    final configFile = File('./config.json');
    final jsonString = await configFile.readAsString();
    final map = jsonDecode(jsonString) as Map<String, dynamic>;
    final redisConfig = map['redis'] as Map<String, dynamic>;
    return redisConfig;
  }

  /// Read configurations from config.json
  Future<Map<String, dynamic>> getAPIConfigurations() async {
    final configFile = File('./config.json');
    final jsonString = await configFile.readAsString();
    final map = jsonDecode(jsonString) as Map<String, dynamic>;
    final config = map['restapi'] as Map<String, dynamic>;
    return config;
  }

  /// Read configurations from config.json
  Future<Map<String, dynamic>> getFileConfigurations() async {
    final configFile = File('./config.json');
    final jsonString = await configFile.readAsString();
    final map = jsonDecode(jsonString) as Map<String, dynamic>;
    final config = map['files'] as Map<String, dynamic>;
    return config;
  }
}
