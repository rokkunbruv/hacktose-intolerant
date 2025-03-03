import 'package:flutter/material.dart';

import 'package:tultul/theme/colors.dart';
import 'package:tultul/theme/text_styles.dart';

class Loading extends StatefulWidget {
  final String? loadingMessage;
  
  const Loading({
    super.key,
    this.loadingMessage,
  });

  @override
  State<Loading> createState() => _LoadingState();
}

class _LoadingState extends State<Loading> {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(AppColors.navy),
        ),
        SizedBox(height: 16),
        Text(
          '${widget.loadingMessage ?? 'Loading'}...',
          style: AppTextStyles.label5.copyWith(
            color: AppColors.navy
          ),
        ),
      ],
    );
  }
}