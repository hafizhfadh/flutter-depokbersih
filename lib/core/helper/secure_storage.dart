import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorage {
  static late SecureStorage _instance;

  factory SecureStorage() =>
      _instance = SecureStorage._(FlutterSecureStorage());

  SecureStorage._(this._storage);

  final FlutterSecureStorage _storage;
  static const _uuidKey = 'UUID';
  static const _emailKey = 'EMAIL';

  Future<void> persistEmailAndUuid(String email, String uuid) async {
    await _storage.write(key: _emailKey, value: email);
    await _storage.write(key: _uuidKey, value: uuid);
  }

  Future<void> removeEmailAndUuid() async {
    await _storage.write(key: _emailKey, value: null);
    await _storage.write(key: _uuidKey, value: null);
  }

  Future<bool> hasUuid() async {
    var value = await _storage.read(key: _uuidKey);
    return value != null;
  }

  Future<bool> hasEmail() async {
    var value = await _storage.read(key: _emailKey);
    return value != null;
  }

  Future<void> deleteToken() async {
    return _storage.delete(key: _uuidKey);
  }

  Future<void> deleteEmail() async {
    return _storage.delete(key: _emailKey);
  }

  Future<String?> getEmail() async {
    return await _storage.read(key: _emailKey);
  }

  Future<String?> getUuid() async {
    return _storage.read(key: _uuidKey);
  }

  Future<void> setUuid(String uuid) async {
    return _storage.write(key: _uuidKey, value: uuid);
  }

  Future<void> deleteAll() async {
    return _storage.deleteAll();
  }
}
