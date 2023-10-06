import 'package:test/test.dart';
import '../lib/cipher/cipher.dart';
import 'dart:convert';


void main() {
  final keyString = 'SuperSecretEncryptionKey48374837'; 
  final sampleData = {
    'name': 'John Doe',
    'email': 'john.doe@example.com',
    'age': 30
  };

  test('Encryption and Decryption', () {
    final encryptedData = encrypt(sampleData, keyString);
    expect(encryptedData, isNotNull);
    expect(encryptedData, isNotEmpty);

    final decryptedData = decrypt(encryptedData, keyString);
    expect(decryptedData, isNotNull);
    expect(decryptedData, isNotEmpty);
    expect(json.decode(decryptedData), sampleData);
  });

  test('Error handling in decryption with invalid key', () {
    final wrongKey = 'wrong_key';
    final encryptedData = encrypt(sampleData, keyString);
    
    expect(() => decrypt(encryptedData, wrongKey), throwsA(isA<Exception>()));
  });

  test('Error handling in encryption with invalid key', () {
    final wrongKey = 'wrong_key';
    
    expect(() => encrypt(sampleData, wrongKey), throwsA(isA<Exception>()));
  });

}
