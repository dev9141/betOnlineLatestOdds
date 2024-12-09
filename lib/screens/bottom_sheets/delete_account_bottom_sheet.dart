import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:state_extended/state_extended.dart';

import '../../assets/app_colors.dart';
import '../../controller/UserController.dart';
import '../../data/remote/api_error.dart';
import '../../data/remote/api_response.dart';
import '../../generated/l10n.dart';
import '../../utils/constants/define.dart';
import '../../utils/helper/alert_helper.dart';
import '../../utils/helper/helper.dart';
import '../../views/custom_widgets/common_textfield.dart';
import '../../views/custom_widgets/primary_button.dart';
import '../login_screen.dart';

class DeleteAccountBottomSheet extends StatefulWidget {
  const DeleteAccountBottomSheet({super.key});

  @override
  StateX<DeleteAccountBottomSheet> createState() => _DeleteAccountBottomSheetState();
}

class _DeleteAccountBottomSheetState extends StateX<DeleteAccountBottomSheet> {

  final TextEditingController _passwordController = TextEditingController();
  bool _obscureText = true;
  String? passwordError;
  bool isValidation = false;

  late UserController userController;

  _DeleteAccountBottomSheetState() : super(controller: UserController()) {
    // Acquire a reference to the passed Controller.
    userController = controller as UserController;
  }

  @override
  Widget build(BuildContext context) {
    return Wrap(
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              SizedBox(
                height: 5,
              ),
              Center(
                  child: Icon(
                Icons.logout,
                size: 40.0,
              )),
              SizedBox(
                height: 8,
              ),
              Text(
                "Delete",
                style: TextStyle(
                    fontWeight: FontWeight.w700,
                    color: AppColors.black,
                    fontSize: 20),
              ),
              SizedBox(
                height: 14,
              ),
              Text(
                "Are you sure you want to delete? All your data including email address cannot recover once deleted",
                style: TextStyle(
                    fontWeight: FontWeight.normal,
                    color: AppColors.black,
                    fontSize: 18),
              ),
              SizedBox(
                height: 14,
              ),
              Container(
                child: Text(
                  'Password',
                  textAlign: TextAlign.start,
                  style: TextStyle(
                    color: AppColors.white,
                    fontSize: 16,
                  ),
                ),
                alignment: Alignment.centerLeft,
              ),
              const SizedBox(height: 8),
              CommonTextField(
                commonController: _passwordController,
                textInputType: TextInputType.text,
                hintText: S.of(context).password,
                isShowPassword: _obscureText,
                decoration: InputDecoration(
                  hintText: 'Enter a Password',
                  hintStyle: TextStyle(
                    color: AppColors.hintColor,
                  ),
                  filled: true,
                  fillColor: AppColors.white,
                  contentPadding: EdgeInsets.symmetric(
                    vertical: 16,
                    horizontal: 16,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide.none,
                  ),
                  suffixIcon: GestureDetector(
                    onTap: () {
                      setState(() {
                        _obscureText = !_obscureText;
                      });
                    },
                    child: Icon(
                      _obscureText
                          ? Icons.visibility_rounded
                          : Icons.visibility_off_rounded,
                      color: AppColors.hintColor,
                      size: 24,
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 14,
              ),
              PrimaryButton(
                btnColor: AppColors.red,
                /*btnColor: isEnableBtn
                          ? AppColors.lightBlue
                          : AppColors.grayColor,*/
                Text('Yes, delete',
                    style: TextStyle(fontSize: 20, color: AppColors.white)),
                () {
                  Helper.hideKeyBoard(context);
                  checkValidation();
                  if (isValidation) {
                    setState(() {
                      userController.isApiCall = true;
                    });
                    Helper.isInternetConnectionAvailable()
                        .then((internet) async {
                      if (internet) {
                        await userController
                            .deleteAccount(_passwordController.text)
                            .then((value) async {
                          if (value is APIResponse) {
                            setState(() {
                              userController.isApiCall = false;
                            });
                            AlertHelper.customSnackBar(
                                context, value.message, false);
                            Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => LoginScreen(),
                                ));
                          } else {
                            if (value is APIError) {
                              setState(() {
                                userController.isApiCall = false;
                              });
                              AlertHelper.customSnackBar(
                                  context, value.message, true);
                            }
                          }
                        });
                      } else {
                        setState(() {
                          userController.isApiCall = false;
                        });
                        AlertHelper.customSnackBar(context,
                            S.of(context).err_internet, true);
                      }
                    });
                  }
                },
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(50),
                ),
                backgroundColor: AppColors.red,
              ),
              SizedBox(
                height: 6,
              ),
              OutlinedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: AppColors.black, width: 2),
                  minimumSize: Size(double.infinity, double.minPositive),
                  // Border color and width
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30), // Rounded border
                  ),
                  padding: const EdgeInsets.symmetric(
                      horizontal: 24, vertical: 12), // Padding inside the button
                ),
                child: const Text(
                  'Cancel',
                  style: TextStyle(
                    color: AppColors.black, // Text color
                    fontSize: 20, // Text size
                    fontWeight: FontWeight.bold, // Font weight
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
  checkValidation() {
    setState(() {
      passwordError = null;
      isValidation = false;
    });


    if (_passwordController.text.trim().isEmpty) {
      setState(() {
        passwordError = S.of(context).err_password;
        isValidation = false;
      });
    } else if (_passwordController.text.trim().length < PASSWORD_LENGTH_MIN) {
      setState(() {
        passwordError =
            S.of(context).err_password_min_length(PASSWORD_LENGTH_MIN);
        isValidation = false;
      });
    }
    /*else if (_passwordController.text.trim().length > PASSWORD_LENGTH_MAX) {
      setState(() {
        passwordError = S.of(context).err_password_max_length(PASSWORD_LENGTH_MAX);
        isValidation = false;
      });
    } else if (!Helper.isValidPassword(_passwordController.text.trim())) {
      setState(() {
        passwordError = S
            .of(context)
            .err_valid_password(PASSWORD_LENGTH_MIN, PASSWORD_LENGTH_MAX);
        isValidation = false;
      });
    }*/

    if (passwordError == null) {
      setState(() {
        isValidation = true;
      });
    }
  }

}
