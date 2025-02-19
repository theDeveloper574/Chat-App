import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

class Formatter {
  //hide keyboard
  static void hideKeyboard() =>
      SystemChannels.textInput.invokeMethod('TextInput.hide');
  //format date
  static String formatDateDat(DateTime date) {
    DateTime now = DateTime.now();
    Duration difference = now.difference(date);

    if (difference.inMinutes < 1) {
      return "Just now";
    } else if (difference.inMinutes == 1) {
      return "1 minute ago";
    } else if (difference.inMinutes < 60) {
      return "${difference.inMinutes} minutes ago";
    } else if (difference.inHours == 1) {
      return "1 hour ago";
    } else if (difference.inHours < 24) {
      return "${difference.inHours} hours ago";
    } else if (difference.inDays == 1) {
      return "1 day ago";
    } else if (difference.inDays < 7) {
      return "${difference.inDays} days ago";
    } else {
      final dateFormat = DateFormat("dd MMM y, hh:mm a");
      return dateFormat.format(date);
    }
  }

  //string format date time
  /// Format a nullable string date to a friendly time.
  static String formatDate(String? dateString) {
    if (dateString == null || dateString.isEmpty) {
      return "Invalid date";
    }

    try {
      // Parse the string to DateTime
      DateTime date = DateTime.parse(dateString);

      // Calculate the difference
      DateTime now = DateTime.now();
      Duration difference = now.difference(date);

      if (difference.inMinutes < 1) {
        return "Just now";
      } else if (difference.inMinutes == 1) {
        return "1 minute ago";
      } else if (difference.inMinutes < 60) {
        return "${difference.inMinutes} minutes ago";
      } else if (difference.inHours == 1) {
        return "1 hour ago";
      } else if (difference.inHours < 24) {
        return "${difference.inHours} hours ago";
      } else if (difference.inDays == 1) {
        return "1 day ago";
      } else if (difference.inDays < 7) {
        return "${difference.inDays} days ago";
      } else {
        // Default date format for older dates
        final dateFormat = DateFormat("dd MMM y, hh:mm a");
        return dateFormat.format(date);
      }
    } catch (e) {
      // Handle parsing errors
      return "Invalid date";
    }
  }

  //check device network connection

  /// Check Internet Connectivity
  Future<bool> isInternetAvailable() async {
    try {
      // Check connectivity type (Wi-Fi, Mobile, None)
      var connectivityResult = await Connectivity().checkConnectivity();

      if (connectivityResult == ConnectivityResult.none) {
        // No network connection
        return false;
      }

      // Attempt to connect to a known internet service (e.g., Google)
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        return true; // Internet is accessible
      }
    } catch (e) {
      // Handle exceptions (e.g., no DNS resolution, no network)
      if (kDebugMode) {
        print('Error checking internet connection: $e');
      }
    }

    // Return false if connectivity or internet access fails
    return false;
  }

  String generateUniqueId() {
    return DateTime.now().millisecondsSinceEpoch.toString();
  }
//if (!await Formatter().isInternetAvailable()) {
//       AppUtils().toast("No internet connection");
//       AppUtils().hideKeyboard();
//       return false;
//     }
}
