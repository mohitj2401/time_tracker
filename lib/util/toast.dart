import 'package:fl_toast/fl_toast.dart';
import 'package:flutter/material.dart';

void toast(String message, BuildContext context, {bool isError = true}) {
  // HapticFeedback.lightImpact();
  // Get.showSnackbar(GetSnackBar(
  //   backgroundColor: isError ? Colors.red : Colors.black,
  //   message: message.tr,
  //   duration: const Duration(seconds: 3),
  //   snackStyle: SnackStyle.FLOATING,
  //   margin: const EdgeInsets.all(10),
  //   borderRadius: 10,
  //   isDismissible: true,
  //   dismissDirection: DismissDirection.horizontal,
  // ));

  showToast(
    padding: EdgeInsets.zero,
    alignment: Alignment(0, 1),

    /// The duration the toast will be on the screen
    duration: Duration(seconds: 4),

    /// The duration of the animation
    animationDuration: Duration(milliseconds: 200),

    /// Animate the toast to show up from the bottom
    animationBuilder: (context, animation, child) {
      return SlideTransition(
        child: child,
        position: Tween<Offset>(
          begin: Offset(0, 1),
          end: Offset(0, 0),
        ).animate(CurvedAnimation(
          parent: animation,
          curve: Curves.fastOutSlowIn,
        )),
      );
    },
    child: Dismissible(
      key: ValueKey<String>('Snackbar'),
      direction: DismissDirection.down,
      child: Material(
        elevation: Theme.of(context)?.snackBarTheme?.elevation ?? 6.0,
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          color: Color(0xFF323232),
          child: Text('My Awesome Snackbar',
              style: TextStyle(color: Colors.white)),
        ),
      ),
    ),
    context: context,
  );
}
