import 'package:enlight/components/loading_indicator.dart';
import 'package:enlight/components/rating_menu.dart';
import 'package:enlight/services/auth_service.dart';
import 'package:enlight/services/reservation_service.dart';
import 'package:enlight/util/messenger.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Reservations extends StatefulWidget {
  const Reservations({super.key});

  @override
  State<Reservations> createState() => _TeacherReservations();
}

class _TeacherReservations extends State<Reservations> {
  var loading = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final authService = AuthService.of(context);
    final role = authService.role;
    return Stack(
      children: [
        Scaffold(
          body: Consumer<ReservationService>(
            builder: (context, value, child) {
              if (value.data.isNotEmpty) {
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
                                for (var reservation in value.data)
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
                                                if (role == 1)
                                                  Text(
                                                      "Teacher: ${reservation.teacherName}"),
                                                if (role == 2)
                                                  Text(
                                                      "Student: ${reservation.studentName}"),
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
                                          if (role == 1)
                                            Column(
                                              children: [
                                                const SizedBox(height: 10),
                                                ElevatedButton(
                                                  onPressed: () async {
                                                    setState(
                                                        () => loading = true);
                                                    final response = await value
                                                        .completeReservation(
                                                      context,
                                                      reservation,
                                                    );
                                                    setState(
                                                        () => loading = false);
                                                    if (response.statusCode !=
                                                        200) {
                                                      return;
                                                    }
                                                    if (!context.mounted) {
                                                      return;
                                                    }
                                                    final result =
                                                        await showModalBottomSheet<
                                                            double>(
                                                      context: context,
                                                      builder: (context) =>
                                                          RatingMenu(
                                                        context: context,
                                                      ),
                                                    );
                                                    if (!context.mounted) {
                                                      return;
                                                    }
                                                    if (result == null) {
                                                      return;
                                                    }
                                                    setState(
                                                        () => loading = true);
                                                    await value.rateTeacher(
                                                      context,
                                                      reservation.reservationId,
                                                      reservation.teacherId,
                                                      result,
                                                    );
                                                    setState(
                                                        () => loading = false);
                                                  },
                                                  child: const Text("Complete"),
                                                ),
                                              ],
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
              return const Center(child: Text('No reservations available'));
            },
          ),
        ),
        if (loading) const LoadingIndicator(visible: true),
      ],
    );
  }
}
