import 'package:fluent_ui/fluent_ui.dart';
import 'package:provider/provider.dart';
import 'package:win_ui/core/providers/auth_state.dart';

class PaneProfileCard extends StatelessWidget {
  final Function()? onTap;
  final bool showLargeCard;
  const PaneProfileCard({
    Key? key,
    this.onTap,
    this.showLargeCard = false,
  }) : super(key: key);

  String getShortName(String name) {
    List<String> nameParts = name.split(' ');
    String shortName = '';
    nameParts.fold(
      shortName,
      (previousValue, element) => shortName += element.length > 1 ? element[0] : element,
    );
    if (shortName.length > 2) {
      return shortName.substring(0, 2);
    }
    return shortName;
  }

  @override
  Widget build(BuildContext context) {
    final theme = FluentTheme.of(context);
    const miniSpacer = SizedBox(height: 2.0);
    return Consumer<AuthState>(builder: (context, state, child) {
      if (!state.isLoggedIn) return Container();
      if (showLargeCard) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.all(Radius.circular(50)),
                color: theme.inactiveColor,
                border: Border.all(color: theme.selectionColor),
              ),
              height: 100.0,
              width: 100.0,
              child: Center(child: Text(getShortName(state.user?.name ?? ''), style: theme.typography.title)),
            ),
            const SizedBox(width: 12.0),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(state.user?.name.toUpperCase() ?? '', style: theme.typography.bodyLarge),
                miniSpacer,
                Text(
                  state.user?.email ?? '',
                  style: theme.typography.caption?.copyWith(color: theme.activeColor),
                ),
                miniSpacer,
                Text(
                  state.user?.phone ?? '',
                  style: theme.typography.caption?.copyWith(color: theme.activeColor),
                ),
              ],
            )
          ],
        );
      }
      return Container(
        padding: const EdgeInsets.only(bottom: 10.0),
        child: IconButton(
          iconButtonMode: IconButtonMode.large,
          onPressed: onTap,
          icon: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.all(Radius.circular(32.5)),
                  color: theme.inactiveColor,
                  border: Border.all(color: theme.selectionColor),
                ),
                height: 65.0,
                width: 65.0,
                child: Center(
                  child: Text(getShortName(state.user?.name ?? ''), style: theme.typography.subtitle),
                ),
              ),
              const SizedBox(width: 12.0),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    state.user?.name ?? 'Name not available',
                    style: theme.typography.bodyStrong,
                    overflow: TextOverflow.fade,
                  ),
                  Text(
                    state.user?.email ?? 'Email not available',
                    style: theme.typography.body,
                    overflow: TextOverflow.fade,
                  ),
                ],
              )
            ],
          ),
        ),
      );
    });
  }
}
