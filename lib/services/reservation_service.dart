import 'package:enlight/models/student_reservation_data.dart';
import 'package:enlight/util/account_ops.dart';
import 'package:enlight/util/teacher_ops.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class ReservationService extends ChangeNotifier {
  Future<List<ReservationData>>? reservations;
  int _newReservations = -1;
  int get newReservations => _newReservations;

  ReservationService() {
    final database = FirebaseDatabase.instance.ref("reservation");
    reservations = AccountOps.getReservation();
    reservations!.then((value) {
      notifyListeners();
    });
    TeacherOps.getTeacher().then(
      (teacher) {
        final id = teacher.teacher.id;
        final ref = database.child(id.toString());
        ref.onValue.listen(
          (event) async {
            reservations = AccountOps.getReservation();
            reservations!.then(
              (value) {
                _newReservations++;
                notifyListeners();
              },
            );
          },
        );
      },
    );
  }

  void readReservations() {
    _newReservations = 0;
    notifyListeners();
  }

  static void addReservation(int teacherId) {
    final database = FirebaseDatabase.instance.ref("reservation");
    final ref = database.child(teacherId.toString());
    final key = ref.push().key!;
    final Map<String, dynamic> updates = {};
    updates[key] = "si";
    ref.update(updates);
  }
}
