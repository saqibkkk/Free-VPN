import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class WatchAdDialog extends StatelessWidget {
  final VoidCallback onComplete;
  const WatchAdDialog({super.key, required this.onComplete});

  @override
  Widget build(BuildContext context) {
    return CupertinoAlertDialog(
      title: Text(' Change Theme '),
      content: Text('Watch an Ad to Change App Theme'),
      actions: [
        CupertinoDialogAction(
          textStyle: TextStyle(color: Colors.greenAccent.shade700),
          isDefaultAction: true,
          child: Text(
            'Watch Ad',
          ),
          onPressed: () {
            Get.back();
            onComplete();
          },
        ),
        CupertinoDialogAction(
            textStyle: TextStyle(color: Colors.redAccent.shade700),
            isDefaultAction: true,
            child: Text(
              'Cancel',
            ),
            onPressed: () {
              Get.back();
            })
      ],
    );
  }
}
