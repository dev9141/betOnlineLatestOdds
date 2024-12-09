// DO NOT EDIT. This is code generated via package:intl/generate_localized.dart
// This is a library that provides messages for a en locale. All the
// messages from the main program should be duplicated here with the same
// function name.

// Ignore issues from commonly used lints in this file.
// ignore_for_file:unnecessary_brace_in_string_interps, unnecessary_new
// ignore_for_file:prefer_single_quotes,comment_references, directives_ordering
// ignore_for_file:annotate_overrides,prefer_generic_function_type_aliases
// ignore_for_file:unused_import, file_names, avoid_escaping_inner_quotes
// ignore_for_file:unnecessary_string_interpolations, unnecessary_string_escapes

import 'package:intl/intl.dart';
import 'package:intl/message_lookup_by_library.dart';

final messages = new MessageLookup();

typedef String MessageIfAbsent(String messageStr, List<dynamic> args);

class MessageLookup extends MessageLookupByLibrary {
  String get localeName => 'en';

  static String m0(version, buildNumber) =>
      "Version-${version}(${buildNumber})";

  static String m1(length) =>
      "Address must not be greater than ${length} characters.";

  static String m2(length) =>
      "Address must have at least ${length} characters.";

  static String m3(length) =>
      "Current password must not be greater than ${length} characters.";

  static String m4(length) =>
      "Current password must be more than ${length} characters.";

  static String m5(length) =>
      "First name must not be greater than ${length} characters.";

  static String m6(length) =>
      "First name must have at least ${length} characters.";

  static String m7(length) =>
      "Last name must not be greater than ${length} characters.";

  static String m8(length) =>
      "Last name must have at least ${length} characters.";

  static String m9(minLength, maxLength) =>
      "New password must contain uppercase, lowercase, special characters, number and should be ${minLength} to ${maxLength} characters long.";

  static String m10(length) =>
      "Name must not be greater than ${length} characters.";

  static String m11(length) => "Name must have at least ${length} characters.";

  static String m12(length) =>
      "New password must not be greater than ${length} characters.";

  static String m13(length) =>
      "New password must be more than ${length} characters.";

  static String m14(length) =>
      "Password must not be greater than ${length} characters.";

  static String m15(length) =>
      "Password must be more than ${length} characters.";

  static String m16(minLength, maxLength) =>
      "Password must contain uppercase, lowercase, special characters, number and should be ${minLength} to ${maxLength} characters long.";

  static String m17(email) =>
      "We have sent a verification mail on ${email}. Once you verify your account, please click on \'Verified\' button below.";

  final messages = _notInlinedMessages(_notInlinedMessages);
  static Map<String, Function> _notInlinedMessages(_) => <String, Function>{
        "address": MessageLookupByLibrary.simpleMessage("Address"),
        "already_have_account":
            MessageLookupByLibrary.simpleMessage("Already have an account? "),
        "already_have_otp":
            MessageLookupByLibrary.simpleMessage("Already have OTP ?"),
        "and": MessageLookupByLibrary.simpleMessage(" and "),
        "app_version": m0,
        "camera": MessageLookupByLibrary.simpleMessage("Camera"),
        "camera_permission":
            MessageLookupByLibrary.simpleMessage("Camera Permission"),
        "cancel": MessageLookupByLibrary.simpleMessage("Cancel"),
        "change_password":
            MessageLookupByLibrary.simpleMessage("Change Password"),
        "confirm_password":
            MessageLookupByLibrary.simpleMessage("Confirm Password"),
        "contact_us": MessageLookupByLibrary.simpleMessage("Contact Us"),
        "current_password":
            MessageLookupByLibrary.simpleMessage("Current Password"),
        "date_Of_birth": MessageLookupByLibrary.simpleMessage("Date of birth"),
        "date_birth": MessageLookupByLibrary.simpleMessage("Date of Birth"),
        "delete_account":
            MessageLookupByLibrary.simpleMessage("Delete Account"),
        "didnt_get_token":
            MessageLookupByLibrary.simpleMessage("Didn\'t get? "),
        "dont_have_an_account":
            MessageLookupByLibrary.simpleMessage("Don\'t have an account?"),
        "edit_profile": MessageLookupByLibrary.simpleMessage("Edit Profile"),
        "email_id": MessageLookupByLibrary.simpleMessage("Email Id"),
        "enable_camera_permission_msg": MessageLookupByLibrary.simpleMessage(
            "Camera permission is required to capture photo. Please enable Camera permission from Settings."),
        "err_address":
            MessageLookupByLibrary.simpleMessage("Address is required."),
        "err_address_max_length": m1,
        "err_address_min_length": m2,
        "err_birth_date":
            MessageLookupByLibrary.simpleMessage("Birth date is required."),
        "err_current_password_max_length": m3,
        "err_current_password_min_length": m4,
        "err_email_id":
            MessageLookupByLibrary.simpleMessage("Email id is required."),
        "err_first_name":
            MessageLookupByLibrary.simpleMessage("First name is required."),
        "err_first_name_max_length": m5,
        "err_first_name_min_length": m6,
        "err_gender":
            MessageLookupByLibrary.simpleMessage("Gender is required."),
        "err_internet":
            MessageLookupByLibrary.simpleMessage("No internet connection."),
        "err_last_name":
            MessageLookupByLibrary.simpleMessage("Last name is required."),
        "err_last_name_max_length": m7,
        "err_last_name_min_length": m8,
        "err_length_mobile_number": MessageLookupByLibrary.simpleMessage(
            "Mobile number must have at least 10 characters."),
        "err_message":
            MessageLookupByLibrary.simpleMessage("Message is required."),
        "err_msg":
            MessageLookupByLibrary.simpleMessage("something went wrong."),
        "err_msg_confirm_password": MessageLookupByLibrary.simpleMessage(
            "Confirm password is required."),
        "err_msg_current_password": MessageLookupByLibrary.simpleMessage(
            "Current password is required."),
        "err_msg_new_password":
            MessageLookupByLibrary.simpleMessage("New password is required."),
        "err_msg_new_password_format": m9,
        "err_msg_otp": MessageLookupByLibrary.simpleMessage("OTP is required."),
        "err_msg_otp_length": MessageLookupByLibrary.simpleMessage(
            "OTP must have at least 6 characters."),
        "err_msg_profile":
            MessageLookupByLibrary.simpleMessage("Profile image is required."),
        "err_name_max_length": m10,
        "err_name_min_length": m11,
        "err_new_password_max_length": m12,
        "err_new_password_min_length": m13,
        "err_number":
            MessageLookupByLibrary.simpleMessage("Mobile number is required."),
        "err_password":
            MessageLookupByLibrary.simpleMessage("Password is required."),
        "err_password_max_length": m14,
        "err_password_min_length": m15,
        "err_subject":
            MessageLookupByLibrary.simpleMessage("Subject is required."),
        "err_valid_confirm_password": MessageLookupByLibrary.simpleMessage(
            "New password and Confirm password doesn’t match."),
        "err_valid_password": m16,
        "err_valid_reenter_password": MessageLookupByLibrary.simpleMessage(
            "Password and Confirm password doesn’t match."),
        "error_image_size": MessageLookupByLibrary.simpleMessage(
            "Image size should be less than 15Mb."),
        "error_verify_otp": MessageLookupByLibrary.simpleMessage(
            "something went wrong please try again after some time."),
        "first_name": MessageLookupByLibrary.simpleMessage("First Name"),
        "forgot_Password":
            MessageLookupByLibrary.simpleMessage("Forgot Password"),
        "forgot_Password_":
            MessageLookupByLibrary.simpleMessage("Forgot Password?"),
        "forgot_password_msg": MessageLookupByLibrary.simpleMessage(
            "Don’t worry! It happens , Please enter the email id associated with your account."),
        "gallery": MessageLookupByLibrary.simpleMessage("Gallery"),
        "gender": MessageLookupByLibrary.simpleMessage("Gender"),
        "home": MessageLookupByLibrary.simpleMessage("Home"),
        "internet_msg": MessageLookupByLibrary.simpleMessage(
            "Could not connect to the internet."),
        "invalid_email_id":
            MessageLookupByLibrary.simpleMessage("Invalid email id."),
        "invalid_mobile_number":
            MessageLookupByLibrary.simpleMessage("Invalid mobile number."),
        "last_name": MessageLookupByLibrary.simpleMessage("Last Name"),
        "later": MessageLookupByLibrary.simpleMessage("Later"),
        "login": MessageLookupByLibrary.simpleMessage("Login"),
        "logout": MessageLookupByLibrary.simpleMessage("Logout"),
        "message": MessageLookupByLibrary.simpleMessage("Message"),
        "mobile_number": MessageLookupByLibrary.simpleMessage("Mobile Number"),
        "msg_delete_account": MessageLookupByLibrary.simpleMessage(
            "Are you sure you want to delete account?"),
        "msg_logout": MessageLookupByLibrary.simpleMessage(
            "Are you sure you want to logout?"),
        "name": MessageLookupByLibrary.simpleMessage("Name"),
        "new_password": MessageLookupByLibrary.simpleMessage("New Password"),
        "ok": MessageLookupByLibrary.simpleMessage("Ok"),
        "open_settings": MessageLookupByLibrary.simpleMessage("Open Settings"),
        "otp": MessageLookupByLibrary.simpleMessage("OTP"),
        "password": MessageLookupByLibrary.simpleMessage("Password"),
        "pavans_group": MessageLookupByLibrary.simpleMessage("Pavans Group"),
        "privacy_policy":
            MessageLookupByLibrary.simpleMessage("Privacy Policy"),
        "profile": MessageLookupByLibrary.simpleMessage("Profile"),
        "resend_otp": MessageLookupByLibrary.simpleMessage("Resend OTP"),
        "reset_password":
            MessageLookupByLibrary.simpleMessage("Reset Password"),
        "save": MessageLookupByLibrary.simpleMessage("Save"),
        "sendOtp": MessageLookupByLibrary.simpleMessage("Send OTP"),
        "sign_in": MessageLookupByLibrary.simpleMessage("Sign In"),
        "sign_up": MessageLookupByLibrary.simpleMessage("Sign Up"),
        "skip": MessageLookupByLibrary.simpleMessage("Skip"),
        "submit": MessageLookupByLibrary.simpleMessage("Submit"),
        "success_login": MessageLookupByLibrary.simpleMessage(
            "You have logged in successfully"),
        "terms_conditions":
            MessageLookupByLibrary.simpleMessage("terms and conditions"),
        "terms_service":
            MessageLookupByLibrary.simpleMessage("Terms of Service"),
        "try_again": MessageLookupByLibrary.simpleMessage("Try Again"),
        "update_app": MessageLookupByLibrary.simpleMessage("Update App"),
        "update_app_head_title": MessageLookupByLibrary.simpleMessage(
            "A new version of app is now available."),
        "update_app_note": MessageLookupByLibrary.simpleMessage(
            "We’ve made some changes to make your experience as great as possible!\n\nWould you like to update it now?"),
        "update_now": MessageLookupByLibrary.simpleMessage("Update Now"),
        "upgrade_description": MessageLookupByLibrary.simpleMessage(
            "You are using old version of the app. Kindly update to latest version to take advantages of latest features."),
        "verification": MessageLookupByLibrary.simpleMessage("Verification"),
        "verification_mail_sent_msg": m17,
        "verify": MessageLookupByLibrary.simpleMessage("Verify"),
        "verify_your_email_msg":
            MessageLookupByLibrary.simpleMessage("Verify your email id!"),
        "yes": MessageLookupByLibrary.simpleMessage("Yes")
      };
}
