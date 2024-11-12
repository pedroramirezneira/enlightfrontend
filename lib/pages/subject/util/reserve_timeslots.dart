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

  final response = await reservationService.addReservation(context, data);
  if (response.statusCode != 200 || !context.mounted) return;
  final messagingService =
      Provider.of<MessagingService>(context, listen: false);
  if (messagingService.data.chats
      .where((e) => e.account.id == teacherId)
      .isEmpty) {
    await messagingService.createChat(context, teacherId);
  }
  if (!context.mounted) return;
  Navigator.of(context).pop();
}
