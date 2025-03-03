import 'package:flutter/material.dart';

import 'package:tultul/theme/colors.dart';
import 'package:tultul/theme/text_styles.dart';

class FinishedRoutePage extends StatefulWidget {
  const FinishedRoutePage({super.key});

  @override
  State<FinishedRoutePage> createState() => _FinishedRoutePageState();
}

class _FinishedRoutePageState extends State<FinishedRoutePage> {
  void navigateToHome() {
    Navigator.of(context).pop();
    Navigator.of(context).pop();
    Navigator.of(context).pop();
    Navigator.of(context).pop();
  }

  void navigateBack() {
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            'assets/img/yippie_icon.png',
            width: 300,
            height: 300,
          ),
          const SizedBox(
            height: 10,
          ),
          Column(
            children: [
              Text('YIPPIE!',
                  style: AppTextStyles.title.copyWith(color: AppColors.red)),
              const SizedBox(
                height: 1,
              ),
              Text('You have arrived.',
                  style:
                      AppTextStyles.label3.copyWith(color: AppColors.yellow)),
              const SizedBox(
                height: 200,
              ),
              TextButton(
                  onPressed: navigateBack,
                  child: Container(
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                        color: AppColors.vanilla,
                        borderRadius: BorderRadius.circular(50)),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.arrow_back_ios, color: AppColors.red),
                        Text('Back to your Route',
                            style: AppTextStyles.label3
                                .copyWith(color: AppColors.red)),
                      ],
                    ),
                  )
                ),
              TextButton(
                  onPressed: navigateToHome,
                  child: Container(
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                        color: AppColors.red,
                        borderRadius: BorderRadius.circular(50)),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.arrow_back_ios, color: AppColors.vanilla),
                        Text('Back to Home',
                            style: AppTextStyles.label3
                                .copyWith(color: AppColors.vanilla)),
                      ],
                    ),
                  )
                ),
            ],
          ),
        ],
      ),
    );
  }
}
