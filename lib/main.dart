import 'dart:convert';
import 'cipher/cipher.dart';  // Importing our separate cipher functions.

void main() {
try {
        final keyString = "SuperSecretEncryptionKey48348337";
        final sampleData = {
            "username": "john_doe",
            "email": "john@example.com",
            "password": "password123",
        };

        final encryptedData = encrypt(sampleData, keyString);
        print('Encrypted Data: $encryptedData');

        final decryptedData = decrypt(encryptedData, keyString);
        print('Decrypted Data: ${json.decode(decryptedData)}');
}
catch (e) {
        print("Error: " + e.toString());
}
  
}
