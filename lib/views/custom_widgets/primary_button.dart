import 'package:flutter/material.dart';

import '../../assets/app_colors.dart';

class PrimaryButton extends StatelessWidget {
  final Text title;
  final String icon;
  final Alignment alignment;
  final VoidCallback callback;
  final Color btnColor;
  final bool isEnable;
  final Color? backgroundColor;
  final OutlinedBorder? shape;
  const PrimaryButton(
      this.title, this.callback,
      {
        this.isEnable=true,
        this.icon = '',
        this.alignment = Alignment.centerLeft,
        this.btnColor = AppColors.theme_carrot,
        this.backgroundColor = AppColors.white,
        super.key,
        this.shape
      }
      );

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: isEnable ? callback : null,
      style: ElevatedButton.styleFrom(
        backgroundColor: backgroundColor,
        shape: shape ?? RoundedRectangleBorder(borderRadius: BorderRadius.circular(99.0)),
      ),
      child: Container(
        height: 50,
        decoration: BoxDecoration(
            color: isEnable ? btnColor : AppColors.grayColor, //For Normal Background,
            // For gradient background
          /*  gradient:
                LinearGradient(colors: [Color(0xff9DCEFF), Color(0xff82CCB0)]),
            borderRadius: BorderRadius.all(Radius.circular(99.0)),
            // For shadow
            boxShadow: [
              BoxShadow(
                  color: Color(0x4d95adfe),
                  offset: Offset(0, 10),
                  blurRadius: 10)
            ]*/),
        alignment: Alignment.center,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            if (alignment == Alignment.centerLeft && icon.isNotEmpty)
              /*(icon.contains('.svg')) ? SvgPicture.asset(icon, fit: BoxFit.fill):Image.asset(icon, height: 20, width: 20, fit: BoxFit.fill),*/
            if (alignment == Alignment.centerLeft && icon.isNotEmpty)
              const SizedBox(
                width: 10,
              ),
            title,
            if (alignment == Alignment.centerRight && icon.isNotEmpty)
              const SizedBox(
                width: 10,
              ),
            /*if (alignment == Alignment.centerRight && icon.isNotEmpty)
              (icon.contains('.svg')) ? SvgPicture.asset(icon, fit: BoxFit.fill):Image.asset(icon, height: 20, width: 20, fit: BoxFit.fill),*/
          ],
        ),
      ),
    );
  }
}
