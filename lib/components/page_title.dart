import 'package:flutter/material.dart';

class PageTitle extends StatelessWidget {
  const PageTitle({
    super.key,
    required this.title,
    this.customColor,
    this.leftZone,
    this.rightZone,
    this.subZone
  });

  final String title;
  final Color? customColor;
  final Widget? leftZone;
  final Widget? rightZone;
  final Widget? subZone;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Stack(
          children: [
            if (leftZone != null)
              Positioned(
                left: 0, top: 0, bottom: 0,
                child: Center(child: leftZone!),
              ),
            Center(
              child: Text(
                title,
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: customColor ?? Theme.of(context).primaryColor,
                ),
              ),
            ),
            if (rightZone != null)
              Positioned(
                right: 0, top: 0, bottom: 0,
                child: Center(child: rightZone!),
              ),
          ],
        ),

        (subZone != null)
        ? Column(
          children: [
            SizedBox(height: 4),
            subZone!
          ],
        )
        : SizedBox.shrink(),

        const SizedBox(height: 12),
        Divider(
          thickness: 2.3,
          color: Theme.of(context).colorScheme.secondary,
          height: 0
        ),
      ],
    );
  }
}
