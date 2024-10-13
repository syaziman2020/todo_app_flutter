import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/extensions/size_extension.dart';
import 'home_page.dart';
import '../../../core/assets/assets.gen.dart';
import '../../../core/constants/font_styles.dart';

class SplashPage extends StatelessWidget {
  const SplashPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: FutureBuilder(
        future: Future.delayed(
          const Duration(milliseconds: 2500),
        ),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            Future.microtask(
              () => Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => const HomePage(),
                ),
              ),
            );
          }
          return Center(
            child: Assets.images.logo.image(width: 40.ws(context)),
          );
        },
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.only(bottom: 20),
        child: Text(
          textAlign: TextAlign.center,
          'S-ToDo v1.0.0',
          style: FontStyles.poppins.copyWith(
            fontSize: 15,
            fontWeight: FontWeight.w400,
          ),
        ),
      ),
    );
  }
}
