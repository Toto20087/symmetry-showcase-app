import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

abstract class StorageDataSource {
  Future<String> uploadArticleImage(String articleId, dynamic imageFile);
  Future<void> deleteArticleImage(String imagePath);
}

class StorageDataSourceImpl implements StorageDataSource {
  final FirebaseStorage _storage;

  StorageDataSourceImpl(this._storage);

  @override
  Future<String> uploadArticleImage(String articleId, dynamic imageFile) async {
    try {
      final fileName = 'thumbnail_${DateTime.now().millisecondsSinceEpoch}.jpg';
      final path = 'media/articles/$articleId/$fileName';
      final ref = _storage.ref().child(path);

      UploadTask uploadTask;

      if (kIsWeb) {
        // For web, imageFile should be Uint8List
        final bytes = await imageFile.readAsBytes();
        uploadTask = ref.putData(
          bytes,
          SettableMetadata(contentType: 'image/jpeg'),
        );
      } else {
        // For mobile/desktop, imageFile is a File
        uploadTask = ref.putFile(
          File(imageFile.path),
          SettableMetadata(contentType: 'image/jpeg'),
        );
      }

      await uploadTask;

      // Get and return the download URL
      final downloadURL = await ref.getDownloadURL();
      return downloadURL;
    } catch (e) {
      throw Exception('Failed to upload image: $e');
    }
  }

  @override
  Future<void> deleteArticleImage(String imagePath) async {
    try {
      await _storage.ref().child(imagePath).delete();
    } catch (e) {
      throw Exception('Failed to delete image: $e');
    }
  }
}
