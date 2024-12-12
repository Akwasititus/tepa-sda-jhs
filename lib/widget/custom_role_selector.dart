import 'package:flutter/material.dart';

class CustomRoleSelector extends StatefulWidget {
  final Function(String) onRoleSelected;
  final String selectedRole;

  const CustomRoleSelector({
    Key? key,
    required this.onRoleSelected,
    required this.selectedRole,
  }) : super(key: key);

  @override
  State<CustomRoleSelector> createState() => _CustomRoleSelectorState();
}

class _CustomRoleSelectorState extends State<CustomRoleSelector> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Row(
        children: [
          Icon(Icons.person_outline, color: Colors.grey),
          const SizedBox(width: 12),
          Expanded(
            child: Row(
              children: [
                Expanded(
                  child: RadioListTile<String>(
                    title: const Text('Parent'),
                    value: 'Parent',
                    groupValue: widget.selectedRole,
                    onChanged: (value) {
                      widget.onRoleSelected(value!);
                    },
                    activeColor: const Color(0xFF151864),
                    contentPadding: EdgeInsets.zero,
                  ),
                ),
                Expanded(
                  child: RadioListTile<String>(
                    title: const Text('Teacher'),
                    value: 'Teacher',
                    groupValue: widget.selectedRole,
                    onChanged: (value) {
                      widget.onRoleSelected(value!);
                    },
                    activeColor: const Color(0xFF151864),
                    contentPadding: EdgeInsets.zero,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}