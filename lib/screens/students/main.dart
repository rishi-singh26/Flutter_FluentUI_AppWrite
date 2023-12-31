import 'package:fluent_ui/fluent_ui.dart';
import 'package:win_ui/widgets/page.dart';

class StudentsPage extends StatefulWidget {
  const StudentsPage({Key? key}) : super(key: key);

  @override
  State<StudentsPage> createState() => _StudentsPageState();
}

class _StudentsPageState extends State<StudentsPage> with PageMixin {
  bool selected = true;
  String? comboboxValue;

  @override
  Widget build(BuildContext context) {
    assert(debugCheckHasFluentTheme(context));
    // final theme = FluentTheme.of(context);

    return ScaffoldPage.scrollable(
      header: PageHeader(
        title: const Text('Students'),
        commandBar: Row(mainAxisAlignment: MainAxisAlignment.end, children: [
          Button(
            // child: const Icon(FluentIcons.add, size: 18.0),
            child: const Text('Add'),
            onPressed: () {},
          ),
        ]),
      ),
      children: const [],
    );
  }
}
