import 'package:flutter/cupertino.dart';
import 'package:time_tracker/routes.dart';

class UnauthenticatedApp extends StatelessWidget {
  final GlobalKey<NavigatorState> _navKey = GlobalKey<NavigatorState>();

  UnauthenticatedApp({ Key? key, }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (_navKey.currentState?.canPop() ?? false) {
          _navKey.currentState?.pop();
          return false;
        }
        return true;
      },
      child: GestureDetector(
        onTap: () {
          FocusScopeNode currentFocus = FocusScope.of(context);
          if (!currentFocus.hasPrimaryFocus) currentFocus.unfocus();
        },
        child: Navigator(
          key: _navKey,
          onGenerateRoute: Routes.unauthenticated,
        ),
      ),
    );
  }
}