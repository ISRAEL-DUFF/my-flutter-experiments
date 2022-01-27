import 'package:flutter/material.dart';
import 'package:trouter/pages/page_one.dart';
import 'package:trouter/pages/page_two.dart';
import './trouter.dart';

const String INVITE_LINK = '/app/invite';

var routes = {
  '/': (context) => MyHomePage(),
  '/page2': (context) => DemoPage2(),
};

TRouter myRouter = TRouter(routes: {
  // '/': RouteRedirect(to: '/app'),
  '/': (context) => MyHomePage(),
  // '/page1': (context) => RouteRedirect(to: '/'),
  '/page2': (context) => DemoPage2(),
  '/onboard': (context) => TestPage(n: 49),
  '/auth': Trouter(
      initialRoute: '/',
      guard: (path, arguments) {
        if (arguments == null) {
          return RouteGuard(allow: true);
        } else {
          return RouteGuard(allow: false, redirectTo: '/app');
        }
      },
      routes: {
        '/': RouteRedirect(to: '/auth/login'),
        '/register': (context) => TestPage(n: 50),
        '/login': (context) => TestPage(n: 51),
        '/otp': (context) => TestPage(n: 52),
        '/forgotpassword': (context) => TestPage(n: 53),
        '/newpassword': (context) => TestPage(n: 54)
      }),
  '/app': Trouter(
      initialRoute: '/',
      guard: (path, args) {
        if (args != null) {
          return RouteGuard(allow: true);
        } else {
          // for example:
          // return RouteGuard(allow: false, redirectTo: (context) => LoginPage());
          // OR
          // return RouteGuard(allow: false, redirectTo: '/auth/login');
          if (path == INVITE_LINK) {
            return RouteGuard(
                allow: false, redirectTo: '/auth/register', arguments: args);
          } else
            return RouteGuard(allow: false, redirectTo: '/auth/login');
        }
      },
      routes: {
        '/': (context) => TestPage(n: 70),
        '/profile': (context) => TestPage(n: 71),
        '/notification': (context) => TestPage(n: 72),
        '/invite': (context) => TestPage(n: 73), // TODO: fix this
        '/test': Trouter(initialRoute: '/', routes: {
          '/': (context) => TestPage(),
          '/p1': (context) => TestPage(n: 1),
          '/p2': (context) => TestPage(n: 2),
          '/p3': (context) => TestPage(n: 3),
          '/p4': Trouter(initialRoute: '/', routes: {
            '/': (context) => TestPage(n: 4),
            '/p5': (context) => TestPage(n: 5),
            '/p6': (context) => TestPage(n: 6),
            '/p7': Trouter(initialRoute: '/', routes: {
              '/': (context) => TestPage(n: 7),
              '/p8': (context) => TestPage(n: 8),
              '/p9': (context) => TestPage(n: 9)
            })
          }),
        })
      }),
  // '/register': (context) => SignUpPage(),
  // '/splashscreen': (context) => SplashScreen(),
  // '/': (context) => LoginPage()
}, bootStrapPage: MyHomePage());

// This function executes when the app Just launches
class TestPage extends StatelessWidget {
  int n;
  TestPage({this.n = 0});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
      child: Text('Test Page ${n}'),
    ));
  }
}




// TRouter myRouter = TRouter(routes: {
//   '/home': (context) {
//     if (sl<AppService>().userLoggedIn)
//       return CustomRouter(
//           initialRoute: '/',
//           parentName: '/home',
//           parentContext: context,
//           routes: {
//             '/': (context) => MyBottomNav(),
//             '/profile': (context) => ProfileIndex(),
//             '/notification': (context) => NotificationIndex(),
//             '/invite': (context) => ProfileIndex() // TODO: fix this
//           });
//     else
//       return LoginPage();
//   },
//   '/login': (context) => LoginPage(),
//   '/register': (context) => SignUpPage(),
//   '/onboard': (context) => OnboardingScreen(),
//   // '/splashscreen': (context) => SplashScreen(),
//   '/': (context) => LoginPage(),
// }, bootStrapPage: SplashPage(), bootstrapFn: routeBootStrapp);
