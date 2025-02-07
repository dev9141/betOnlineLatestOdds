import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../assets/app_colors.dart';
import '../../assets/app_theme.dart';

class CommonTextField extends StatelessWidget {
  const CommonTextField({Key? key,
    required TextEditingController commonController,
    required TextInputType textInputType,
    TextCapitalization textCapitalization = TextCapitalization.none,
    List<TextInputFormatter>? inputFormatters,
    String title = "",
    bool enable = true,
    bool isShowPassword = false,
    bool readOnly = false,
    Widget? suffixIcon,
    TextStyle? style,
    FocusNode? focusNode,
    VoidCallback? onTap, this.decoration, this.hintText})
      : _commonController = commonController,
        _textInputType = textInputType,
        _textCapitalization = textCapitalization,
        _inputFormatters = inputFormatters,
        _enable = enable,
        _isShowPassword = isShowPassword,
        _suffixIcon = suffixIcon,
        _style = style,
        _focusNode = focusNode,
        _onTap = onTap,
        _readOnly = readOnly,
        super(key: key);

  final TextEditingController _commonController;
  final TextInputType _textInputType;
  final TextCapitalization _textCapitalization;
  final List<TextInputFormatter>? _inputFormatters;
  final String? hintText;
  final bool _enable;
  final FocusNode? _focusNode;
  final bool _isShowPassword;
  final bool _readOnly;
  final VoidCallback? _onTap;
  final Widget? _suffixIcon;
  final TextStyle? _style;
  final InputDecoration? decoration;

  @override
  Widget build(BuildContext context) {
    return TextField(
        controller: _commonController,
        keyboardType: _textInputType,
        cursorColor: AppColors.black,
        enabled: _enable,
        focusNode: _focusNode,
        textCapitalization: _textCapitalization,
        textAlignVertical: TextAlignVertical.center,
        style: _style ?? AppTheme.textFieldTheme,
        maxLines: 1,
        minLines: 1,
        inputFormatters: _inputFormatters,
        decoration: decoration == null
            ? InputDecoration(
            filled: true,
            fillColor: AppColors.primary,
            contentPadding: const EdgeInsets.symmetric(horizontal: 16),
            hintText: hintText == null ? "" : hintText,
            enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(4),
                borderSide:
                const BorderSide(color: AppColors.borderTextField, width: 1)),
            focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(4),
                borderSide:
                const BorderSide(color: AppColors.borderTextField, width: 1)),
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(4),
                borderSide:
                const BorderSide(color: AppColors.borderTextField, width: 1)),
            suffixIcon: _suffixIcon,
            hintStyle: AppTheme.textFieldTheme
                .merge(const TextStyle(color: AppColors.hintColor)))
            : decoration,
        onTap: _onTap,
        obscureText: _isShowPassword,
        readOnly: _readOnly,
    );
  }
}
