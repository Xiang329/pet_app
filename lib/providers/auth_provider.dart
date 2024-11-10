import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pet_app/model/member.dart';
import 'package:pet_app/services/members_service.dart';

class AuthModel extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  User? _user;

  AuthModel() {
    _auth.authStateChanges().listen((User? user) {
      debugPrint('recieved Changes: user = $user');
      _user = user;
      notifyListeners();
    });
  }

  User? get user => _user;

  Future<void> login(String email, String password) async {
    try {
      await MembersService.getMemberByEmail(email).then((_) async {
        await _auth.signInWithEmailAndPassword(
            email: email, password: password);
      });
      notifyListeners();
    } on FirebaseAuthException catch (e) {
      // 受電子郵件列舉防護功能影響，只會拋出某些錯誤。
      if (e.code == 'invalid-email') {
        throw ('無效的電子信箱！');
      } else if (e.code == 'user-disabled') {
        throw ('此帳號已被停用。');
      } else if (e.code == 'user-not-found') {
        throw ('帳號不存在，請先建立帳號。');
      } else if (e.code == 'wrong-password') {
        throw ('密碼錯誤！');
      } else if (e.code == 'invalid-credential') {
        throw ('請檢查您的帳號和密碼，然後再試一次。');
      } else if (e.code == 'too-many-requests') {
        throw ('由於嘗試登入的失敗次數過多，此帳號已暫時停用，請稍後再試。');
      } else {
        throw ('${e.message}');
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<void> register(BuildContext context, String email, String password,
      Map<String, dynamic> userInfo) async {
    try {
      Member? member;
      try {
        await MembersService.getMemberByEmail(email).then((m) {
          member = m;
          throw ('此帳號已被註冊。');
        });
      } catch (e) {
        if (e == '此帳號已被註冊。') rethrow;
      }
      if (member == null) {
        await MembersService.createMember(userInfo).then((_) async {
          await _auth.createUserWithEmailAndPassword(
              email: email, password: password);
          AuthCredential credential =
              EmailAuthProvider.credential(email: email, password: password);
          await _auth.signInWithCredential(credential);
        });
      }
      // await _auth
      //     .createUserWithEmailAndPassword(email: email, password: password)
      //     .then((userCredential) async {
      //   AuthCredential credential =
      //       EmailAuthProvider.credential(email: email, password: password);
      //   UserCredential result = await _auth.signInWithCredential(credential);
      //   await MembersService.createMember(userInfo);
      //   // debugPrint('userCredential : $userCredential');
      //   // debugPrint('credential : $credential');
      //   debugPrint('result : $result');
      //   // debugPrint('Current user after registration: ${_auth.currentUser}');
      // });
      notifyListeners();
      if (!context.mounted) return;
      Navigator.of(context).pop();
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        throw ('密碼強度不足。');
      } else if (e.code == 'email-already-in-use') {
        throw ('此帳號已被註冊。');
      } else if (e.code == 'invalid-email') {
        throw ('無效的電子郵件！');
      } else if (e.code == 'admin-restricted-operation') {
        throw ('系統目前暫停註冊。');
      } else if (e.code == 'network-request-failed') {
        throw ('無法連線至伺服器，請檢查網路連線。');
      } else {
        throw ('${e.message}');
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<void> logout() async {
    await _auth.signOut();
  }

  Future<void> resetPassword({String? email}) async {
    final userEmail = email ?? _user!.email;
    try {
      await _auth.sendPasswordResetEmail(email: userEmail!);
    } on FirebaseAuthException catch (e) {
      // 受電子郵件列舉防護功能影響，只會拋出某些錯誤。
      if (e.code == 'invalid-email') {
        throw ('無效的電子郵件！');
      } else if (e.code == 'user-not-found') {
        throw ('帳號不存在，請先建立帳號。');
      } else if (e.code == 'network-request-failed') {
        throw ('無法連線至伺服器，請檢查網路連線。');
      } else {
        throw ('重設密碼錯誤 : ${e.toString()}');
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<void> changePassword(
      BuildContext context, String oldPassword, String newPassword) async {
    final userEmail = _user!.email;
    try {
      final credential = EmailAuthProvider.credential(
          email: userEmail!, password: oldPassword);
      await _user
          ?.reauthenticateWithCredential(credential)
          .then((value) => _user?.updatePassword(newPassword));
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        throw ('密碼強度不足。');
      } else if (e.code == 'invalid-credential') {
        throw ('請檢查您的電子郵件和密碼是否正確。');
      } else if (e.code == 'too-many-requests') {
        throw ('由於嘗試的失敗次數過多，此帳號已暫時停用，請稍後再試。');
      } else if (e.code == 'network-request-failed') {
        throw ('無法連線至伺服器，請檢查網路連線。');
      } else {
        throw ('變更密碼錯誤 : ${e.message}');
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<void> deleteUserAccount(int memberId, String password) async {
    final userEmail = _user!.email;
    try {
      final credential =
          EmailAuthProvider.credential(email: userEmail!, password: password);
      await _user?.reauthenticateWithCredential(credential).then(
            (value) async => await MembersService.deleteMember(memberId).then(
              (_) async => await _user?.delete(),
            ),
          );
      notifyListeners();
    } on FirebaseAuthException catch (e) {
      if (e.code == 'invalid-credential') {
        throw ('請檢查您密碼是否正確。');
      } else if (e.code == 'too-many-requests') {
        throw ('由於嘗試的失敗次數過多，此帳號已暫時停用，請稍後再試。');
      } else if (e.code == 'network-request-failed') {
        throw ('無法連線至伺服器，請檢查網路連線。');
      } else {
        throw ('刪除帳號錯誤 : ${e.message}');
      }
    } catch (e) {
      rethrow;
    }
  }
}
