import 'package:fluent_ui/fluent_ui.dart';

class DialogService {
  static DialogContent deleteSessionContent = DialogContent(
    content: 'You will be logged of this session.',
    primaryBtnText: 'Cancel',
    secondaryBtnText: 'Delete',
    title: 'Are you sure?',
  );

  static Future<bool> showConfirmationDialog(BuildContext context, DialogContent content) async {
    return await showDialog<bool>(
          context: context,
          builder: (context) => ContentDialog(
            title: Text(content.title),
            content: Text(content.content),
            actions: [
              Button(
                child: Text(content.secondaryBtnText),
                onPressed: () {
                  Navigator.pop(context, true);
                },
              ),
              FilledButton(
                child: Text(content.primaryBtnText),
                onPressed: () => Navigator.pop(context, false),
              ),
            ],
          ),
        ) ??
        false;
  }
}

class DialogContent {
  final String title;
  final String content;
  final String primaryBtnText;
  final String secondaryBtnText;

  DialogContent({
    required this.content,
    required this.primaryBtnText,
    required this.secondaryBtnText,
    required this.title,
  });
}
