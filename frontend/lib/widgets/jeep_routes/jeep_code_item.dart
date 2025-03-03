import 'package:flutter/material.dart';
import 'package:tultul/theme/colors.dart';
import 'package:tultul/theme/text_styles.dart';

// import 'package:tultul/widgets/generic/draggable_container.dart';

class JeepCodeItem extends StatefulWidget {
  final String jeepCode;
  final Widget Function() routePage;

  const JeepCodeItem(
      {super.key, required this.jeepCode, required this.routePage});

  @override
  State<JeepCodeItem> createState() => _JeepCodeItemState();
}

class _JeepCodeItemState extends State<JeepCodeItem> {
  void navigateToJeepCodeDetailsPage() {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => widget.routePage()));
  }

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: navigateToJeepCodeDetailsPage,
      style: TextButton.styleFrom(
        foregroundColor: AppColors.black,
        backgroundColor: AppColors.saffron,
        textStyle: AppTextStyles.label4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      child: Text(widget.jeepCode),
    );
  }
}
