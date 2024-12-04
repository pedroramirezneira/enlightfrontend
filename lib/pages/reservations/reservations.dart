import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:enlight/components/fixed_scaffold.dart';
import 'package:enlight/components/rating_menu.dart';
import 'package:enlight/pages/reservations/launch_url.dart';
import 'package:enlight/services/auth_service.dart';
import 'package:enlight/services/reservation_service.dart';
import 'package:enlight/util/messenger.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
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
    final reservationService = Provider.of<ReservationService>(context);
    final role = authService.role;

    if (reservationService.loading) {
      return const FixedScaffold(
          title: "Reservations", body: CircularProgressIndicator.adaptive());
    }
    if (reservationService.data.isEmpty && role == 1) {
      return const FixedScaffold(
        title: "Reservations",
        body: Padding(
          padding: EdgeInsets.all(24),
          child: Text(
            "You have no reservations. Search for teachers to make a reservation!",
          ),
        ),
      );
    }
    if (reservationService.data.isEmpty) {
      return const FixedScaffold(
        title: "Reservations",
        body: Padding(
          padding: EdgeInsets.all(24),
          child: Text("You have no reservations."),
        ),
      );
    }
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          const SliverAppBar(
            title: Text("Reservations"),
            floating: true,
            snap: true,
          ),
          SliverList(
            delegate: SliverChildListDelegate(
              [
                Column(
                  children: [
                    for (var reservation in reservationService.data)
                      Container(
                        width: 360,
                        margin: const EdgeInsets.symmetric(vertical: 10),
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Column(
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("Subject: ${reservation.subjectName}"),
                                if (role == 1)
                                  Text("Teacher: ${reservation.teacherName}"),
                                if (role == 2)
                                  Text("Student: ${reservation.studentName}"),
                                Text(
                                    "Date: ${DateFormat('MMMM d yyyy').format(reservation.date)}"),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Text(
                                        "Start Time: ${reservation.startTime.format(context)}"),
                                    SizedBox(width: 8),
                                    Text("-"),
                                    SizedBox(width: 8),
                                    Text(
                                        "End Time: ${reservation.endTime.format(context)}"),
                                  ],
                                ),
                              ],
                            ),
                            const SizedBox(height: 10),
                            SizedBox(
                              child: ElevatedButton(
                                onPressed: () {
                                  Messenger.showCancelReservation(
                                    context: context,
                                    reservationId: reservation.reservationId,
                                    onAccept: () =>
                                        setState(() => loading = true),
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
                                      setState(() => loading = true);
                                      final response = await reservationService
                                          .completeReservation(
                                        context,
                                        reservation,
                                      );
                                      setState(() => loading = false);
                                      if (response.statusCode != 200) {
                                        return;
                                      }
                                      if (!context.mounted) {
                                        return;
                                      }
                                      try {
                                        final getPayment =
                                            await reservationService
                                                .getPaymentInfo(
                                          context,
                                          reservation,
                                        );
                                        if (!context.mounted) return;
                                        await launchURL(context, getPayment);
                                        if (!context.mounted) return;
                                        final result =
                                            await showModalBottomSheet<double>(
                                          context: context,
                                          builder: (context) => RatingMenu(
                                            context: context,
                                          ),
                                        );
                                        if (!context.mounted) {
                                          return;
                                        }
                                        if (result == null) {
                                          return;
                                        }
                                        setState(() => loading = true);
                                        await reservationService.rateTeacher(
                                          context,
                                          reservation.reservationId,
                                          reservation.teacherId,
                                          result,
                                        );
                                        setState(() => loading = false);
                                      } catch (e) {
                                        if (context.mounted) {
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(
                                            const SnackBar(
                                              content: AwesomeSnackbarContent(
                                                title: "Error",
                                                message:
                                                    "Please add at least one timeslot",
                                                contentType: ContentType.help,
                                              ),
                                            ),
                                          );
                                        }
                                        setState(() => loading = false);
                                      }
                                    },
                                    child: const Text("Complete"),
                                  ),
                                ],
                              ),
                          ],
                        ),
                      )
                  ],
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
