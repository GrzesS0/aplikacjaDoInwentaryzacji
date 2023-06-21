import 'package:flutter/material.dart';

class CustomFloatingActionButton
    extends StatelessWidget
{
  const CustomFloatingActionButton(
      {super.key,
        required this.iconData,
        required this.function,
        this.onDoubleTap});

  final void Function()? onDoubleTap;
  final Function() function;
  final IconData iconData;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60,
      width: 60,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.white10),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.lightGreen.shade500,
            Colors.lightGreen.shade600,
            Colors.lightGreen.shade700,
            Colors.lightGreen.shade800,
          ],
          stops: const [0.1, 0.3, 0.6, 0.8],
        ),
        shape: BoxShape.circle,
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            offset: Offset(1, 1),
            blurRadius: 0.2,
            spreadRadius: 1,
          )
        ],
      ),
      child: GestureDetector(
        onTap: function,
        onDoubleTap: onDoubleTap,
        child: Icon(
          iconData,
          color: Colors.white,
          shadows: const [
            Shadow(
              color: Colors.grey,
              blurRadius: 2,
              offset: Offset(-0.5, -0.5),
            ),
            Shadow(
              color: Colors.black,
              blurRadius: 2,
              offset: Offset(1, 1),
            ),
          ],
        ),
      ),
    );
  }
}
