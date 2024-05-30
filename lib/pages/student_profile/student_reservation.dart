import 'package:enlight/models/student_reservation_data.dart';
import 'package:enlight/pages/teacher_profile/teacher_profile_from_search.dart';
import 'package:enlight/util/account_ops.dart';
import 'package:enlight/util/messenger.dart';
import 'package:flutter/material.dart';

class StudentReservations extends StatefulWidget {
  const StudentReservations({super.key});

  @override
  State<StudentReservations> createState() => _StudentReservations();
}

class _StudentReservations extends State<StudentReservations> {
  late Future<List<ReservationData>> data;
  var loading = true;

  @override
  void initState() {
    super.initState();
    data = AccountOps.getReservation();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        future: data,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No reservations available'));
          } else {
            return CustomScrollView(
              slivers: [
                const SliverAppBar(
                  title: Text("Reservations"),
                  centerTitle: true,
                ),
                SliverList(
                  delegate: SliverChildListDelegate(
                    [
                      Center(
                        child: Column(
                          children: [
                            for (var reservation in snapshot.data!)
                              GestureDetector(
                                onTap: () {
                                  Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) =>
                                        TeacherProfileFromSearch(
                                            id: reservation.teacherId),
                                  ));
                                },
                                child: Center(
                                  child: Container(
                                    width:
                                        MediaQuery.of(context).size.width * 0.8,
                                    margin: const EdgeInsets.symmetric(
                                        vertical: 10),
                                    padding: const EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                      border: Border.all(color: Colors.grey),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Center(
                                          child: Column(
                                            children: [
                                              Text(
                                                  "Subject: ${reservation.subjectName}"),
                                              Text(
                                                  "Teacher: ${reservation.teacherName}"),
                                              Text(
                                                  "Date: ${reservation.date.toLocal().toString().split(' ')[0]}"),
                                              Text(
                                                  "Start Time: ${reservation.startTime.format(context)}"),
                                              Text(
                                                  "End Time: ${reservation.endTime.format(context)}"),
                                            ],
                                          ),
                                        ),
                                        const SizedBox(height: 10),
                                        ElevatedButton(
                                          onPressed: () {
                                            data.then((data) {
                                              Messenger.showCancelReservation(
                                                context: context,
                                                data: data,
                                                reservationId:
                                                    reservation.reservationId,
                                                onAccept: () => setState(
                                                    () => loading = true),
                                                onResponse: () {
                                                  setState(() {
                                                    loading = false;
                                                  });
                                                },
                                              );
                                            });
                                          },
                                          child: const Text("Cancel"),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              )
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ],
            );
          }
        },
      ),
    );
  }
}
