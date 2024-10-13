import 'package:enlight/models/reservation/create_reservation_data.dart';
import 'package:enlight/services/messaging_service.dart';
import 'package:enlight/services/reservation_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

Future<void> reserveTimeslots({
  required BuildContext context,
  required int teacherId,
  required CreateReservationData data,
}) async {
  final reservationService =
      Provider.of<ReservationService>(context, listen: false);
  final messagingService =
      Provider.of<MessagingService>(context, listen: false);
  await reservationService.addReservation(context, data);
  if (!context.mounted) return;
  if (messagingService.data.chats.where((e) => e.id == teacherId).isNotEmpty) {
    messagingService.createChat(context, teacherId);
  }
}
