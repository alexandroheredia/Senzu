import 'package:flutter/cupertino.dart';
import 'package:senzu_app/screens/authentication/services/wrapper.dart';
import 'package:senzu_app/screens/nutrients_display/nutrient_pages/vitamin_c.dart';


class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/':
        return CupertinoPageRoute(builder: (_) => Wrapper());
      case '/quesh':
        return CupertinoPageRoute(builder: (_) => VitaminC());
      case '/vitaminC':
        // Validation of correct data type
        // if (args is String) {
        //   return CupertinoPageRoute(
        //     builder: (_) => Fiber(
        //           documentID: args, 
        //         ),
        //   );
        // }
        // If args is not of the correct type, return an error page.
        // You can also throw an exception while in development.
        return _errorRoute();
        
      case '/sign_up':
        // return CupertinoPageRoute(builder: (_) => Register(toggleView: null,));
      case '/sign_in':
        // return CupertinoPageRoute(builder: (_) => LoginForm(toggleView: null,));
      default:
        // If there is no such named route in the switch statement, e.g. /third
        return _errorRoute();
    }
  }

  static Route<dynamic> _errorRoute() {
    return CupertinoPageRoute(builder: (_) {
      return CupertinoPageScaffold(
        navigationBar: CupertinoNavigationBar(
          middle: Text('Error'),
        ),
        child: Center(
          child: Text('ERROR'),
        ),
      );
    });
  }
}