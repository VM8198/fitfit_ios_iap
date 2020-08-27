import 'dart:io' show Platform;
import 'package:flutter_fitfit/provider/auth_provider.dart';
import 'package:flutter_fitfit/provider/cw_provider.dart';
import 'package:flutter_fitfit/provider/homepage_provider.dart';
import 'package:flutter_fitfit/provider/profile_provider.dart';
import 'package:flutter_fitfit/provider/pt_provider.dart';
import 'package:flutter_fitfit/provider/question_provider.dart';
import 'package:flutter_fitfit/provider/timer_provider.dart';
import 'package:flutter_fitfit/provider/workout_provider.dart';
import 'package:flutter_fitfit/utility/pref.dart';
import 'package:flutter_statusbarcolor/flutter_statusbarcolor.dart';
import 'package:provider/provider.dart';
import 'package:pushy_flutter/pushy_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_fitfit/screen/welcome.dart';
import 'package:flutter_fitfit/utility/nav.dart';
import 'package:flutter_fitfit/utility/router.dart';
import 'package:in_app_purchase/in_app_purchase.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  var _initialRoute = WelcomePage.routeName;
  
  String token = await Pref.getToken();
  
  if (token != null) {
    _initialRoute = '/first-time-subscription'; // for Demo purpose, need to replace with actual home page
  }
  InAppPurchaseConnection.enablePendingPurchases();
  FlutterStatusbarcolor.setStatusBarWhiteForeground(false);
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown])
  .then((_) => runApp(Fitfit(_initialRoute)));
  
}

class Fitfit extends StatefulWidget {
  final String _initialRoute;

  Fitfit(this._initialRoute);

  @override
  _FitfitState createState() => _FitfitState();
}

class _FitfitState extends State<Fitfit> {
  String _deviceToken = 'Loading...';
	String _instruction = '(please wait)';

  @override
  void initState() {
		super.initState();
	}

	Future<void> initPlatformState() async {
		// Start the Pushy service
		// Pushy.listen();

		// Request the WRITE_EXTERNAL_STORAGE permission on Android so that the Pushy SDK will be able to persist the device token in the external storage
		// Pushy.requestStoragePermission();

		// Set custom notification icon (Android)
    // Pushy.setNotificationIcon('ic_notify');
		try {

			// Register the device for push notifications
			String deviceToken = await Pushy.register();

			// Print token to console/logcat
			print('Device token: $deviceToken');

			// Update UI with token
			setState(() {
				_deviceToken = deviceToken;
				_instruction =
					Platform.isAndroid ? '(copy from logcat)' : '(copy from console)';
			});
		} on PlatformException catch (error) {
			// Print to console/logcat
			print('Error: ${error.message}');

			// Show error
			setState(() {
				_deviceToken = 'Registration failed';
				_instruction = '(restart app to try again)';
			});
		}

    try {

      // Make sure the device is registered
      if (await Pushy.isRegistered()) {
        // Subscribe the device to a topic
        await Pushy.subscribe('general');

        // Subscribe successful
        print('Subscribed to topic successfully');
      }
    } on PlatformException catch (error) {
        // Subscribe failed, notify the user
        showDialog(
            context: context,
            builder: (BuildContext context) {
            return AlertDialog(
                title: Text('Subscribe failed'),
                content: Text(error.message),
                actions: [ FlatButton( child: Text('OK'), onPressed: () { Navigator.of(context, rootNavigator: true).pop('dialog'); } )]
                );
            }
        );
    }

		// Listen for push notifications
		Pushy.setNotificationListener((Map<String, dynamic> data) {
			// Print notification payload data
			print('Received notifications: $data');

			// Clear iOS app badge number
			Pushy.clearBadge();

			// Extract notification messsage
			String message = data['message'] ?? 'Hello World!';

			// Display an alert with the "message" payload value
			showDialog(
				context: context,
				builder: (BuildContext context) {
				return AlertDialog(
					title: Text('Pushy'),
					content: Text(message),
					actions: [
						FlatButton(
							child: Text('OK'),
							onPressed: () {
								Navigator.of(context, rootNavigator: true).pop('dialog');
							},
						)
					]);
				},
			);
		});
	}

  @override
  Widget build(BuildContext context) {
    // initPlatformState();

    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => new AuthProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => new HomePageProvider(),
        ),
        ChangeNotifierProvider(
          lazy: true,
          create: (_) => new CwProvider()
        ),
        ChangeNotifierProvider(
          lazy: true,
          create: (_) => new QuestionProvider()
        ),
        ChangeNotifierProvider(
          lazy: true,
          create: (_) => new WorkoutProvider()
        ),
        ChangeNotifierProvider(
          lazy: true,
          create: (_) => new PtProvider()
        ),
        ChangeNotifierProvider(
          lazy: true,
          create: (_) => new TimerProvider()
        ),
        ChangeNotifierProvider(
          lazy: true,
          create: (_) => new ProfileProvider()
        ),
      ],
      child: MaterialApp(
        title: 'Fit Fit',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        initialRoute: widget._initialRoute,
        onGenerateRoute: Router.onGenerateRoute,
        navigatorKey: Nav.navigatorKey,
        debugShowCheckedModeBanner: false,
        builder: (BuildContext context, Widget child) {
          return MediaQuery(
            data: MediaQuery.of(context).copyWith(
              textScaleFactor: 1
            ),
            child: child
          );
        }
      ),
    );
  }
}
