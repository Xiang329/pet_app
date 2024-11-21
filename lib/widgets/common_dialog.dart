import 'package:flutter/cupertino.dart';
import 'package:pet_app/common/app_colors.dart';

class CommonDialog {
  CommonDialog._();

  static Future<void> showRefreshDialog({
    required BuildContext context,
    required Future<void> Function() futureFunction,
  }) async {
    BuildContext? dialogContext;
    showCupertinoDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) {
        dialogContext = context;
        return const CupertinoAlertDialog(
          title: Text('更新中'),
          content: CupertinoActivityIndicator(),
        );
      },
    );

    await futureFunction();

    if (dialogContext != null) {
      if (!dialogContext!.mounted) return;
      Navigator.of(dialogContext!).pop();
    }
  }

  static Future<void> showConfirmDialog({
    required BuildContext context,
    required String titleText,
    String? contentText,
    required Future<void> Function() onConfirmPressed,
  }) {
    BuildContext? loadDialogContext;
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
                  context: context,
                  barrierDismissible: true,
                  builder: (context) {
                    loadDialogContext = context;
                    return const CupertinoAlertDialog(
                      title: Text('刪除中...'),
                      content: CupertinoActivityIndicator(),
                    );
                  },
                );
                try {
                  await onConfirmPressed();
                  if (loadDialogContext != null) {
                    if (!loadDialogContext!.mounted) return;
                    Navigator.of(loadDialogContext!).pop();
                  }
                } catch (e) {
                  if (loadDialogContext != null) {
                    if (!loadDialogContext!.mounted) return;
                    Navigator.of(loadDialogContext!).pop();
                  }
                  if (!context.mounted) return;
                  showCupertinoDialog(
                    context: context,
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
