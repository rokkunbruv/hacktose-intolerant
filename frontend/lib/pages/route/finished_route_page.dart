import 'package:flutter/material.dart';
import 'package:tultul/pages/home_page.dart';
import 'package:tultul/theme/colors.dart';
import 'package:tultul/theme/text_styles.dart';

class FinishedRoutePage extends StatefulWidget {
  const FinishedRoutePage({super.key});

  @override
  State<FinishedRoutePage> createState() => _FinishedRoutePageState();
}

class _FinishedRoutePageState extends State<FinishedRoutePage> {
  void navigateToHome() {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => HomePage()));
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
                  ))
            ],
          ),
        ],
      ),
    );
  }
}
