// GENERATED CODE - DO NOT MODIFY BY HAND
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'intl/messages_all.dart';

// **************************************************************************
// Generator: Flutter Intl IDE plugin
// Made by Localizely
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, lines_longer_than_80_chars
// ignore_for_file: join_return_with_assignment, prefer_final_in_for_each
// ignore_for_file: avoid_redundant_argument_values, avoid_escaping_inner_quotes

class S {
  S();

  static S? _current;

  static S get current {
    assert(_current != null,
        'No instance of S was loaded. Try to initialize the S delegate before accessing S.current.');
    return _current!;
  }

  static const AppLocalizationDelegate delegate = AppLocalizationDelegate();

  static Future<S> load(Locale locale) {
    final name = (locale.countryCode?.isEmpty ?? false)
        ? locale.languageCode
        : locale.toString();
    final localeName = Intl.canonicalizedLocale(name);
    return initializeMessages(localeName).then((_) {
      Intl.defaultLocale = localeName;
      final instance = S();
      S._current = instance;

      return instance;
    });
  }

  static S of(BuildContext context) {
    final instance = S.maybeOf(context);
    assert(instance != null,
        'No instance of S present in the widget tree. Did you add S.delegate in localizationsDelegates?');
    return instance!;
  }

  static S? maybeOf(BuildContext context) {
    return Localizations.of<S>(context, S);
  }

  /// `Login`
  String get login {
    return Intl.message(
      'Login',
      name: 'login',
      desc: '',
      args: [],
    );
  }

  /// `Email Id`
  String get email_id {
    return Intl.message(
      'Email Id',
      name: 'email_id',
      desc: '',
      args: [],
    );
  }

  /// `Password`
  String get password {
    return Intl.message(
      'Password',
      name: 'password',
      desc: '',
      args: [],
    );
  }

  /// `Ok`
  String get ok {
    return Intl.message(
      'Ok',
      name: 'ok',
      desc: '',
      args: [],
    );
  }

  /// `Version-{version}({buildNumber})`
  String app_version(Object version, Object buildNumber) {
    return Intl.message(
      'Version-$version($buildNumber)',
      name: 'app_version',
      desc: '',
      args: [version, buildNumber],
    );
  }

  /// `terms and conditions`
  String get terms_conditions {
    return Intl.message(
      'terms and conditions',
      name: 'terms_conditions',
      desc: '',
      args: [],
    );
  }

  /// `Could not connect to the internet.`
  String get internet_msg {
    return Intl.message(
      'Could not connect to the internet.',
      name: 'internet_msg',
      desc: '',
      args: [],
    );
  }

  /// `Try Again`
  String get try_again {
    return Intl.message(
      'Try Again',
      name: 'try_again',
      desc: '',
      args: [],
    );
  }

  /// `something went wrong.`
  String get err_msg {
    return Intl.message(
      'something went wrong.',
      name: 'err_msg',
      desc: '',
      args: [],
    );
  }

  /// `No internet connection.`
  String get err_internet {
    return Intl.message(
      'No internet connection.',
      name: 'err_internet',
      desc: '',
      args: [],
    );
  }

  /// `Email id is required.`
  String get err_email_id {
    return Intl.message(
      'Email id is required.',
      name: 'err_email_id',
      desc: '',
      args: [],
    );
  }

  /// `Invalid email id.`
  String get invalid_email_id {
    return Intl.message(
      'Invalid email id.',
      name: 'invalid_email_id',
      desc: '',
      args: [],
    );
  }

  /// `Password is required.`
  String get err_password {
    return Intl.message(
      'Password is required.',
      name: 'err_password',
      desc: '',
      args: [],
    );
  }
/*
  String get err_user_name {
    return Intl.message(
      'User name is required.',
      name: 'err_user_name',
      desc: '',
      args: [],
    );
  }
*/
  /// `Gallery`
  String get gallery {
    return Intl.message(
      'Gallery',
      name: 'gallery',
      desc: '',
      args: [],
    );
  }

  /// `Camera`
  String get camera {
    return Intl.message(
      'Camera',
      name: 'camera',
      desc: '',
      args: [],
    );
  }

  /// `Camera Permission`
  String get camera_permission {
    return Intl.message(
      'Camera Permission',
      name: 'camera_permission',
      desc: '',
      args: [],
    );
  }

  /// `Camera permission is required to capture photo. Please enable Camera permission from Settings.`
  String get enable_camera_permission_msg {
    return Intl.message(
      'Camera permission is required to capture photo. Please enable Camera permission from Settings.',
      name: 'enable_camera_permission_msg',
      desc: '',
      args: [],
    );
  }

  /// `Open Settings`
  String get open_settings {
    return Intl.message(
      'Open Settings',
      name: 'open_settings',
      desc: '',
      args: [],
    );
  }

  /// `Image size should be less than 15Mb.`
  String get error_image_size {
    return Intl.message(
      'Image size should be less than 15Mb.',
      name: 'error_image_size',
      desc: '',
      args: [],
    );
  }

  /// `Cancel`
  String get cancel {
    return Intl.message(
      'Cancel',
      name: 'cancel',
      desc: '',
      args: [],
    );
  }

  /// `First Name`
  String get first_name {
    return Intl.message(
      'First Name',
      name: 'first_name',
      desc: '',
      args: [],
    );
  }

  /// `Last Name`
  String get last_name {
    return Intl.message(
      'Last Name',
      name: 'last_name',
      desc: '',
      args: [],
    );
  }

  /// `Date of Birth`
  String get date_birth {
    return Intl.message(
      'Date of Birth',
      name: 'date_birth',
      desc: '',
      args: [],
    );
  }

  /// `Gender`
  String get gender {
    return Intl.message(
      'Gender',
      name: 'gender',
      desc: '',
      args: [],
    );
  }

  /// `Sign Up`
  String get sign_up {
    return Intl.message(
      'Sign Up',
      name: 'sign_up',
      desc: '',
      args: [],
    );
  }

  /// `First name is required.`
  String get err_first_name {
    return Intl.message(
      'First name is required.',
      name: 'err_first_name',
      desc: '',
      args: [],
    );
  }

  /// `Last name is required.`
  String get err_last_name {
    return Intl.message(
      'Last name is required.',
      name: 'err_last_name',
      desc: '',
      args: [],
    );
  }

  /// `You have logged in successfully`
  String get success_login {
    return Intl.message(
      'You have logged in successfully',
      name: 'success_login',
      desc: '',
      args: [],
    );
  }

  /// `something went wrong please try again after some time.`
  String get error_verify_otp {
    return Intl.message(
      'something went wrong please try again after some time.',
      name: 'error_verify_otp',
      desc: '',
      args: [],
    );
  }

  /// `Birth date is required.`
  String get err_birth_date {
    return Intl.message(
      'Birth date is required.',
      name: 'err_birth_date',
      desc: '',
      args: [],
    );
  }

  /// `Address is required.`
  String get err_address {
    return Intl.message(
      'Address is required.',
      name: 'err_address',
      desc: '',
      args: [],
    );
  }

  /// `Subject is required.`
  String get err_subject {
    return Intl.message(
      'Subject is required.',
      name: 'err_subject',
      desc: '',
      args: [],
    );
  }

  /// `Gender is required.`
  String get err_gender {
    return Intl.message(
      'Gender is required.',
      name: 'err_gender',
      desc: '',
      args: [],
    );
  }

  /// `Mobile number is required.`
  String get err_number {
    return Intl.message(
      'Mobile number is required.',
      name: 'err_number',
      desc: '',
      args: [],
    );
  }

  /// `Mobile number must have at least 10 characters.`
  String get err_length_mobile_number {
    return Intl.message(
      'Mobile number must have at least 10 characters.',
      name: 'err_length_mobile_number',
      desc: '',
      args: [],
    );
  }

  /// `Password must contain uppercase, lowercase, special characters, number and should be {minLength} to {maxLength} characters long.`
  String err_valid_password(Object minLength, Object maxLength) {
    return Intl.message(
      'Password must contain uppercase, lowercase, special characters, number and should be $minLength to $maxLength characters long.',
      name: 'err_valid_password',
      desc: '',
      args: [minLength, maxLength],
    );
  }

  /// `Password and Confirm password doesn’t match.`
  String get err_valid_reenter_password {
    return Intl.message(
      'Password and Confirm password doesn’t match.',
      name: 'err_valid_reenter_password',
      desc: '',
      args: [],
    );
  }

  /// `Confirm password is required.`
  String get err_msg_confirm_password {
    return Intl.message(
      'Confirm password is required.',
      name: 'err_msg_confirm_password',
      desc: '',
      args: [],
    );
  }

  /// `New password and Confirm password doesn’t match.`
  String get err_valid_confirm_password {
    return Intl.message(
      'New password and Confirm password doesn’t match.',
      name: 'err_valid_confirm_password',
      desc: '',
      args: [],
    );
  }

  /// `Verify your email id!`
  String get verify_your_email_msg {
    return Intl.message(
      'Verify your email id!',
      name: 'verify_your_email_msg',
      desc: '',
      args: [],
    );
  }

  /// `Reset Password`
  String get reset_password {
    return Intl.message(
      'Reset Password',
      name: 'reset_password',
      desc: '',
      args: [],
    );
  }

  /// `OTP is required.`
  String get err_msg_otp {
    return Intl.message(
      'OTP is required.',
      name: 'err_msg_otp',
      desc: '',
      args: [],
    );
  }

  /// `OTP must have at least 6 characters.`
  String get err_msg_otp_length {
    return Intl.message(
      'OTP must have at least 6 characters.',
      name: 'err_msg_otp_length',
      desc: '',
      args: [],
    );
  }

  /// `New password must contain uppercase, lowercase, special characters, number and should be {minLength} to {maxLength} characters long.`
  String err_msg_new_password_format(Object minLength, Object maxLength) {
    return Intl.message(
      'New password must contain uppercase, lowercase, special characters, number and should be $minLength to $maxLength characters long.',
      name: 'err_msg_new_password_format',
      desc: '',
      args: [minLength, maxLength],
    );
  }

  /// `New password is required.`
  String get err_msg_new_password {
    return Intl.message(
      'New password is required.',
      name: 'err_msg_new_password',
      desc: '',
      args: [],
    );
  }

  /// `New password must be more than {length} characters.`
  String err_new_password_min_length(Object length) {
    return Intl.message(
      'New password must be more than $length characters.',
      name: 'err_new_password_min_length',
      desc: '',
      args: [length],
    );
  }

  /// `New password must not be greater than {length} characters.`
  String err_new_password_max_length(Object length) {
    return Intl.message(
      'New password must not be greater than $length characters.',
      name: 'err_new_password_max_length',
      desc: '',
      args: [length],
    );
  }

  /// `OTP`
  String get otp {
    return Intl.message(
      'OTP',
      name: 'otp',
      desc: '',
      args: [],
    );
  }

  /// `Forgot Password`
  String get forgot_Password {
    return Intl.message(
      'Forgot Password',
      name: 'forgot_Password',
      desc: '',
      args: [],
    );
  }

  /// `Forgot Password?`
  String get forgot_Password_ {
    return Intl.message(
      'Forgot Password?',
      name: 'forgot_Password_',
      desc: '',
      args: [],
    );
  }

  /// `Don’t worry! It happens , Please enter the email id associated with your account.`
  String get forgot_password_msg {
    return Intl.message(
      'Don’t worry! It happens , Please enter the email id associated with your account.',
      name: 'forgot_password_msg',
      desc: '',
      args: [],
    );
  }

  /// `Send OTP`
  String get sendOtp {
    return Intl.message(
      'Send OTP',
      name: 'sendOtp',
      desc: '',
      args: [],
    );
  }

  /// `Change Password`
  String get change_password {
    return Intl.message(
      'Change Password',
      name: 'change_password',
      desc: '',
      args: [],
    );
  }

  /// `Current password is required.`
  String get err_msg_current_password {
    return Intl.message(
      'Current password is required.',
      name: 'err_msg_current_password',
      desc: '',
      args: [],
    );
  }

  /// `Confirm Password`
  String get confirm_password {
    return Intl.message(
      'Confirm Password',
      name: 'confirm_password',
      desc: '',
      args: [],
    );
  }

  /// `We have sent a verification mail on {email}. Once you verify your account, please click on 'Verified' button below.`
  String verification_mail_sent_msg(Object email) {
    return Intl.message(
      'We have sent a verification mail on $email. Once you verify your account, please click on \'Verified\' button below.',
      name: 'verification_mail_sent_msg',
      desc: '',
      args: [email],
    );
  }

  /// `Didn't get? `
  String get didnt_get_token {
    return Intl.message(
      'Didn\'t get? ',
      name: 'didnt_get_token',
      desc: '',
      args: [],
    );
  }

  /// `Resend OTP`
  String get resend_otp {
    return Intl.message(
      'Resend OTP',
      name: 'resend_otp',
      desc: '',
      args: [],
    );
  }

  /// `Profile image is required.`
  String get err_msg_profile {
    return Intl.message(
      'Profile image is required.',
      name: 'err_msg_profile',
      desc: '',
      args: [],
    );
  }

  /// `Are you sure you want to logout?`
  String get msg_logout {
    return Intl.message(
      'Are you sure you want to logout?',
      name: 'msg_logout',
      desc: '',
      args: [],
    );
  }

  /// `Logout`
  String get logout {
    return Intl.message(
      'Logout',
      name: 'logout',
      desc: '',
      args: [],
    );
  }

  /// `Delete Account`
  String get delete_account {
    return Intl.message(
      'Delete Account',
      name: 'delete_account',
      desc: '',
      args: [],
    );
  }

  /// `Are you sure you want to delete account?`
  String get msg_delete_account {
    return Intl.message(
      'Are you sure you want to delete account?',
      name: 'msg_delete_account',
      desc: '',
      args: [],
    );
  }

  /// `Yes`
  String get yes {
    return Intl.message(
      'Yes',
      name: 'yes',
      desc: '',
      args: [],
    );
  }

  /// `Profile`
  String get profile {
    return Intl.message(
      'Profile',
      name: 'profile',
      desc: '',
      args: [],
    );
  }

  /// `Contact Us`
  String get contact_us {
    return Intl.message(
      'Contact Us',
      name: 'contact_us',
      desc: '',
      args: [],
    );
  }

  /// `Edit Profile`
  String get edit_profile {
    return Intl.message(
      'Edit Profile',
      name: 'edit_profile',
      desc: '',
      args: [],
    );
  }

  /// `Message is required.`
  String get err_message {
    return Intl.message(
      'Message is required.',
      name: 'err_message',
      desc: '',
      args: [],
    );
  }

  /// `A new version of app is now available.`
  String get update_app_head_title {
    return Intl.message(
      'A new version of app is now available.',
      name: 'update_app_head_title',
      desc: '',
      args: [],
    );
  }

  /// `Later`
  String get later {
    return Intl.message(
      'Later',
      name: 'later',
      desc: '',
      args: [],
    );
  }

  /// `Update Now`
  String get update_now {
    return Intl.message(
      'Update Now',
      name: 'update_now',
      desc: '',
      args: [],
    );
  }

  /// `We’ve made some changes to make your experience as great as possible!\n\nWould you like to update it now?`
  String get update_app_note {
    return Intl.message(
      'We’ve made some changes to make your experience as great as possible!\n\nWould you like to update it now?',
      name: 'update_app_note',
      desc: '',
      args: [],
    );
  }

  /// `Update App`
  String get update_app {
    return Intl.message(
      'Update App',
      name: 'update_app',
      desc: '',
      args: [],
    );
  }

  /// `You are using old version of the app. Kindly update to latest version to take advantages of latest features.`
  String get upgrade_description {
    return Intl.message(
      'You are using old version of the app. Kindly update to latest version to take advantages of latest features.',
      name: 'upgrade_description',
      desc: '',
      args: [],
    );
  }

  /// `Name`
  String get name {
    return Intl.message(
      'Name',
      name: 'name',
      desc: '',
      args: [],
    );
  }

  /// `Mobile Number`
  String get mobile_number {
    return Intl.message(
      'Mobile Number',
      name: 'mobile_number',
      desc: '',
      args: [],
    );
  }

  /// `Address`
  String get address {
    return Intl.message(
      'Address',
      name: 'address',
      desc: '',
      args: [],
    );
  }

  /// `Save`
  String get save {
    return Intl.message(
      'Save',
      name: 'save',
      desc: '',
      args: [],
    );
  }

  /// `Message`
  String get message {
    return Intl.message(
      'Message',
      name: 'message',
      desc: '',
      args: [],
    );
  }

  /// `Current password must be more than {length} characters.`
  String err_current_password_min_length(Object length) {
    return Intl.message(
      'Current password must be more than $length characters.',
      name: 'err_current_password_min_length',
      desc: '',
      args: [length],
    );
  }

  /// `Current password must not be greater than {length} characters.`
  String err_current_password_max_length(Object length) {
    return Intl.message(
      'Current password must not be greater than $length characters.',
      name: 'err_current_password_max_length',
      desc: '',
      args: [length],
    );
  }

  /// `Invalid mobile number.`
  String get invalid_mobile_number {
    return Intl.message(
      'Invalid mobile number.',
      name: 'invalid_mobile_number',
      desc: '',
      args: [],
    );
  }

  /// `New Password`
  String get new_password {
    return Intl.message(
      'New Password',
      name: 'new_password',
      desc: '',
      args: [],
    );
  }

  /// `Skip`
  String get skip {
    return Intl.message(
      'Skip',
      name: 'skip',
      desc: '',
      args: [],
    );
  }

  /// `Last name must have at least {length} characters.`
  String err_last_name_min_length(Object length) {
    return Intl.message(
      'Last name must have at least $length characters.',
      name: 'err_last_name_min_length',
      desc: '',
      args: [length],
    );
  }

  /// `First name must have at least {length} characters.`
  String err_first_name_min_length(Object length) {
    return Intl.message(
      'First name must have at least $length characters.',
      name: 'err_first_name_min_length',
      desc: '',
      args: [length],
    );
  }

  /// `First name must not be greater than {length} characters.`
  String err_first_name_max_length(Object length) {
    return Intl.message(
      'First name must not be greater than $length characters.',
      name: 'err_first_name_max_length',
      desc: '',
      args: [length],
    );
  }

  /// `Last name must not be greater than {length} characters.`
  String err_last_name_max_length(Object length) {
    return Intl.message(
      'Last name must not be greater than $length characters.',
      name: 'err_last_name_max_length',
      desc: '',
      args: [length],
    );
  }

  /// `Address must have at least {length} characters.`
  String err_address_min_length(Object length) {
    return Intl.message(
      'Address must have at least $length characters.',
      name: 'err_address_min_length',
      desc: '',
      args: [length],
    );
  }

  /// `Address must not be greater than {length} characters.`
  String err_address_max_length(Object length) {
    return Intl.message(
      'Address must not be greater than $length characters.',
      name: 'err_address_max_length',
      desc: '',
      args: [length],
    );
  }

  /// `Name must have at least {length} characters.`
  String err_name_min_length(Object length) {
    return Intl.message(
      'Name must have at least $length characters.',
      name: 'err_name_min_length',
      desc: '',
      args: [length],
    );
  }

  /// `Name must not be greater than {length} characters.`
  String err_name_max_length(Object length) {
    return Intl.message(
      'Name must not be greater than $length characters.',
      name: 'err_name_max_length',
      desc: '',
      args: [length],
    );
  }

  /// `Password must be more than {length} characters.`
  String err_password_min_length(Object length) {
    return Intl.message(
      'Password must be more than $length characters.',
      name: 'err_password_min_length',
      desc: '',
      args: [length],
    );
  }

  String err_password_uppercase() {
    return Intl.message(
      'Password must have at least 1 uppercase letter (A-Z)',
      name: 'err_password_uppercase',
      desc: '',
    );
  }

  String err_password_lowercase() {
    return Intl.message(
      'Password must have at least 1 lowercase letter (a-z))',
      name: 'err_password_lowercase',
      desc: '',
    );
  }

  String err_password_number() {
    return Intl.message(
      'Password must have At least 1 number (0-9)',
      name: 'err_password_number',
      desc: '',
    );
  }

  String err_user_name_min_length(Object length) {
    return Intl.message(
      'First name must be more than $length characters.',
      name: 'err_user_name_min_length',
      desc: '',
      args: [length],
    );
  }

  /// `Password must not be greater than {length} characters.`
  String err_password_max_length(Object length) {
    return Intl.message(
      'Password must not be greater than $length characters.',
      name: 'err_password_max_length',
      desc: '',
      args: [length],
    );
  }

  String err_phone_length(Object length) {
    return Intl.message(
      'Phone number must be of $length numbers.',
      name: 'err_phone_length',
      desc: '',
      args: [length],
    );
  }
  /// `Submit`
  String get submit {
    return Intl.message(
      'Submit',
      name: 'submit',
      desc: '',
      args: [],
    );
  }

  /// `Verify`
  String get verify {
    return Intl.message(
      'Verify',
      name: 'verify',
      desc: '',
      args: [],
    );
  }

  /// `Sign In`
  String get sign_in {
    return Intl.message(
      'Sign In',
      name: 'sign_in',
      desc: '',
      args: [],
    );
  }

  /// `Terms of Service`
  String get terms_service {
    return Intl.message(
      'Terms of Service',
      name: 'terms_service',
      desc: '',
      args: [],
    );
  }

  /// ` and `
  String get and {
    return Intl.message(
      ' and ',
      name: 'and',
      desc: '',
      args: [],
    );
  }

  /// `Privacy Policy`
  String get privacy_policy {
    return Intl.message(
      'Privacy Policy',
      name: 'privacy_policy',
      desc: '',
      args: [],
    );
  }

  /// `Already have an account? `
  String get already_have_account {
    return Intl.message(
      'Already have an account? ',
      name: 'already_have_account',
      desc: '',
      args: [],
    );
  }

  /// `Verification`
  String get verification {
    return Intl.message(
      'Verification',
      name: 'verification',
      desc: '',
      args: [],
    );
  }

  /// `Already have OTP ?`
  String get already_have_otp {
    return Intl.message(
      'Already have OTP ?',
      name: 'already_have_otp',
      desc: '',
      args: [],
    );
  }

  /// `Don't have an account?`
  String get dont_have_an_account {
    return Intl.message(
      'Don\'t have an account?',
      name: 'dont_have_an_account',
      desc: '',
      args: [],
    );
  }

  /// `Home`
  String get home {
    return Intl.message(
      'Home',
      name: 'home',
      desc: '',
      args: [],
    );
  }

  /// `Pavans Group`
  String get pavans_group {
    return Intl.message(
      'Pavans Group',
      name: 'pavans_group',
      desc: '',
      args: [],
    );
  }

  /// `Current Password`
  String get current_password {
    return Intl.message(
      'Current Password',
      name: 'current_password',
      desc: '',
      args: [],
    );
  }

  /// `Date of birth`
  String get date_Of_birth {
    return Intl.message(
      'Date of birth',
      name: 'date_Of_birth',
      desc: '',
      args: [],
    );
  }
}

class AppLocalizationDelegate extends LocalizationsDelegate<S> {
  const AppLocalizationDelegate();

  List<Locale> get supportedLocales {
    return const <Locale>[
      Locale.fromSubtags(languageCode: 'en'),
    ];
  }

  @override
  bool isSupported(Locale locale) => _isSupported(locale);
  @override
  Future<S> load(Locale locale) => S.load(locale);
  @override
  bool shouldReload(AppLocalizationDelegate old) => false;

  bool _isSupported(Locale locale) {
    for (var supportedLocale in supportedLocales) {
      if (supportedLocale.languageCode == locale.languageCode) {
        return true;
      }
    }
    return false;
  }
}
