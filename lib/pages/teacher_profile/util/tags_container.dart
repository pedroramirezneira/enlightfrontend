import 'package:flutter/material.dart';

class TagContainer extends StatelessWidget {
  final String name;
  final String description;
  final int price;
  final VoidCallback deleteSubject;

  const TagContainer({
    super.key,
    required this.name,
    required this.price,
    required this.description,
    required this.deleteSubject,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 71, 129, 118),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                name,
                style: const TextStyle(
                  fontFamily: 'Montserrat',
                  fontSize: 20,
                ),
              ),
            ],
          ),
          SizedBox(height: 8),
          Text(
            "Price: \$$price",
            style: const TextStyle(
              fontFamily: 'Montserrat',
              fontSize: 16,
            ),
          ),
          SizedBox(height: 8),
          Text(
            description,
            style: const TextStyle(
              fontFamily: 'Montserrat',
              fontSize: 16,
            ),
          ),
          SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextButton(
                onPressed: () {
                  deleteSubject();
                },
                style: TextButton.styleFrom(
                  backgroundColor: Colors.red,
                  padding: const EdgeInsets.all(12),
                ),
                child: const Icon(
                  Icons.delete,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
