import 'dart:convert';
import 'package:enlight/util/web_client.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

const _httpStatusOk = 200;
const _httpStatusUnauthorized = 401;

class AuthServiceProvider extends StatefulWidget {
  final Widget _child;
  final String _serverAddress;

  const AuthServiceProvider({
    super.key,
    required Widget child,
    required String serverAddress,
  })  : _child = child,
        _serverAddress = serverAddress;

  @override
  State<AuthServiceProvider> createState() => _AuthServiceProviderState();
}

class _AuthServiceProviderState extends State<AuthServiceProvider> {
  String _accessToken = "";
  String _refreshToken = "";
  int _role = -1;

  @override
  initState() {
    super.initState();
    SharedPreferences.getInstance().then((instance) => {
          setState(() {
            _accessToken = instance.getString("access_token") ?? "";
            _refreshToken = instance.getString("refresh_token") ?? "";
            _role = int.tryParse(instance.getString("role") ?? "-1") ?? -1;
          })
        });
  }

  Future<void> _setAccessToken(String token) async {
    final instance = await SharedPreferences.getInstance();
    await instance.setString("access_token", token);
    setState(() {
      _accessToken = token;
    });
  }

  Future<void> _setRefreshToken(String token) async {
    final instance = await SharedPreferences.getInstance();
    await instance.setString("refresh_token", token);
    setState(() {
      _refreshToken = token;
    });
  }

  Future<void> _setRole(int role) async {
    final instance = await SharedPreferences.getInstance();
    await instance.setString("role", role.toString());
    setState(() {
      _role = role;
    });
  }

  Future<void> _clearTokens() async {
    final instance = await SharedPreferences.getInstance();
    await instance.remove("access_token");
    await instance.remove("refresh_token");
    await instance.remove("role");
    setState(() {
      _accessToken = "";
      _refreshToken = "";
      _role = -1;
    });
  }

  Future<http.Response> _login(
    String email,
    String password, {
    BuildContext? context,
  }) async {
    final response = await http.post(
      Uri.parse("${widget._serverAddress}/login"),
      headers: {
        "Content-Type": "application/json",
      },
      body: json.encode({
        "email": email,
        "password": password,
      }),
    );
    if (context != null && context.mounted) WebClient.info(response, context);
    if (response.statusCode == _httpStatusOk) {
      final data = json.decode(response.body);
      final id = data["account_id"].toString();
      if (!kIsWeb) {
        await FirebaseMessaging.instance.subscribeToTopic(id);
      }
      await _setAccessToken(data["access_token"]);
      await _setRefreshToken(data["refresh_token"]);
      await _setRole(data["role"]);
    }
    return response;
  }

  Future<http.Response> _logout({BuildContext? context}) async {
    final response = await http.get(
      Uri.parse("${widget._serverAddress}/logout"),
      headers: {
        "Authorization": "Bearer $_refreshToken",
      },
    );
    if (context != null && context.mounted) WebClient.info(response, context);
    final data = json.decode(response.body);
    final id = data["account_id"].toString();
    await FirebaseMessaging.instance.unsubscribeFromTopic(id);
    await _clearTokens();
    return response;
  }

  Future<http.Response> _refresh({BuildContext? context}) async {
    final response = await http.get(
      Uri.parse("${widget._serverAddress}/refresh"),
      headers: {
        "Authorization": "Bearer $_refreshToken",
      },
    );
    if (context != null && context.mounted) WebClient.info(response, context);
    if (response.statusCode == _httpStatusOk) {
      final data = json.decode(response.body);
      await _setAccessToken(data["access_token"]);
    }
    if (response.statusCode == _httpStatusUnauthorized) await _clearTokens();
    return response;
  }

  @override
  Widget build(BuildContext context) {
    return AuthService._(
      login: _login,
      logout: _logout,
      refresh: _refresh,
      accessToken: _accessToken,
      refreshToken: _refreshToken,
      role: _role,
      child: widget._child,
    );
  }
}

class AuthService extends InheritedWidget {
  final Future<http.Response> Function(
    String email,
    String password, {
    BuildContext? context,
  }) login;
  final Future<http.Response> Function({BuildContext? context}) logout;
  final Future<http.Response> Function({BuildContext? context}) refresh;
  final String accessToken;
  final String refreshToken;
  final int role;

  const AuthService._({
    required super.child,
    required this.login,
    required this.logout,
    required this.refresh,
    required this.accessToken,
    required this.refreshToken,
    required this.role,
  });

  @override
  bool updateShouldNotify(covariant AuthService oldWidget) {
    return oldWidget.accessToken != accessToken ||
        oldWidget.refreshToken != refreshToken ||
        oldWidget.role != role;
  }

  static const emptyToken = "";

  static AuthServiceData of(BuildContext context) {
    final service = context.dependOnInheritedWidgetOfExactType<AuthService>()!;
    return AuthServiceData._(
      login: service.login,
      logout: service.logout,
      refresh: service.refresh,
      accessToken: service.accessToken,
      refreshToken: service.refreshToken,
      role: service.role,
    );
  }
}

class AuthServiceData {
  final Future<http.Response> Function(
    String email,
    String password, {
    BuildContext? context,
  }) login;
  final Future<http.Response> Function({BuildContext? context}) logout;
  final Future<http.Response> Function({BuildContext? context}) refresh;
  final String accessToken;
  final String refreshToken;
  final int role;

  const AuthServiceData._({
    required this.login,
    required this.logout,
    required this.refresh,
    required this.accessToken,
    required this.refreshToken,
    required this.role,
  });
}
