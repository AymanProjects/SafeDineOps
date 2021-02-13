import 'package:cloud_firestore/cloud_firestore.dart';

class Notifications {
  static final _database = Firestore.instance;

  static Stream<String> getBranchNotifications({String branchID}) {
    return _database
        .collection('notifications')
        .where('branchID', isEqualTo: branchID)
        .orderBy('date', descending: true)
        .limit(1)
        .snapshots()
        .map(
      (QuerySnapshot snapshot) {
        if (snapshot.documents.length > 0)
          return snapshot.documents.first.data['message'];
        else
          return null;
      },
    );
  }

  static Future<void> sendNotificationTo(
      {String branchID, String message}) async {
    await _database.collection('notifications').document().setData({
      'message': message ?? '',
      'branchID': branchID ?? '',
      'date': DateTime.now().toString(),
    });
  }
}
