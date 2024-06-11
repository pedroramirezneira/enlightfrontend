import 'package:enlight/services/reservation_service.dart';
import 'package:enlight/util/messenger.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class TeacherReservations extends StatefulWidget {
  const TeacherReservations({super.key});

  @override
  State<TeacherReservations> createState() => _TeacherReservations();
}

class _TeacherReservations extends State<TeacherReservations> {
  var loading = true;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<ReservationService>(
        builder: (context, value, child) {
          return FutureBuilder(
            future: value.reservations,
            builder: (context, snapshot) {
              if (snapshot.hasData && snapshot.data!.isNotEmpty) {
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
                                for (var reservation in snapshot.data!
                                    )
                                  Center(
                                    child: Container(
                                      width: MediaQuery.of(context).size.width *
                                          0.5,
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
                                                    "Student: ${reservation.teacherName}"),
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
                                          SizedBox(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.5,
                                            child: ElevatedButton(
                                              onPressed: () {
                                                Messenger.showCancelReservation(
                                                  context: context,
                                                  data: snapshot.data!,
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
                                              },
                                              child: const Text("Cancel"),
                                            ),
                                          ),
                                        ],
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
              if (snapshot.hasData && snapshot.data!.isEmpty) {
                return const Center(child: Text('No reservations available'));
              }
              return const Center(child: CircularProgressIndicator());
            },
          );
        },
      ),
    );
  }
}
