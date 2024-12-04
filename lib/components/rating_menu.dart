import 'package:flutter/material.dart';
import 'package:flutter_rating_stars/flutter_rating_stars.dart';

class RatingMenu extends StatefulWidget {
  const RatingMenu({super.key});

  @override
  State<RatingMenu> createState() => _RatingMenuState();
}

class _RatingMenuState extends State<RatingMenu> {
  double rating = 0; // Initial rating

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0),
      ),
      child: Material(
        // Ensures proper rendering of interactive widgets
        color: Colors.transparent,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                "Califica usando estrellas:",
                style: TextStyle(fontSize: 18),
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: 220, // Set an explicit width to the RatingStars widget
                child: RatingStars(
                  value: rating,
                  onValueChanged: (v) {
                    setState(() {
                      rating = v;
                    });
                  },
                  starBuilder: (index, color) => Icon(
                    Icons.star,
                    color: color,
                  ),
                  starCount: 5,
                  starSize: 40,
                  valueLabelColor: const Color(0xff9b9b9b),
                  valueLabelTextStyle: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w400,
                    fontStyle: FontStyle.normal,
                    fontSize: 12.0,
                  ),
                  valueLabelRadius: 10,
                  maxValue: 5,
                  starSpacing: 2,
                  maxValueVisibility: true,
                  valueLabelVisibility: true,
                  // Remove or comment out the animationDuration
                  // animationDuration: Duration.zero,
                  valueLabelPadding: const EdgeInsets.symmetric(
                    vertical: 1,
                    horizontal: 8,
                  ),
                  valueLabelMargin: const EdgeInsets.only(right: 8),
                  starOffColor: const Color(0xffe7e8ea),
                  starColor: Colors.amber,
                ),
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () {
                  final result = rating * 2; // Convert rating to points
                  Navigator.of(context).pop(result); // Return the result
                },
                child: const Text("Enviar"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Function to show the popup and return the rating in points
Future<double?> mostrarRatingMenu(BuildContext context) async {
  final result = await showDialog<double>(
    context: context,
    builder: (context) => const RatingMenu(),
  );

  return result; // Returns the rating in points (or null if canceled)
}
