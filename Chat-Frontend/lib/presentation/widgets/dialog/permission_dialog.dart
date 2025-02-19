import 'package:flutter/material.dart';

void showPerDialog(BuildContext context, String permission, Function()? onYes) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('Are you sure?'),
        content: Text('Do you really want to $permission?'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(); // Close the dialog
            },
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: onYes,
            child: const Text('Yes'),
          ),
        ],
      );
    },
  );
}
