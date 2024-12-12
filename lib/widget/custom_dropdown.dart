import 'package:flutter/material.dart';

class CustomDropdown extends StatefulWidget {
  final TextEditingController controller;
  final IconData prefixIcon;
  final String studentLevel;
  final List<String> level;

  const CustomDropdown({
    super.key,
    required this.controller,
    required this.prefixIcon,
    required this.studentLevel,
    required this.level
  });

  @override
  State<CustomDropdown> createState() => _CustomDropdownState();
}

class _CustomDropdownState extends State<CustomDropdown> {
  String? selectedLevel;

  // final List<String> levels = [
  //   'JW1', 'JW2', 'JW3',
  //   'JB1', 'JB2', 'JB3',
  //   'EW1', 'EW2', 'EW3'
  // ];

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color:  Colors.grey[100],
        borderRadius: BorderRadius.circular(8),
        // border: Border.all(color: Colors.grey.shade300),
      ),
      child: Row(
        children: [
          Icon(widget.prefixIcon, color: const Color(0xFF151864)),
          const SizedBox(width: 12),
          Expanded(
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: selectedLevel,
                hint: Text(widget.studentLevel),
                isExpanded: true,
                items: widget.level.map((String level) {
                  return DropdownMenuItem<String>(
                    value: level,
                    child: Text(level),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    selectedLevel = newValue;
                    widget.controller.text = newValue ?? '';
                  });
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}