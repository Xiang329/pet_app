import 'package:flutter/cupertino.dart';
import 'package:pet_app/common/app_colors.dart';

class CommonDialog {
  CommonDialog._();

  static Future<void> showConfirmDialog({
    required BuildContext context,
    required String titleText,
    String? contentText,
    required Future<void> Function() onConfirmPressed,
  }) {
    final BuildContext loadDialogContext = context;
    final BuildContext errorDialogContext = context;
    return showCupertinoDialog(
      context: context,
      builder: (context) {
        return CupertinoAlertDialog(
          title: Text(titleText),
          content: contentText != null ? Text(contentText) : null,
          actions: <Widget>[
            CupertinoDialogAction(
              child: const Text('取消'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            CupertinoDialogAction(
              onPressed: () async {
                Navigator.of(context).pop();
                showCupertinoDialog(
                  context: loadDialogContext,
                  barrierDismissible: true,
                  builder: (context) {
                    return const CupertinoAlertDialog(
                      title: Text('刪除中...'),
                      content: CupertinoActivityIndicator(),
                    );
                  },
                );
                try {
                  await onConfirmPressed();
                  if (!loadDialogContext.mounted) return;
                  Navigator.of(loadDialogContext).pop();
                } catch (e) {
                  if (!loadDialogContext.mounted) return;
                  Navigator.of(loadDialogContext).pop();
                  if (!errorDialogContext.mounted) return;
                  showCupertinoDialog(
                    context: errorDialogContext,
                    builder: (context) {
                      return CupertinoAlertDialog(
                        title: const Text('錯誤'),
                        content: Text(e.toString()),
                        actions: <Widget>[
                          CupertinoDialogAction(
                            child: const Text('確定'),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                          ),
                        ],
                      );
                    },
                  );
                }
                // await onConfirmPressed().whenComplete(() {
                //   if (!dialogContext.mounted) return;
                //   Navigator.of(dialogContext).pop();
                // });
              },
              child: const Text(
                '刪除',
                style: TextStyle(
                  color: UiColor.errorColor,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
