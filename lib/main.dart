import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:html/parser.dart';
import 'package:http/http.dart' as http;
import 'package:footer/footer.dart';

class AppPlatform {
  static const Map<String, CustomPlatform> _platfromMap = {
    'linux': CustomPlatform.linux,
    'macos': CustomPlatform.macos,
    'windows': CustomPlatform.windows,
    'android': CustomPlatform.android,
    'ios': CustomPlatform.ios,
    'fuchsia': CustomPlatform.fuchsia,
  };

  static CustomPlatform? _getPlatform() {
    if (kIsWeb) {
      return CustomPlatform.web;
    }

    return _platfromMap[Platform.operatingSystem] ?? CustomPlatform.undefined;
  }

  static CustomPlatform? get platform => _getPlatform();
}

enum CustomPlatform {
  linux,
  macos,
  windows,
  ios,
  android,
  fuchsia,
  web,
  undefined,
}

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late TextEditingController _controller;

  String _bodyText = '';
  String _pageTitle = '';
  String _corsHeader = '';

  Future<(String, String, String)> fetchData() async {
    var customHeaders = {
      "Access-Control-Allow-Origin": "*",
      "Access-Control-Allow-Credentials": "true",
      "Access-Control-Allow-Headers":
          "Origin,Content-Type,X-Amz-Date,Authorization,X-Api-Key,X-Amz-Security-Token,locale",
      "Access-Control-Allow-Methods": "POST, OPTIONS"
    };

    var result = await http.get(Uri.parse(userUrl), headers: customHeaders);

    String cors = 'CORS Header: None';
    result.headers.forEach((key, value) {
      if (key == 'access-control-allow-origin') {
        cors = value;
      }
    });

    return (
      _bodyText = result.body,
      _pageTitle = parse(result.body).querySelector('h1')!.text,
      _corsHeader = cors
    );
  }

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
    _controller.text = 'https://flutter.dev';
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  String userUrl = 'https://flutter.dev';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
            child: FutureBuilder<(String, String, String)>(
                future: fetchData(), // async work
                builder: (_, snapshot) {
                  switch (snapshot.connectionState) {
                    case ConnectionState.waiting:
                      return const Center(child: Text('Loading....'));
                    default:
                      if (snapshot.hasError) {
                        return Center(child: Text('Error: ${snapshot.error}'));
                      } else {
                        return Column(
                          children: [
                            Text(_pageTitle),
                            Text(
                              _corsHeader,
                              style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.redAccent),
                            ),
                            Expanded(flex: 3, child: Text(_bodyText)),
                            Expanded(
                              child: TextField(
                                controller: _controller,
                                decoration: InputDecoration(
                                  labelText: 'Введите URL',
                                  suffixIcon: ElevatedButton(
                                    child: const Text('LOAD'),
                                    onPressed: () async {
                                      userUrl = _controller.value.text;
                                      // await fetchData(userUrl);
                                      setState(() {});
                                    },
                                  ),
                                ),
                                onSubmitted: (value) async {
                                  userUrl = value;
                                  // await fetchData(userUrl);
                                  setState(() {});
                                },
                              ),
                            ),
                            Footer(
                                child: platfromText(), //The child Widget is mandatory takes any Customisable Widget for the footer
                                backgroundColor: Colors.grey
                                    .shade200, // defines the background Colors of the Footer with default Colors.grey.shade200
                                padding: const EdgeInsets.all(
                                    1.0), // Takes EdgeInsetsGeometry with default being EdgeInsets.all(5.0)
                                alignment: Alignment
                                    .bottomCenter //this is of type Aligment with default being Alignment.bottomCenter
                                ),
                          ],
                        );
                      }
                  }
                })));
  }
}

Text platfromText() {
  String platfromText = AppPlatform.platform.toString().toUpperCase().replaceAll('CUSTOMPLATFORM.', '');

  return Text('APPLICTION RUNNING ON $platfromText', style: TextStyle(fontWeight: FontWeight.bold));
}
