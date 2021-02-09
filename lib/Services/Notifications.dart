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
        return snapshot.documents?.first?.data['message'] ?? '';
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

  // @override
  // void initState() {
  //   // TODO: implement initState
  //   bool firstNotification = true;
  //   super.initState();
  //   Notifications.getBranchNotifications(branchID: 'aaa').listen((data) {
  //     if (!firstNotification) {
  //       SafeDineSnackBar.showNotification(
  //         type: SnackbarType.Warning,
  //         context: context,
  //         msg: data,
  //         duration: 100,
  //       );
  //     }else firstNotification = false;
  //   }, cancelOnError: false);
  // }
