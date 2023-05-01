import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/foundation.dart';
import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart';
import 'package:win_ui/core/constants/constants.dart';

class AuthState extends ChangeNotifier {
  Client client = Client();
  late Account account;
  late bool _isLoggedIn;
  late User? _user;
  late String? _error;
  late bool _isLoading;

  bool get isLoggedIn => _isLoggedIn;
  User? get user => _user;
  bool get isLoading => _isLoading;
  String? get error => _error;

  AuthState() {
    _init();
  }

  void _init() {
    _isLoggedIn = false;
    _isLoading = true;
    _user = null;
    _error = null;
    client.setEndpoint(AppConstatnts.endPoint).setProject(AppConstatnts.projectId);
    account = Account(client);
    _isAuthenticated();
  }

  _isAuthenticated() async {
    try {
      _user = await account.get();
      _isLoggedIn = true;
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoggedIn = false;
      _isLoading = false;
      notifyListeners();
      print(e);
    }
  }

  void login({required String email, required String password}) async {
    try {
      await account.createEmailSession(email: email, password: password);
      _isAuthenticated();
    } catch (e) {
      print(e);
    }
  }

  void signUp({required String name, required String email, required String password}) async {
    try {
      _user = await account.create(email: email, password: password, name: name, userId: ID.unique());
      _isAuthenticated();
    } catch (e) {
      print(e);
    }
  }

  Future<bool> deleteSesion(Session session) async {
    try {
      await account.deleteSession(sessionId: session.$id);
      _isAuthenticated();
      return true;
    } catch (e) {
      _isAuthenticated();
      return false;
    }
  }

  Future<bool> updateName(String name) async {
    try {
      _user = await account.updateName(name: name);
      notifyListeners();
      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }

  Future<bool> updateEmail({required String email, required String password}) async {
    try {
      _user = await account.updateEmail(email: email, password: password);
      notifyListeners();
      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }

  Future<bool> updatePassword({required String password, required String oldPassword}) async {
    try {
      await account.updatePassword(password: password, oldPassword: oldPassword);
      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }

  void logout() async {
    try {
      await account.deleteSession(sessionId: 'current');
      _isLoggedIn = false;
      _user = null;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }
}
