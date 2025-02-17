import 'package:flutter/material.dart';
import 'user_repository.dart';
import 'user_model.dart';
import 'connectivity_service.dart';

class UserProvider with ChangeNotifier {
  List<User> _users = [];
  List<User> _filteredUsers = [];
  bool _isLoading = false;
  String _errorMessage = '';

  List<User> get users => _filteredUsers;
  bool get isLoading => _isLoading;
  String get errorMessage => _errorMessage;

  final UserRepository _repository = UserRepository();

  Future<void> fetchUsers() async {
    _isLoading = true;
    _errorMessage = '';
    notifyListeners();

    try {
      bool isConnected = await ConnectivityService.isConnected();
      if (!isConnected) {
        _errorMessage = 'No internet connection';
        notifyListeners();
        return;
      }

      _users = await _repository.fetchUsers();
      _filteredUsers = _users;
    } catch (e) {
      _errorMessage = 'Failed to load users: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void addUser(User user) {
    _users.add(user);
    _filteredUsers = _users;
    notifyListeners();
  }

  void filterUsers(String query) {
    _filteredUsers = _users
        .where((user) =>
            user.name.toLowerCase().contains(query.toLowerCase()))
        .toList();
    notifyListeners();
  }
}