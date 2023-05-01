import 'package:fluent_ui/fluent_ui.dart';

class InfoBarService {
  static void showInfoBar(BuildContext context, InfoBarContent content) {
    displayInfoBar(context, builder: (context, close) {
      return InfoBar(
        title: Text(content.title),
        content: Text(content.contnet),
        // action: IconButton(
        //   icon: const Icon(FluentIcons.clear),
        //   onPressed: close,
        // ),
        onClose: close,
        severity: content.barSeverity,
        isLong: content.contnet.length > 200,
      );
    });
  }
}

class InfoBarContent {
  final String title;
  final String contnet;
  final InfoBarSeverity barSeverity;

  InfoBarContent({
    required this.title,
    required this.contnet,
    required this.barSeverity,
  });
}
