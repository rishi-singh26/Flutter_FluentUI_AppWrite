import 'package:fluent_ui/fluent_ui.dart';

class FluentCard extends StatelessWidget {
  final Widget child;
  const FluentCard({Key? key, required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: SizedBox(
        width: double.infinity,
        child: child,
      ),
    );
  }
}

class FluentExpandingCard extends StatefulWidget {
  final Widget leading;
  final Widget title;
  final Widget content;
  const FluentExpandingCard({
    super.key,
    required this.leading,
    required this.title,
    required this.content,
  });

  @override
  State<FluentExpandingCard> createState() => _FluentExpandingCardState();
}

class _FluentExpandingCardState extends State<FluentExpandingCard>
    with AutomaticKeepAliveClientMixin<FluentExpandingCard> {
  final GlobalKey expanderKey = GlobalKey<ExpanderState>(
    debugLabel: 'Card Expander Key',
  );

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return Column(children: [
      Expander(
        key: expanderKey,
        leading: widget.leading,
        header: widget.title,
        content: widget.content,
      ),
    ]);
  }

  @override
  bool get wantKeepAlive => true;
}

const fluentHighlightTheme = {
  'root': TextStyle(
    backgroundColor: Color(0x00ffffff),
    color: Color(0xffdddddd),
  ),
  'keyword': TextStyle(color: Color.fromARGB(255, 255, 255, 255), fontWeight: FontWeight.bold),
  'selector-tag': TextStyle(color: Color(0xffffffff), fontWeight: FontWeight.bold),
  'literal': TextStyle(color: Color(0xffffffff), fontWeight: FontWeight.bold),
  'section': TextStyle(color: Color(0xffffffff), fontWeight: FontWeight.bold),
  'link': TextStyle(color: Color(0xffffffff)),
  'subst': TextStyle(color: Color(0xffdddddd)),
  'string': TextStyle(color: Color(0xffdd8888)),
  'title': TextStyle(color: Color(0xffdd8888), fontWeight: FontWeight.bold),
  'name': TextStyle(color: Color(0xffdd8888), fontWeight: FontWeight.bold),
  'type': TextStyle(color: Color(0xffdd8888), fontWeight: FontWeight.bold),
  'attribute': TextStyle(color: Color(0xffdd8888)),
  'symbol': TextStyle(color: Color(0xffdd8888)),
  'bullet': TextStyle(color: Color(0xffdd8888)),
  'built_in': TextStyle(color: Color(0xffdd8888)),
  'addition': TextStyle(color: Color(0xffdd8888)),
  'variable': TextStyle(color: Color(0xffdd8888)),
  'template-tag': TextStyle(color: Color(0xffdd8888)),
  'template-variable': TextStyle(color: Color(0xffdd8888)),
  'comment': TextStyle(color: Color(0xff777777)),
  'quote': TextStyle(color: Color(0xff777777)),
  'deletion': TextStyle(color: Color(0xff777777)),
  'meta': TextStyle(color: Color(0xff777777)),
  'doctag': TextStyle(fontWeight: FontWeight.bold),
  'strong': TextStyle(fontWeight: FontWeight.bold),
  'emphasis': TextStyle(fontStyle: FontStyle.italic),
};
