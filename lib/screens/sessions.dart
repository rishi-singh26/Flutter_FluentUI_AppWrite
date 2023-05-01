import 'package:appwrite/models.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:provider/provider.dart';
import 'package:win_ui/core/providers/auth_state.dart';
import 'package:win_ui/core/services/date_service.dart';
import 'package:win_ui/core/services/dialog_service.dart';
import 'package:win_ui/core/services/info_bar_service.dart';
import 'package:win_ui/widgets/card_highlight.dart';
import 'package:win_ui/widgets/page.dart';

class SessionsPage extends StatefulWidget {
  const SessionsPage({Key? key}) : super(key: key);

  @override
  State<SessionsPage> createState() => _SessionsPageState();
}

class _SessionsPageState extends State<SessionsPage> with PageMixin {
  List<Session> sessionsList = [];
  String currentSessionId = '';

  @override
  void initState() {
    super.initState();
    _getSessions();
  }

  void _getSessions() async {
    AuthState authState = Provider.of<AuthState>(context, listen: false);
    SessionList list = await authState.account.listSessions();
    Session currentSession = await authState.account.getSession(sessionId: 'current');
    setState(() {
      sessionsList = list.sessions;
      currentSessionId = currentSession.$id;
    });
  }

  void _deleteSession(BuildContext context, Session session) async {
    final bool result = await DialogService.showConfirmationDialog(
      context,
      DialogService.deleteSessionContent,
    );
    if (!result) return;
    // ignore: use_build_context_synchronously
    final bool res = await Provider.of<AuthState>(context, listen: false).deleteSesion(session);
    if (res) {
      // ignore: use_build_context_synchronously
      InfoBarService.showInfoBar(
        context,
        InfoBarContent(
          title: 'Success',
          contnet: 'Session has been deleted.',
          barSeverity: InfoBarSeverity.success,
        ),
      );
      _getSessions();
      return;
    }
    // ignore: use_build_context_synchronously
    InfoBarService.showInfoBar(
      context,
      InfoBarContent(
        title: 'Error',
        contnet: 'An error occured while deleting the session, please try again.',
        barSeverity: InfoBarSeverity.error,
      ),
    );
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    assert(debugCheckHasFluentTheme(context));
    final theme = FluentTheme.of(context);
    return Consumer<AuthState>(
      builder: (context, state, child) {
        return ScaffoldPage.scrollable(
          header: const PageHeader(title: Text('Account sessions')),
          children: List.generate(sessionsList.length, (index) {
            Session session = sessionsList[index];
            return Padding(
              padding: const EdgeInsets.only(bottom: 5.0),
              child: FluentCard(
                child: Align(
                  alignment: AlignmentDirectional.topStart,
                  child: Row(
                    children: [
                      const Padding(
                        padding: EdgeInsets.only(right: 18.0, left: 10.0),
                        child: Icon(FluentIcons.user_window),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('${session.osName} ${session.osVersion}', style: theme.typography.body),
                          Text(
                            DateService.getDateToShow(DateTime.parse(session.$createdAt)),
                            style: theme.typography.caption,
                          )
                        ],
                      ),
                      const Spacer(),
                      if (currentSessionId == session.$id)
                        const Text('Current Session')
                      else
                        IconButton(
                          icon: const Icon(FluentIcons.delete),
                          onPressed: () => _deleteSession(context, session),
                        )
                    ],
                  ),
                ),
              ),
            );
          }),
        );
      },
    );
  }
}
