import 'package:flutter/material.dart';
import '../constants/add_color.dart';


class AppBarWidget extends StatelessWidget
    implements PreferredSizeWidget {

  final String title;
  final List<Widget>? actions;

  const AppBarWidget({
    super.key,
    required this.title,
    this.actions,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(
        title,
        style: const TextStyle(
          fontSize: 20,
          color: Colors.white,
        ),
      ),

      backgroundColor: AppColors.primary,

      foregroundColor: Colors.white,

      elevation: 0,

      centerTitle: false,

      actions: actions,
    );
  }

  @override
  Size get preferredSize =>
      const Size.fromHeight(kToolbarHeight);
}