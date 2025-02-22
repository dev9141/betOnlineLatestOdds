import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:state_extended/state_extended.dart';

import '../data/entity/account/user.dart';
import '../data/repositories/user_repository.dart';

class UserController extends StateXController  {

  final UserRepository userRepository = UserRepository();

  bool isApiCall = false;
  bool isLoading = true;
  User user = User();
  late GlobalKey<ScaffoldState> scaffoldKey;
  bool isInternetAvailable = true;
  UserController() {
    scaffoldKey = GlobalKey<ScaffoldState>();
  }

  Future<Object> register(User user) async {
    return await userRepository.register(user);
  }
  Future<Object> registerConfirmation(User user) async {
    return await userRepository.registerConfirmation(user);
  }
  Future<Object> login(User user) async {
    return await userRepository.login(user);
  }
  Future<Object> deleteAccount(String password) async {
    return await userRepository.deleteAccount(password);
  }
  Future<Object> loginAsGuest() async {
    return await userRepository.loginAsGuest();
  }
  Future<Object> forgotPassword(User user) async {
    return await userRepository.forgotPassword(user);
  }
  Future<Object> logout() async {
    return await userRepository.logout();
  }
  Future<Object> resetPassword(User user) async {
    return await userRepository.resetPassword(user);
  }
  Future<Object> verifyEmail(String email) async {
    return await userRepository.verifyEmail(email);
  }
  Future<Object> sendTokenToServer() async {
    return await userRepository.sendTokenToServer();
  }
}