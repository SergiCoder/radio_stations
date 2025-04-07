import 'dart:async';
import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:hive_ce/hive.dart';

/// keylist name for Flutter Secure Storage
const _keyList = 'keyList';

/// A secure storage implementation using Hive for Flutter.
///
/// Allows for storing and retrieving encrypted key-value pairs of type [T].
/// Each storage instance is identified by a unique `storageId`. All values are
/// encrypted using an AES cipher, and the encryption key is stored securely on
/// the device using `FlutterSecureStorage`. The storage can be cleared or
/// deleted from the device.
class LocalDatabase<T> {
  LocalDatabase._({required String storageId}) : _storageId = storageId;

  /// Storage key for creation different buckets.
  final String _storageId;

  late final Box<T> _box;

  /// Creates a new [LocalDatabase] instance with the given `storageId`.
  ///
  /// Throws an exception if it is not possible to initialize the local storage.
  static Future<LocalDatabase<T>> instance<T>({
    required String storageId,
    required String path,
  }) async {
    try {
      final instance = LocalDatabase<T>._(storageId: storageId);

      Hive.init(path);

      final cipher = await _getCipher();
      instance._box = await Hive.openBox<T>(
        storageId,
        encryptionCipher: cipher,
        path: path,
      );

      return instance;
    } catch (e) {
      throw Exception('There was an error initializing the local storage: $e');
    }
  }

  /// Returns the encryption cipher to be used for encrypting values. This
  /// cipher is generated from the encryption key which is stored securely
  /// on the device using `FlutterSecureStorage`.
  static Future<HiveAesCipher> _getCipher() async {
    const secureStorage = FlutterSecureStorage();

    final encryptionKey = await secureStorage.read(key: _keyList);
    if (encryptionKey == null) {
      final key = Hive.generateSecureKey();
      await secureStorage.write(key: _keyList, value: base64UrlEncode(key));
    }
    final key = await secureStorage.read(key: _keyList);
    return HiveAesCipher(base64Url.decode(key!));
  }

  /// Sets a value of type [T] for the given `key` in the secure storage bucket.
  ///
  /// Throws an exception if an error occurs while trying to store the value.
  Future<void> set(String key, T value) async {
    try {
      await _box.put(key, value);
    } catch (e) {
      throw Exception(
        'There was an error setting the value in the local storage: $e',
      );
    }
  }

  /// Sets a map of key-value pairs in the secure storage bucket.
  /// Each value is of type [T] and is stored with its corresponding key.
  /// Throws an exception if an error occurs while trying to store the values.
  Future<void> setAll(Map<String, T> values) async {
    try {
      await _box.putAll(values);
    } catch (e) {
      throw Exception(
        'It was not possible setting the values in the local storage: $e',
      );
    }
  }

  /// Returns the value of type [T] associated with the given `key` in the secure
  /// storage bucket.
  ///
  /// Throws an exception if an error occurs while trying to retrieve the value.
  Future<T> get(String key) async {
    try {
      return _box.get(key)!;
    } catch (e) {
      throw Exception(
        'It was not possible retrieving the value from the local storage',
      );
    }
  }

  /// Deletes the value associated with the given `key` from the secure storage
  /// bucket if exists. Otherwise do nothing.
  Future<void> deleteKey(String key) async => _box.delete(key);

  /// Deletes the last item
  Future<void> deleteLast() async {
    final total = _box.length;
    await _box.delete(total - 1);
  }

  /// Deletes the specified item
  Future<void> delete(T item) async {
    for (var i = 0; i < _box.length; i++) {
      if (_box.getAt(i) == item) {
        await _box.deleteAt(i);
      }
    }
  }

  /// Returns a boolean indicating whether a value is associated with the given
  /// `key` in the secure storage bucket.
  Future<bool> containsKey(String key) async => _box.containsKey(key);

  /// Deletes the entire secure storage bucket from the device.
  Future<void> removeStorage() async => Hive.deleteBoxFromDisk(_storageId);

  /// Returns a list of all keys currently stored in the secure storage bucket.
  Future<List<String>> getKeys() async => _box.keys.toList() as List<String>;

  /// Returns the last value of type [T] stored in the secure storage bucket.
  ///
  /// Throws an exception if an error occurs while trying to retrieve the value,
  /// or if the bucket is empty.
  Future<T> getLast() async {
    try {
      final total = _box.length;

      if (total > 0) {
        final last = _box.get(total - 1) as T;
        return last;
      }
    } catch (e) {
      throw Exception(
        '''It was not possible retrieving the last value from the local storage''',
      );
    }
    throw Exception('The box length is not major than 0');
  }

  /// Returns a list of all values of type [T] currently stored in the secure
  /// storage bucket.
  ///
  /// Throws an exception if an error occurs while trying to retrieve the values.
  Future<List<T>> getAll() async {
    try {
      final values = <T>[];
      for (var i = 0; i < _box.length; i++) {
        values.add(_box.getAt(i) as T);
      }
      return values;
    } catch (e) {
      throw Exception(
        '''It was not possible retrieving all values from the local storage''',
      );
    }
  }

  /// Clears all values stored in the secure storage bucket.
  Future<void> clear() async => _box.clear();

  /// Closes the Hive box and frees up resources.
  Future<void> close() async => _box.close();
}
