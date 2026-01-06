import 'dart:io';
import 'package:appwrite/appwrite.dart';
import 'package:housely/core/constants/text_constants.dart';

abstract interface class AppwriteStorageDataSource {
  Future<Map<String, dynamic>> uploadPropertyImages({
    required List<File> images,
    required String ownerEmail,
  });

  Future<Map<String, String>> uploadCoverImage({
    required File image,
    required String ownerEmail,
    required String folderType, // 'profile', 'cover', or 'gallery'
    String? bucketId,
  });

  // delete property images
  Future<void> deleteImageFile({required String fileId});

  // update image file and reture image url
  Future<Map<String, String>> updateImageFile({required String fileId});
}

class AppwriteStorageDataSourceImpl implements AppwriteStorageDataSource {
  final Storage storage;

  final _bucketId = "6957a5060003fc720b53";
  final _projectId = "6954b11a00214cb8b35f";

  AppwriteStorageDataSourceImpl({required this.storage});

  @override
  Future<void> deleteImageFile({required String fileId}) async {
    try {
      await storage.deleteFile(bucketId: _bucketId, fileId: fileId);
    } catch (e) {
      throw Exception("Failed to deleted image file: $e");
    }
  }

  @override
  Future<Map<String, String>> updateImageFile({required String fileId}) async {
    try {
      final file = await storage.updateFile(
        bucketId: _bucketId,
        fileId: fileId,
      );

      final fileUrl =
          '${TextConstants.appwriteUrl}storage/buckets/$_bucketId/files/${file.$id}/view?project=$_projectId';

      return {"url": fileUrl, "id": file.$id};
    } catch (e) {
      throw Exception("Failed to upload image: $e");
    }
  }

  @override
  Future<Map<String, String>> uploadCoverImage({
    required File image,
    required String ownerEmail,
    required String folderType,
    String? bucketId,
  }) async {
    try {
      final sanitizedEmail = ownerEmail.replaceAll(
        RegExp(r'[^a-zA-Z0-9]'),
        '_',
      );
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      final fileName = '${sanitizedEmail}_${folderType}_$timestamp';
      final file = await storage.createFile(
        bucketId: bucketId ?? _bucketId,
        fileId: ID.unique(),
        file: InputFile.fromPath(path: image.path, filename: fileName),
        permissions: [Permission.read(Role.any())],
      );
      final customBucketId = bucketId ?? _bucketId;
      final fileUrl =
          '${TextConstants.appwriteUrl}storage/buckets/$customBucketId/files/${file.$id}/view?project=$_projectId';

      return {"url": fileUrl, "id": file.$id};
    } catch (e) {
      throw Exception("Failed to upload cover image to appwrite : $e");
    }
  }

  @override
  Future<Map<String, dynamic>> uploadPropertyImages({
    required List<File> images,
    required String ownerEmail,
  }) async {
    List<Map<String, dynamic>> galleryData = [];

    for (var image in images) {
      // we upload individual image and get all the list of urls
      final url = await uploadCoverImage(
        image: image,
        ownerEmail: ownerEmail,
        folderType: "gallery",
      );
      galleryData.add(url);
    }

    return {"images": galleryData};
  }
}
