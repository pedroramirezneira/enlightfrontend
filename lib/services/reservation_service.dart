import 'dart:convert';
import 'package:enlight/models/reservation/create_reservation_data.dart';
import 'package:enlight/models/reservation/reservation_data.dart';
import 'package:enlight/models/reservation/reservation_data_dto.dart';
import 'package:enlight/services/auth_service.dart';
import 'package:enlight/util/web_client.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart';

class ReservationService extends ChangeNotifier {
  List<ReservationData> _data = [];
  List<ReservationData> get data => _data;
  int _newReservations = 0;
  int get newReservations => _newReservations;
  var _loading = true;
  bool get loading => _loading;
  int _accountId = -1;

  ReservationService({required BuildContext context}) {
    WidgetsBinding.instance.addPostFrameCallback(
      (_) async {
        final database = FirebaseDatabase.instance.ref("reservation");
        final response = await WebClient.get(context, "reservation");
        if (response.statusCode != 200) return;
        final Map<String, dynamic> data = json.decode(response.body);
        final List<dynamic> reservations = data["reservations"];
        final result = reservations.map((e) => ReservationDataDto.fromJson(e));
        _data = result.map((e) => e.toData()).toList();
        _accountId = data["account_id"];
        _loading = false;
        if (!context.mounted) return;
        final ref = database.child(_accountId.toString());
        _createListener(ref, context);
        notifyListeners();
      },
    );
  }

  void _createListener(DatabaseReference ref, BuildContext context) {
    ref.onValue.listen(
      (event) async {
        if (!context.mounted) return;
        final response = await WebClient.get(
          context,
          "reservation",
          info: false,
        );
        if (response.statusCode != 200) return;
        final List<dynamic> data = json.decode(response.body)["reservations"];
        final result = data.map((e) => ReservationDataDto.fromJson(e));
        _data = result.map((e) => e.toData()).toList();
        final count = event.snapshot.value;
        if (count == null || count is! int || count == 0) {
          _newReservations = 0;
        } else {
          _newReservations = count;
        }
        notifyListeners();
      },
    );
  }

  void readReservations() {
    final ref = FirebaseDatabase.instance.ref("reservation");
    final count = ref.child(_accountId.toString());
    _resetCount(count);
    notifyListeners();
  }

  Future<Response> addReservation(
    BuildContext context,
    CreateReservationData data,
  ) async {
    final response = await WebClient.post(
      context,
      "reservation",
      headers: {
        "Content-Type": "application/json",
      },
      body: json.encode(data.toJson()),
    );
    if (!context.mounted) return response;
    if (response.statusCode == 200) {
      final newResponse = Response("Reservation created successfully", 200);
      WebClient.info(newResponse, context);
      final reload = await WebClient.get(context, "reservation", info: false);
      if (reload.statusCode == 200) {
        final List<dynamic> newData = json.decode(reload.body)["reservations"];
        final result = newData.map((json) => ReservationDataDto.fromJson(json));
        _data = result.map((e) => e.toData()).toList();
        final reservationId = response.body;
        final reservation = _data.firstWhere(
          (e) => e.reservationId == int.parse(reservationId),
        );
        _notifyFirebase(reservation.teacherId);
        notifyListeners();
      }
    }
    return response;
  }

  Future<void> cancelReservation(
    BuildContext context,
    int id,
  ) async {
    final response = await WebClient.delete(
      context,
      "reservation",
      headers: {
        "Content-Type": "application/json",
      },
      body: json.encode({
        "id": "$id",
      }),
    );
    if (!context.mounted) return;
    if (response.statusCode == 200) {
      final reservation = _data.firstWhere((e) => e.reservationId == id);
      _data.removeWhere((e) => e.reservationId == id);
      notifyListeners();
      final authService = AuthService.of(context);
      final otherId =
          authService.role == 1 ? reservation.teacherId : reservation.studentId;
      _notifyFirebase(otherId);
    }
  }

  Future<Response> completeReservation(
    BuildContext context,
    ReservationData data,
  ) async {
    final response = await WebClient.get(
      context,
      "rating?reservation_id=${data.reservationId}",
    );
    return response;
  }

  Future<String> getPaymentInfo(
    BuildContext context,
    ReservationData data,
  ) async {
    final response = await WebClient.post(
      context,
      "pay",
      headers: {
        "Content-Type": "application/json",
      },
      body: json.encode(
        {
          "teacher_name": data.teacherName,
          "subject_id": data.subjectId,
        },
      ),
    );
    final String url = json.decode(response.body);
    return url;
  }

  Future<Response> rateTeacher(
    BuildContext context,
    int reservationId,
    int teacherId,
    double rating,
  ) async {
    final response = await WebClient.put(
      context,
      "rating",
      headers: {
        "Content-Type": "application/json",
      },
      body: json.encode(
        {
          "reservation_id": reservationId,
          "teacher_id": teacherId,
          "rating": rating,
        },
      ),
    );
    if (response.statusCode == 200) {
      final reservation =
          _data.firstWhere((e) => e.reservationId == reservationId);
      _data.remove(reservation);
      notifyListeners();
      _notifyFirebase(teacherId);
    }
    return response;
  }

  void _notifyFirebase(int id) {
    final database = FirebaseDatabase.instance.ref("reservation");
    final ref = database.child(id.toString());
    _increaseCount(ref);
  }

  void _increaseCount(DatabaseReference count) {
    count.runTransaction((value) {
      if (value == null || value is! int || value == 0) {
        return Transaction.success(1);
      }
      return Transaction.success((value) + 1);
    });
  }

  void _resetCount(DatabaseReference count) {
    count.set(0);
  }
}
