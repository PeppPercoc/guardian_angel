import 'package:flutter/material.dart';
import 'package:guardian_angel/styles/app_colors.dart';

class LoadingScreen extends StatelessWidget {

  const LoadingScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundSecondary,
      body: Center(
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(AppColors.secondary),
          strokeWidth: 3,
        ),
      ),
    );
  }
}
