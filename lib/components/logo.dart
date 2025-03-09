import 'package:flutter/material.dart';



class SchoolLogo extends StatelessWidget implements PreferredSizeWidget {
  const SchoolLogo({super.key,
    this.isNotDisplaySchoolName = false
  });

  final bool isNotDisplaySchoolName;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: (isNotDisplaySchoolName)
          ? Container(
            width: 155,
            height: 155,
            decoration: BoxDecoration(
              color: Color(0xffe5e5e5),
              borderRadius: BorderRadius.circular(5)
            ),
            child: Text(''),
          )
          : Image.asset('images/tmcit_logo.png', width: 155)
      ));
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
