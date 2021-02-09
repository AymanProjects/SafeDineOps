import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path/path.dart' as Path;

class CloudStorage {
  static Future<String> uploadFile(File file) async {
    StorageReference storageReference =
        FirebaseStorage.instance.ref().child('${DateTime.now()}_${Path.basename(file.path)}');
    StorageUploadTask uploadTask = storageReference.putFile(file);
    await uploadTask.onComplete;
    return await storageReference.getDownloadURL() as String;
  }
}
