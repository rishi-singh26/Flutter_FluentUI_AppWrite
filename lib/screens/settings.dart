// ignore_for_file: constant_identifier_names

import 'package:flutter/foundation.dart';

import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_acrylic/flutter_acrylic.dart';
import 'package:provider/provider.dart';

import 'package:win_ui/core/providers/theme.dart';
import 'package:win_ui/widgets/page.dart';
import 'package:win_ui/widgets/card_highlight.dart';

bool get kIsWindowEffectsSupported {
  return !kIsWeb &&
      [
        TargetPlatform.windows,
        // TargetPlatform.linux,
        TargetPlatform.macOS,
      ].contains(defaultTargetPlatform);
}

const _LinuxWindowEffects = [
  WindowEffect.disabled,
  WindowEffect.transparent,
];

const _WindowsWindowEffects = [
  WindowEffect.disabled,
  WindowEffect.solid,
  // WindowEffect.transparent,
  // WindowEffect.aero,
  WindowEffect.acrylic,
  // WindowEffect.mica,
  // WindowEffect.tabbed,
];

const _MacosWindowEffects = [
  WindowEffect.disabled,
  WindowEffect.titlebar,
  WindowEffect.selection,
  WindowEffect.menu,
  WindowEffect.popover,
  WindowEffect.sidebar,
  WindowEffect.headerView,
  WindowEffect.sheet,
  WindowEffect.windowBackground,
  WindowEffect.hudWindow,
  WindowEffect.fullScreenUI,
  WindowEffect.toolTip,
  WindowEffect.contentBackground,
  WindowEffect.underWindowBackground,
  WindowEffect.underPageBackground,
];

List<WindowEffect> get currentWindowEffects {
  if (kIsWeb) return [];

  if (defaultTargetPlatform == TargetPlatform.windows) {
    return _WindowsWindowEffects;
  } else if (defaultTargetPlatform == TargetPlatform.linux) {
    return _LinuxWindowEffects;
  } else if (defaultTargetPlatform == TargetPlatform.macOS) {
    return _MacosWindowEffects;
  }

  return [];
}

List<PaneDisplayMode> paneDisplayModeOptions = [
  PaneDisplayMode.compact,
  PaneDisplayMode.auto,
  PaneDisplayMode.open,
];

class Settings extends ScrollablePage {
  Settings({super.key});

  @override
  Widget buildHeader(BuildContext context) {
    return const PageHeader(title: Text('Settings'));
  }

  @override
  List<Widget> buildScrollable(BuildContext context) {
    assert(debugCheckHasMediaQuery(context));
    final appTheme = context.watch<AppTheme>();
    const spacer = SizedBox(height: 4.0);

    return [
      FluentCard(
        child: Align(
          alignment: AlignmentDirectional.topStart,
          child: Row(
            children: [
              const Padding(
                padding: EdgeInsets.only(right: 18.0, left: 10.0),
                child: Icon(FluentIcons.color),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Theme mode', style: FluentTheme.of(context).typography.body),
                  Text('Change the colors for the application', style: FluentTheme.of(context).typography.caption)
                ],
              ),
              const Spacer(),
              ComboBox<String>(
                value: appTheme.mode.toString().replaceAll('ThemeMode.', '').uppercaseFirst(),
                items: List.generate(ThemeMode.values.length, (index) {
                  final mode = ThemeMode.values[index];
                  final value = '$mode'.replaceAll('ThemeMode.', '').uppercaseFirst();
                  return ComboBoxItem(value: value, child: Text(value));
                }),
                onChanged: (value) {
                  if (value.runtimeType == String) {
                    for (var element in ThemeMode.values) {
                      final themeMode = '$element'.replaceAll('ThemeMode.', '').uppercaseFirst();
                      if (value == themeMode) {
                        appTheme.mode = element;
                        if (kIsWindowEffectsSupported) {
                          appTheme.setEffect(appTheme.windowEffect, context);
                        }
                        return;
                      }
                    }
                  }
                },
              ),
            ],
          ),
        ),
      ),
      // spacer,
      // FluentCard(
      //   child: Align(
      //     alignment: AlignmentDirectional.topStart,
      //     child: Row(
      //       children: [
      //         const Padding(
      //           padding: EdgeInsets.only(right: 18.0, left: 10.0),
      //           child: Icon(FluentIcons.nav2_d_map_view),
      //         ),
      //         Column(
      //           crossAxisAlignment: CrossAxisAlignment.start,
      //           children: [
      //             Text('Navigation Pane Display Mode', style: FluentTheme.of(context).typography.body),
      //             Text('Change the colors for the application', style: FluentTheme.of(context).typography.caption)
      //           ],
      //         ),
      //         const Spacer(),
      //         ComboBox<String>(
      //           value: appTheme.displayMode.toString().replaceAll('PaneDisplayMode.', '').uppercaseFirst(),
      //           items: List.generate(paneDisplayModeOptions.length, (index) {
      //             final mode = paneDisplayModeOptions[index];
      //             final value = '$mode'.replaceAll('PaneDisplayMode.', '').uppercaseFirst();
      //             return ComboBoxItem(value: value, child: Text(value));
      //           }),
      //           onChanged: (value) {
      //             if (value.runtimeType == String) {
      //               for (var element in PaneDisplayMode.values) {
      //                 final themeMode = '$element'.replaceAll('PaneDisplayMode.', '').uppercaseFirst();
      //                 if (value == themeMode) {
      //                   appTheme.displayMode = element;
      //                   if (kIsWindowEffectsSupported) {
      //                     appTheme.setEffect(appTheme.windowEffect, context);
      //                   }
      //                   return;
      //                 }
      //               }
      //             }
      //           },
      //         ),
      //       ],
      //     ),
      //   ),
      // ),
      if (kIsWindowEffectsSupported) ...[
        spacer,
        FluentCard(
          child: Align(
            alignment: AlignmentDirectional.topStart,
            child: Row(
              children: [
                const Padding(
                  padding: EdgeInsets.only(right: 18.0, left: 10.0),
                  child: Icon(FluentIcons.background_color),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Window Transparency (${defaultTargetPlatform.toString().replaceAll('TargetPlatform.', '')})',
                      style: FluentTheme.of(context).typography.body,
                    ),
                    Text('Change the colors for the application', style: FluentTheme.of(context).typography.caption)
                  ],
                ),
                const Spacer(),
                ComboBox<String>(
                  value: appTheme.windowEffect.toString().replaceAll('WindowEffect.', '').uppercaseFirst(),
                  items: List.generate(currentWindowEffects.length, (index) {
                    final mode = currentWindowEffects[index];
                    final value = '$mode'.replaceAll('WindowEffect.', '').uppercaseFirst();
                    return ComboBoxItem(value: value, child: Text(value));
                  }),
                  onChanged: (value) {
                    if (value.runtimeType == String) {
                      for (var element in currentWindowEffects) {
                        final themeMode = '$element'.replaceAll('WindowEffect.', '').uppercaseFirst();
                        if (value == themeMode) {
                          appTheme.windowEffect = element;
                          if (kIsWindowEffectsSupported) {
                            appTheme.setEffect(appTheme.windowEffect, context);
                          }
                          return;
                        }
                      }
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ],
    ];
  }
}
