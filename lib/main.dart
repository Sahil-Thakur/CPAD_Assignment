import 'package:cpad_assignment/layouts/employee_login_screen.dart';
import 'package:cpad_assignment/theme.dart';
import 'package:flutter/material.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  const String appId = 'jwo9kQ0d412G598saczMjBtp4Mge1Pd8oDpswsH6';
  const String clientKey = 'yaKZg3QzNZ4OVWOPjCLYAOzvXOmbEjgHX76T2r61';
  const String serverUrl = 'https://parseapi.back4app.com';

  await Parse().initialize(
    appId,
    serverUrl,
    clientKey: clientKey,
    debug: true,
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: lightTheme,
      darkTheme: darkTheme,
      themeMode: ThemeMode.system, // Can be light or dark
      home: const EmployeeLoginScreen(),
    );
  }
}