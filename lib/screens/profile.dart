// ignore_for_file: constant_identifier_names
import 'package:fluent_ui/fluent_ui.dart';
import 'package:provider/provider.dart';
import 'package:win_ui/core/constants/route_names.dart';
import 'package:win_ui/core/providers/auth_state.dart';

import 'package:win_ui/main.dart' show rootNavigatorKey, router;
import 'package:win_ui/widgets/page.dart';
import 'package:win_ui/widgets/pane_profile_card.dart';

class Profile extends ScrollablePage {
  Profile({super.key});

  @override
  Widget buildHeader(BuildContext context) {
    return const PageHeader(title: Text('Profile'));
  }

  onLogout(BuildContext context, AuthState state) {
    Flyout.of(context).close();
    state.logout();
  }

  @override
  List<Widget> buildScrollable(BuildContext context) {
    assert(debugCheckHasMediaQuery(context));
    const spacer = SizedBox(height: 7.0);
    final attachKey = GlobalKey();
    final controller = FlyoutController();

    return [
      Consumer<AuthState>(builder: (context, state, child) {
        if (!state.isLoggedIn) return Container();
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const PaneProfileCard(showLargeCard: true, onTap: null),
            FlyoutTarget(
              key: attachKey,
              controller: controller,
              child: Button(
                child: const Text('Logout'),
                onPressed: () async {
                  controller.showFlyout(
                    navigatorKey: rootNavigatorKey.currentState,
                    builder: (context) {
                      return FlyoutContent(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'You will be logged out. Are you sure you want to continue?',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 12.0),
                            Button(
                              onPressed: () => onLogout(context, state),
                              child: const Text('Yes, Logout'),
                            ),
                          ],
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        );
      }),
      spacer,
      spacer,
      spacer,
      Button(
        onPressed: () {
          router.pushNamed(RouteNames.withoutPrefix.yourInfo);
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10.0),
          child: Align(
            alignment: AlignmentDirectional.topStart,
            child: Row(
              children: [
                const Padding(
                  padding: EdgeInsets.only(right: 18.0, left: 10.0),
                  child: Icon(FluentIcons.contact_info, size: 18.0),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Your info', style: FluentTheme.of(context).typography.body),
                    Text('Profile photo', style: FluentTheme.of(context).typography.caption)
                  ],
                ),
                const Spacer(),
                const Padding(
                  padding: EdgeInsets.only(right: 8.0),
                  child: Icon(FluentIcons.chevron_right_med, size: 11.0),
                ),
              ],
            ),
          ),
        ),
      ),
      spacer,
      Button(
        onPressed: () {
          router.pushNamed(RouteNames.withoutPrefix.sessions);
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10.0),
          child: Align(
            alignment: AlignmentDirectional.topStart,
            child: Row(
              children: [
                const Padding(
                  padding: EdgeInsets.only(right: 18.0, left: 10.0),
                  child: Icon(FluentIcons.account_activity, size: 18.0),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Sessions', style: FluentTheme.of(context).typography.body),
                    Text('Devices you are logged in', style: FluentTheme.of(context).typography.caption)
                  ],
                ),
                const Spacer(),
                const Padding(
                  padding: EdgeInsets.only(right: 8.0),
                  child: Icon(FluentIcons.chevron_right_med, size: 11.0),
                ),
              ],
            ),
          ),
        ),
      ),
    ];
  }
}
