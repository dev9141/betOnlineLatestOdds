import 'package:bet_online_latest_odds/assets/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../../assets/app_colors.dart';

class AlertHelper {
  static void showToast(String msg) {
    // library - fluttertoast 8.2.2
    Fluttertoast.showToast(
        msg: msg,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM);
  }

  static customSnackBar(BuildContext context, String message, bool isError) {
    if (isError) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(message,
            style: AppTheme.normalTextTheme
                .merge(const TextStyle(color: AppColors.textColor))),
        backgroundColor: AppColors.errorColor,
      ));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(message,
            style: AppTheme.normalTextTheme
                .merge(const TextStyle(color: AppColors.textColor))),
        backgroundColor: AppColors.successColor,
      ));
    }
  }

  static showAlertDialog(BuildContext context,
      {String title = "",
      String message = "",
      String positiveAction = "",
      String negativeAction = "",
      String neutralAction = "",
      bool backAction = true,
      VoidCallback? onPositivePressed,
      VoidCallback? onNeutralPressed,
      VoidCallback? onNegativePressed}) {
    return showDialog(
      context: context,
      builder: (context) {
        return WillPopScope(
          onWillPop: () async => backAction,
          child: AlertDialog(
            /* shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(10.0))),*/
            titlePadding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
            actionsOverflowButtonSpacing: -10,
            title: Visibility(
              visible: title.isNotEmpty,
              child: Text(
                title,
                style: AppTheme.normalTextTheme,
              ),
            ),
            contentPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            content: Text(message, style: AppTheme.normalTextTheme),
            actions: <Widget>[
              // usually buttons at the bottom of the dialog
              if (negativeAction.isNotEmpty)
                Container(
                  decoration: const BoxDecoration(
                    color: AppColors.borderTextField,
                    borderRadius: BorderRadius.all(
                      Radius.circular(8),
                    ),
                  ),
                  child: TextButton(
                    onPressed: onNegativePressed,
                    child: Text(negativeAction, style: AppTheme.normalTextTheme),
                  ),
                ),
             if (neutralAction.isNotEmpty)
                Container(
                  decoration: const BoxDecoration(
                    color: AppColors.borderTextField,
                    borderRadius: BorderRadius.all(
                      Radius.circular(8),
                    ),
                  ),
                  child: TextButton(
                    onPressed: onNeutralPressed,
                    child: Text(neutralAction, style: AppTheme.normalTextTheme),
                  ),
                ),
              if (positiveAction.isNotEmpty)
                Container(
                  decoration: const BoxDecoration(
                    color: AppColors.borderTextField,
                    borderRadius: BorderRadius.all(
                      Radius.circular(8),
                    ),
                  ),
                  child: TextButton(
                    onPressed: onPositivePressed,
                    child: Text(
                      positiveAction,
                      style: AppTheme.normalTextTheme,
                    ),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}
