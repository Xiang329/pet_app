import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pet_app/common/apiMethods.dart';
import 'package:pet_app/providers/member_provider.dart';
import 'package:provider/provider.dart';

class AuthModel extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  User? _user;
  bool _loading = false;

  AuthModel() {
    _auth.authStateChanges().listen((User? user) {
      print('recieved Changes: user = $user');
      _user = user;
      notifyListeners();
    });
  }

  User? get user => _user;
  // bool get isAuthenticated => user != null;
  bool get loading => _loading;

  void setLoading(bool value) {
    _loading = value;
    notifyListeners();
  }

  Future<void> login(String email, String password) async {
    setLoading(true);
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'invalid-email') {
        print('無效的電子信箱！');
      } else if (e.code == 'user-disabled') {
        print('此帳號已被停用。');
      } else if (e.code == 'user-not-found') {
        print('帳號不存在，請先建立帳號。');
      } else if (e.code == 'wrong-password') {
        print('密碼錯誤！');
      } else {
        print('登入錯誤 : $e');
      }
    } catch (e) {
      print('登入錯誤 : $e');
    }
    setLoading(false);
  }

  Future<void> register(
      BuildContext context, String email, String password, Map userInfo) async {
    setLoading(true);
    try {
      UserCredential userCredential = await _auth
          .createUserWithEmailAndPassword(email: email, password: password);
      AuthCredential credential =
          EmailAuthProvider.credential(email: email, password: password);
      UserCredential result = await _auth.signInWithCredential(credential);
      await ApiMethod().postMethod("Members", userInfo);
      print('userCredential : $userCredential');
      print('credential : $credential');
      print('result : $result');
      print('Current user after registration: ${_auth.currentUser}');
      notifyListeners();
      Navigator.pop(context);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        print('密碼強度不足。');
      } else if (e.code == 'email-already-in-use') {
        print('此帳號已被使用。');
      } else if (e.code == 'invalid-email') {
        print('無效的電子郵件！');
      } else {
        print('註冊錯誤 : $e');
      }
    } catch (e) {
      print('註冊錯誤 : $e');
    }
    setLoading(false);
  }

  Future<void> logout() async {
    await _auth.signOut();
  }

  Future<void> resetPassword(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'invalid-email') {
        print('無效的電子郵件！');
      } else if (e.code == 'user-not-found') {
        print('帳號不存在，請先建立帳號。');
      } else {
        print('重設密碼錯誤 : $e');
      }
    } catch (e) {
      print('重設密碼錯誤 : $e');
    }
  }

  Future<void> changePassword(
      BuildContext context, String oldPassword, String newPassword) async {
    final userEmail = user!.email;
    setLoading(true);
    try {
      final credential = EmailAuthProvider.credential(
          email: userEmail!, password: oldPassword);
      await user?.reauthenticateWithCredential(credential).then(
            (value) => user?.updatePassword(newPassword).then((value) {
              print("Successfully changed password");
            }).catchError((e) {
              if (e.code == 'weak-password') {
                print('密碼強度不足。');
              } else {
                print('變更密碼錯誤 : $e');
              }
            }),
          );
    } on FirebaseAuthException catch (e) {
      print(e);
      // throw(e);
    }
    setLoading(false);
  }

  Future<void> deleteUserAccount(String password) async {
    final userEmail = user!.email;
    try {
      EmailAuthProvider.credential(email: userEmail!, password: password);
      await _auth.currentUser!.delete();
    } on FirebaseAuthException catch (e) {
      if (e.code == "requires-recent-login") {
        await _reauthenticateAndDelete();
      } else {
        print(e);
      }
    } catch (e) {
      print(e);
    }
  }

  Future<void> _reauthenticateAndDelete() async {
    try {
      final providerData = _auth.currentUser?.providerData.first;

      if (AppleAuthProvider().providerId == providerData!.providerId) {
        await _auth.currentUser!
            .reauthenticateWithProvider(AppleAuthProvider());
      } else if (GoogleAuthProvider().providerId == providerData.providerId) {
        await _auth.currentUser!
            .reauthenticateWithProvider(GoogleAuthProvider());
      }
      await _auth.currentUser?.delete();
    } catch (e) {
      print(e);
    }
  }
}
