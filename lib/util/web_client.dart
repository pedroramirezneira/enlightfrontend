import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:enlight/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

class WebClient {
  const WebClient._();

  static Future<http.Response> get(
    BuildContext context,
    String path, {
    Map<String, String>? headers,
    bool info = true,
  }) async {
    final serverAddress = dotenv.env["SERVER"]!;
    final authService = AuthService.of(context);
    final response = await http.get(
      Uri.parse("$serverAddress/$path"),
      headers: {
        "Authorization": "Bearer ${authService.accessToken}",
        ...headers ?? {},
      },
    );
    if (!context.mounted) return response;
    if (response.statusCode == 401) {
      await authService.refresh();
      if (!context.mounted) return response;
      return get(context, path, headers: headers);
    }
    if (info) WebClient.info(response, context);
    return response;
  }

  static Future<http.Response> post(
    BuildContext context,
    String path, {
    Map<String, String>? headers,
    Object? body,
    bool info = true,
  }) async {
    final serverAddress = dotenv.env["SERVER"]!;
    final authService = AuthService.of(context);
    final response = await http.post(
      Uri.parse("$serverAddress/$path"),
      headers: {
        "Authorization": "Bearer ${authService.accessToken}",
        ...headers ?? {},
      },
      body: body,
    );
    if (!context.mounted) return response;
    if (response.statusCode == 401) {
      await authService.refresh();
      if (!context.mounted) return response;
      return post(context, path, headers: headers, body: body);
    }
    if (info) WebClient.info(response, context);
    return response;
  }

  static Future<http.Response> put(
    BuildContext context,
    String path, {
    Map<String, String>? headers,
    Object? body,
    bool info = true,
  }) async {
    final serverAddress = dotenv.env["SERVER"]!;
    final authService = AuthService.of(context);
    final response = await http.put(
      Uri.parse("$serverAddress/$path"),
      headers: {
        "Authorization": "Bearer ${authService.accessToken}",
        ...headers ?? {},
      },
      body: body,
    );
    if (!context.mounted) return response;
    if (response.statusCode == 401) {
      await authService.refresh();
      if (!context.mounted) return response;
      return put(context, path, headers: headers, body: body);
    }
    if (info) WebClient.info(response, context);
    return response;
  }

  static Future<http.Response> delete(
    BuildContext context,
    String path, {
    Map<String, String>? headers,
    Object? body,
    bool info = true,
  }) async {
    final authService = AuthService.of(context);
    final serverAddress = dotenv.env["SERVER"]!;
    final response = await http.delete(
      Uri.parse("$serverAddress/$path"),
      headers: {
        "Authorization": "Bearer ${authService.accessToken}",
        ...headers ?? {},
      },
      body: body,
    );
    if (!context.mounted) return response;
    if (response.statusCode == 401) {
      await authService.refresh();
      if (!context.mounted) return response;
      return delete(context, path, headers: headers);
    }
    if (info) WebClient.info(response, context);
    return response;
  }

  static void info(http.Response response, BuildContext context) {
    final error = response.statusCode < 200 || response.statusCode >= 300;
    final title = error ? "Error" : "Success";
    final message = response.body.isEmpty ? "Unknown Error" : response.body;
    final contentType = error ? ContentType.failure : ContentType.success;
    ScaffoldMessenger.maybeOf(context)?.showSnackBar(
      SnackBar(
        content: AwesomeSnackbarContent(
          title: title,
          message: message,
          contentType: contentType,
        ),
      ),
    );
  }
}
