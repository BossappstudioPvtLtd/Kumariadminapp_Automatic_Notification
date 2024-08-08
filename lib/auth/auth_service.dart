import 'package:firebase_database/firebase_database.dart';

class AuthService {
  final DatabaseReference _database = FirebaseDatabase.instance.ref().child('admin');

  Future<bool> register(String username, String password) async {
    DataSnapshot snapshot = await _database.child(username).get();
    if (snapshot.exists) {
      return false; // Username already exists
    } else {
      await _database.child(username).set({'password': password});
      return true;
    }
  }

  Future<bool> signIn(String username, String password) async {
    DataSnapshot snapshot = await _database.child(username).get();
    if (snapshot.exists) {
      Map<String, dynamic> user = Map<String, dynamic>.from(snapshot.value as Map);
      if (user['password'] == password) {
        return true;
      }
    }
    return false;
  }

  Future<void> updateUsernameAndPassword(String oldUsername, String newUsername, String newPassword) async {
    DataSnapshot snapshot = await _database.child(oldUsername).get();
    if (snapshot.exists) {
      await _database.child(oldUsername).remove();
      await _database.child(newUsername).set({
        'password': newPassword,
      });
    }
  }
}
