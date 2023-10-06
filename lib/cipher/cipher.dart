import 'dart:convert';
import 'dart:typed_data';
import 'package:pointycastle/export.dart';
import 'dart:math';

Uint8List randomNonce([int length = 12]) {
  final rand = Random.secure();
  return Uint8List.fromList(List.generate(length, (_) => rand.nextInt(256)));
}

String encrypt(Map<String, dynamic> data, String keyString) {
  try {
    final key = Uint8List.fromList(utf8.encode(keyString));
    final plaintext = Uint8List.fromList(utf8.encode(json.encode(data)));
    final cipher = GCMBlockCipher(AESFastEngine());
    final nonce = randomNonce(12);
    cipher.init(true, AEADParameters(KeyParameter(key), 128, nonce, Uint8List(0)));
    final encrypted = cipher.process(plaintext);

    // Concatenate nonce with encrypted data
    final combined = Uint8List(nonce.length + encrypted.length)
      ..setRange(0, nonce.length, nonce)
      ..setRange(nonce.length, nonce.length + encrypted.length, encrypted);

    return base64Encode(combined);
  } catch (e) {
    throw Exception('Encryption failed: $e');
  }
}

String decrypt(String encryptedData, String keyString) {
  try {
    final key = Uint8List.fromList(utf8.encode(keyString));
    final decodedEncryptedData = base64Decode(encryptedData);

    if (decodedEncryptedData.length <= 28) {
      throw ArgumentError('Encrypted data is too short.');
    }

    final nonce = decodedEncryptedData.sublist(0, 12);
    final encryptedBytes = decodedEncryptedData.sublist(12);
    final cipher = GCMBlockCipher(AESFastEngine())
      ..init(false, AEADParameters(KeyParameter(key), 128, nonce, Uint8List(0)));
    final decrypted = cipher.process(encryptedBytes);
    return utf8.decode(decrypted);
  } catch (e) {
    throw Exception('Decryption failed: $e');
  }
}
