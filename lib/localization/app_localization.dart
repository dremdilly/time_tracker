import 'package:flutter/material.dart';
import 'package:time_tracker/localization/app_localization_controller.dart';
import 'package:time_tracker/localization/app_localization_delegate.dart';
import 'package:time_tracker/localization/app_localization_provider.dart';
import 'package:time_tracker/localization/asset_loader.dart';

class AppLocalization extends StatefulWidget {
  final Widget child;
  final List<Locale> supportedLocales;
  final bool saveLocale;
  final String path;
  final Locale fallbackLocale;
  final Locale? defaultLocale;
  final Widget Function(FlutterError? message)? errorWidget;

  const AppLocalization({
    Key? key,
    required this.child,
    required this.supportedLocales,
    this.saveLocale = true,
    this.path = 'assets/translations',
    this.errorWidget,
    this.fallbackLocale = const Locale('en'),
    this.defaultLocale,
  }) : super(key: key);

  static AppLocalizationProvider of(BuildContext context) =>
      AppLocalizationProvider.of(context)!;

  static Future<void> ensureInitialized() async {
    await AppLocalizationController.initAppLocalization();
  }

  @override
  _AppLocalizationState createState() => _AppLocalizationState();
}

class _AppLocalizationState extends State<AppLocalization> {
  late AppLocalizationController controller;
  FlutterError? translationsLoadError;

  @override
  void initState() {
    controller = AppLocalizationController(
        supportedLocales: widget.supportedLocales,
        saveLocale: widget.saveLocale,
        path: widget.path,
        fallbackLocale: widget.fallbackLocale,
        assetLoader: const RootBundleAssetLoader(),
        defaultLocale: widget.defaultLocale,
        onLoadError: (error) {
          setState(() => translationsLoadError = error);
        }
    );
    controller.addListener(() {
      if (mounted) setState(() {});
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (translationsLoadError != null) {
      return ErrorWidget(translationsLoadError!);
    }
    return AppLocalizationProvider(
      controller,
      parent: widget,
      delegate: AppLocalizationDelegate(
        supportedLocales: widget.supportedLocales,
        controller: controller,
      ),
    );
  }
}