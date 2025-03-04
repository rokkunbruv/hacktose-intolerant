import 'package:flutter/material.dart';

import 'package:tultul/styles/widget/box_shadow_style.dart';
import 'package:tultul/theme/colors.dart';
import 'package:tultul/theme/text_styles.dart';

class DropdownSelectButton extends StatefulWidget {
  final List<String> items;
  final Function(String) onChanged;

  const DropdownSelectButton({
    super.key,
    required this.items,
    required this.onChanged,
  });

  @override
  State<DropdownSelectButton> createState() => _DropdownSelectButtonState();
}

class _DropdownSelectButtonState extends State<DropdownSelectButton> {
  String? _selectedItem;
  double _buttonWidth = 100; // Initial width, will be updated dynamically

  @override
  void initState() {
    super.initState();
    _selectedItem = widget.items[0]; // Set initial selected item
    _updateButtonWidth(_selectedItem!); // Calculate initial width
  }

  void _updateButtonWidth(String text) {
    final TextPainter textPainter = TextPainter(
      text: TextSpan(
        text: text,
        style: AppTextStyles.label5.copyWith(
          color: AppColors.black,
        ),
      ), // Match the text style of the dropdown
      textDirection: TextDirection.ltr,
    )..layout();

    // Add some padding to the calculated width
    setState(() {
      _buttonWidth = textPainter.width + 48; // Adjust padding as needed
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: _buttonWidth,
      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          createBoxShadow(),
        ],
      ),
      child: DropdownButton<String>(
        value: _selectedItem, // The currently selected value
        onChanged: (String? newValue) {
          if (newValue != null) {
            setState(() {
              widget.onChanged(newValue);
              _selectedItem = newValue; // Update the selected value
              _updateButtonWidth(newValue); // Update the button width
            });
          }
        },
        items: widget.items.map<DropdownMenuItem<String>>((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(value),
          );
        }).toList(),
        dropdownColor: AppColors.white,
        icon: Icon(Icons.arrow_drop_down),
        iconEnabledColor: AppColors.red,
        isDense: true,
        isExpanded: true,
        style: AppTextStyles.label5.copyWith(
          color: AppColors.black,
        ),
        underline: Container(),
      ),
    );
  }
}