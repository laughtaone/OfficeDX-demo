import 'package:flutter/material.dart';


class CommonAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CommonAppBar({super.key,
    this.isNotDisplaySchoolName = false
  });

  final bool isNotDisplaySchoolName;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(
        (isNotDisplaySchoolName) ? '******電子窓口' : '産業技術高専電子窓口',
        style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
      centerTitle: false,
      backgroundColor: Theme.of(context).primaryColor,
      iconTheme: const IconThemeData(color: Colors.white),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
