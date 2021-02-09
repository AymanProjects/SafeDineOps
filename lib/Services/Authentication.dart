import 'package:SafeDineOps/Interfaces/DatabaseModel.dart';
import 'package:SafeDineOps/Models/Account.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Authentication {
  Authentication._();
  static final FirebaseAuth _authInstance = FirebaseAuth.instance;

  static Stream<FirebaseUser> getUserState() {
    return _authInstance.onAuthStateChanged;
  }

  static Future<FirebaseUser> getCurrentUser() async {
    return _authInstance.currentUser();
  }

  static Future<void> login(Account account) async {
    try {
      await _authInstance.signInWithEmailAndPassword(
          email: account.getEmail(), password: account.getPassword());
    } catch (exception) {
      signOut(); // so the user can login again
      rethrow;
    }
  }

  static Future<void> register(Account account) async {
    AuthResult registeredUser;
    try {
      //--Create an Auth--//
      registeredUser = await _authInstance.createUserWithEmailAndPassword(
          email: account.getEmail(), password: account.getPassword());
      //--Create The Document--//
      (account as DatabaseModel).id = registeredUser.user.uid;
      await (account as DatabaseModel).updateOrCreate();
    } catch (exception) {
      if (registeredUser != null)
        await registeredUser.user
            .delete(); // delete, since there was error creating the document. And let the user register again
      rethrow;
    }
  }

  static Future<void> signOut() async {
    return await _authInstance.signOut();
  }

  static Future<void> forgotPassword({String email}) async {
    await _authInstance.sendPasswordResetEmail(email: email);
  }
}
