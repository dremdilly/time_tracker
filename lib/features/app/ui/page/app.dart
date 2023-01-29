import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:time_tracker/constants/app_display.dart';
import 'package:time_tracker/features/app/app_bloc/app_bloc.dart';
import 'package:time_tracker/features/app/ui/page/unauthenticated_app.dart';
import 'package:time_tracker/localization/app_localization.dart';
import 'package:time_tracker/theme/style.dart';

class App extends StatefulWidget {
  const App({Key? key}) : super(key: key);

  @override
  _AppState createState() => _AppState();
}

class _AppState extends State<App> {
  late AppBloc appBloc;

  @override
  void initState() {
    appBloc = AppBloc();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final provider = AppLocalization.of(context);

    return MultiBlocProvider(
        providers: [
          BlocProvider.value(value: appBloc),
        ],
        child: ScreenUtilInit(
          designSize: const Size(AppDisplay.mainWidth, AppDisplay.mainHeight),
          minTextAdapt: true,
          builder: (context, child) {
            return MaterialApp(
              theme: appThemeLight(context),
              darkTheme: appThemeDark(context),
              themeMode: ThemeMode.light,
              debugShowCheckedModeBanner: false,
              localizationsDelegates: provider.delegates,
              supportedLocales: provider.supportedLocales,
              locale: provider.locale,
              home: child,
            );
          },
          child: BlocConsumer<AppBloc, AppState>(
            listener: (context, state) {},
            builder: (context, state) {
              return UnauthenticatedApp();
            },
          ),
        ));
  }
}
