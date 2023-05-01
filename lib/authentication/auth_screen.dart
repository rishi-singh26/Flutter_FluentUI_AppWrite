import 'package:fluent_ui/fluent_ui.dart' hide Page;
import 'package:flutter/foundation.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:window_manager/window_manager.dart';

import 'package:win_ui/authentication/components/login_screen.dart';
import 'package:win_ui/authentication/components/reset_password.dart';
import 'package:win_ui/authentication/components/signup_screen.dart';
import 'package:win_ui/core/providers/theme.dart';
import 'package:win_ui/widgets/window_buttons.dart';
import 'package:win_ui/core/constants/route_names.dart';

const String appTitle = 'Accountancy';

/// Checks if the current environment is a desktop environment.
bool get isDesktop {
  if (kIsWeb) return false;
  return [
    TargetPlatform.windows,
    TargetPlatform.linux,
    TargetPlatform.macOS,
  ].contains(defaultTargetPlatform);
}

class AuthenticationPage extends StatefulWidget {
  const AuthenticationPage({
    Key? key,
    required this.child,
    required this.shellContext,
    required this.state,
  }) : super(key: key);

  final Widget child;
  final BuildContext? shellContext;
  final GoRouterState state;

  @override
  State<AuthenticationPage> createState() => _AuthenticationPageState();
}

class _AuthenticationPageState extends State<AuthenticationPage> with WindowListener {
  final viewKey = GlobalKey(debugLabel: 'Navigation View Key');
  final searchKey = GlobalKey(debugLabel: 'Search Bar Key');
  final searchFocusNode = FocusNode();
  final searchController = TextEditingController();
  bool isAuthenticated = false;

  final List<NavigationPaneItem> originalItems = [
    PaneItem(
      key: const Key('/'),
      icon: const Icon(FluentIcons.signin),
      title: const Text('Login'),
      body: const SizedBox.shrink(),
      onTap: () {
        if (authenticationRouter.location != '/') {
          authenticationRouter.pushNamed(RouteNames.withoutPrefix.login);
        }
      },
    ),
    PaneItem(
      key: Key(RouteNames.withPrefix.signUp),
      icon: const Icon(FluentIcons.signin),
      title: const Text('SignUp'),
      body: const SizedBox.shrink(),
      onTap: () {
        if (authenticationRouter.location != RouteNames.withPrefix.signUp) {
          authenticationRouter.pushNamed(RouteNames.withoutPrefix.signUp);
        }
      },
    ),
    PaneItem(
      key: Key(RouteNames.withPrefix.resetPassword),
      icon: const Icon(FluentIcons.reset),
      title: const Text('Reset Password'),
      body: const SizedBox.shrink(),
      onTap: () {
        if (authenticationRouter.location != RouteNames.withPrefix.resetPassword) {
          authenticationRouter.pushNamed(RouteNames.withoutPrefix.resetPassword);
        }
      },
    ),
  ];

  @override
  void initState() {
    windowManager.addListener(this);
    super.initState();
  }

  @override
  void dispose() {
    windowManager.removeListener(this);
    searchController.dispose();
    searchFocusNode.dispose();
    super.dispose();
  }

  int _calculateSelectedIndex(BuildContext context) {
    final location = authenticationRouter.location;
    int indexOriginal = originalItems
        .where((element) => element.key != null)
        .toList()
        .indexWhere((element) => element.key == Key(location));

    if (indexOriginal == -1) {
      return originalItems.where((element) => element.key != null).toList().length;
    } else {
      return indexOriginal;
    }
  }

  @override
  Widget build(BuildContext context) {
    final localizations = FluentLocalizations.of(context);

    final appTheme = context.watch<AppTheme>();
    final theme = FluentTheme.of(context);
    if (widget.shellContext != null) {
      if (authenticationRouter.canPop() == false) {
        setState(() {});
      }
    }
    return NavigationView(
      key: viewKey,
      appBar: NavigationAppBar(
        automaticallyImplyLeading: false,
        leading: () {
          final enabled = widget.shellContext != null && authenticationRouter.canPop();
          final onPressed = enabled
              ? () {
                  if (authenticationRouter.canPop()) {
                    context.pop();
                    setState(() {});
                  }
                }
              : null;
          return NavigationPaneTheme(
            data: NavigationPaneTheme.of(context).merge(NavigationPaneThemeData(
              unselectedIconColor: ButtonState.resolveWith((states) {
                if (states.isDisabled) {
                  return ButtonThemeData.buttonColor(context, states);
                }
                return ButtonThemeData.uncheckedInputColor(
                  FluentTheme.of(context),
                  states,
                ).basedOnLuminance();
              }),
            )),
            child: Builder(
              builder: (context) => PaneItem(
                icon: const Center(child: Icon(FluentIcons.back, size: 12.0)),
                title: Text(localizations.backButtonTooltip),
                body: const SizedBox.shrink(),
                enabled: enabled,
              ).build(
                context,
                false,
                onPressed,
                displayMode: PaneDisplayMode.compact,
              ),
            ),
          );
        }(),
        title: () {
          if (kIsWeb) {
            return const Align(
              alignment: AlignmentDirectional.centerStart,
              child: Text(appTitle),
            );
          }
          return const DragToMoveArea(
            child: Align(
              alignment: AlignmentDirectional.centerStart,
              child: Text(appTitle),
            ),
          );
        }(),
        actions: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: const [if (!kIsWeb) WindowButtons()],
        ),
      ),
      paneBodyBuilder: (item, child) {
        final name = item?.key is ValueKey ? (item!.key as ValueKey).value : null;
        return FocusTraversalGroup(
          key: ValueKey('body$name'),
          child: widget.child,
        );
      },
      pane: NavigationPane(
        selected: _calculateSelectedIndex(context),
        header: SizedBox(
          height: kOneLineTileHeight,
          child: ShaderMask(
            shaderCallback: (rect) {
              final color = appTheme.color.defaultBrushFor(
                theme.brightness,
              );
              return LinearGradient(
                colors: [
                  color,
                  color,
                ],
              ).createShader(rect);
            },
            child: Text('Accountancy', style: FluentTheme.of(context).typography.title),
          ),
        ),
        displayMode: appTheme.displayMode,
        indicator: () {
          switch (appTheme.indicator) {
            case NavigationIndicators.end:
              return const EndNavigationIndicator();
            case NavigationIndicators.sticky:
            default:
              return const StickyNavigationIndicator();
          }
        }(),
        items: originalItems,
      ),
    );
  }

  @override
  void onWindowClose() async {
    bool isPreventClose = await windowManager.isPreventClose();
    if (isPreventClose) {
      // ignore: use_build_context_synchronously
      showDialog(
        context: context,
        builder: (_) {
          return ContentDialog(
            title: const Text('Confirm close'),
            content: const Text('Are you sure you want to close this window?'),
            actions: [
              FilledButton(
                child: const Text('Yes'),
                onPressed: () {
                  Navigator.pop(context);
                  windowManager.destroy();
                },
              ),
              Button(
                child: const Text('No'),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ],
          );
        },
      );
    }
  }
}

final authRootNavigatorKey = GlobalKey<NavigatorState>();
final _authShellNavigatorKey = GlobalKey<NavigatorState>();
final authenticationRouter = GoRouter(
  navigatorKey: authRootNavigatorKey,
  routes: [
    ShellRoute(
      navigatorKey: _authShellNavigatorKey,
      builder: (context, state, child) {
        return AuthenticationPage(
          shellContext: _authShellNavigatorKey.currentContext,
          state: state,
          child: child,
        );
      },
      routes: [
        /// Home
        GoRoute(
          path: '/',
          name: RouteNames.withoutPrefix.login,
          builder: (context, state) => const LoginPage(),
        ),

        GoRoute(
          path: RouteNames.withPrefix.signUp,
          name: RouteNames.withoutPrefix.signUp,
          builder: (context, state) => const SignUpPage(),
        ),

        /// Settings
        GoRoute(
          path: RouteNames.withPrefix.resetPassword,
          name: RouteNames.withoutPrefix.resetPassword,
          builder: (context, state) => const ResetPasswordPage(),
        ),
      ],
    ),
  ],
);
