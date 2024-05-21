import 'package:enlight/models/student_reservation_data.dart';
import 'package:enlight/pages/teacher_profile/teacher_profile_from_search.dart';
import 'package:enlight/util/account_ops.dart';
import 'package:enlight/util/student_navigation_bar.dart';
import 'package:flutter/material.dart';

class StudentReservations extends StatefulWidget {
  const StudentReservations({super.key});

  @override
  State<StudentReservations> createState() => _StudentReservations();
}

class _StudentReservations extends State<StudentReservations> {
  late Future<List<StudentReservationData>> data;

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
                                              id: reservation.teacherId)));
                                },
                                child: Container(
                                  margin:
                                      const EdgeInsets.symmetric(vertical: 10),
                                  padding: const EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                    border: Border.all(color: Colors.grey),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
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
                              ),
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
      bottomNavigationBar: const StudentNavigationBar(
        index: 1,
      ),
    );
  }
}
