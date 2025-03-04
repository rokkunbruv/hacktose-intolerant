import 'package:flutter/material.dart';

import 'package:tultul/theme/text_styles.dart';
import 'package:tultul/theme/colors.dart';

class ActionDialogPrompt extends StatefulWidget {
  final String title;
  final String content;
  final String acceptButtonLabel;
  
  const ActionDialogPrompt({
    super.key,
    required this.title,
    required this.content,
    required this.acceptButtonLabel,
  });

  @override
  State<ActionDialogPrompt> createState() => _ActionDialogPromptState();
}

class _ActionDialogPromptState extends State<ActionDialogPrompt> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        widget.title,
        style: AppTextStyles.label3,
      ),
      content: Text(
        widget.content,
        style: AppTextStyles.label5,
      ),
      actions: <Widget>[
        TextButton(
          child: Text(
            'Cancel',
            style: AppTextStyles.label4.copyWith(
              color: AppColors.red,
            )
          ),
          onPressed: () => Navigator.of(context).pop(false),
        ),
        TextButton(
          child: Text(
            widget.acceptButtonLabel,
            style: AppTextStyles.label4
          ),
          onPressed: () =>
            Navigator.of(context).pop(true),
        ),
      ],
    );
  }
}