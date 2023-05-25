import 'package:flutter/material.dart';
import 'data.dart';
import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:uni_links/uni_links.dart';
import 'package:url_launcher/url_launcher.dart';

class HomePage extends StatelessWidget {
  final List<Family> families;
  final ValueChanged<Family> onTap;
  const HomePage({required this.families, required this.onTap, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(title: const Text('Flutter Deep Linking Demo')),
        body: ListView(
          children: [
            for (final f in families)
              ListTile(title: Text(f.name), onTap: () => onTap(f))
          ],
        ),
      );
}

class FamilyPage extends StatelessWidget {
  final Family family;
  final ValueChanged<Person> onTap;
  const FamilyPage({required this.family, required this.onTap, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(title: Text(family.name)),
        body: ListView(
          children: [
            for (final p in family.people)
              ListTile(title: Text(p.name), onTap: () => onTap(p))
          ],
        ),
      );
}

class PersonPage extends StatelessWidget {
  final Family family;
  final Person person;
  const PersonPage({required this.family, required this.person, Key? key})
      : super(key: key);
  void _launchDeepLink() async {
    // const deepLink =
    //     'https://deep-linking-web-test.web.app/#/family/f1/person/p1';
    const deepLink = 'deeplink://testing.com/home/shop/details/0';
    // const deepLink = 'https://google.com';

    // if (await canLaunchUrl(Uri.parse(deepLink))) {
    //   try {
    await launchUrl(Uri.parse(deepLink), mode: LaunchMode.externalApplication);
    //   } catch (e) {
    //     throw e;
    //   }
    // } else {
    //   throw 'Could not launch $deepLink';
    // }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
      appBar: AppBar(title: Text(person.name)),
      body: Column(
        children: [
          Text('${person.name} ${family.name} is ${person.age} years old'),
          ElevatedButton(
            onPressed: _launchDeepLink,
            child: Text('Open Deep Link'),
          ),
        ],
      ));
}

class Four04Page extends StatelessWidget {
  final String message;
  const Four04Page({required this.message, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(title: const Text('Page Not Found')),
        body: Center(child: Text(message)),
      );
}

bool _initialURILinkHandled = false;

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Uri? _initialURI;
  Uri? _currentURI;
  Object? _err;

  StreamSubscription? _streamSubscription;

  @override
  void initState() {
    super.initState();
    _initURIHandler();
    _incomingLinkHandler();
  }

  Future<void> _initURIHandler() async {
    if (!_initialURILinkHandled) {
      _initialURILinkHandled = true;
      await Fluttertoast.showToast(
          msg: "Invoked _initURIHandler",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.green,
          textColor: Colors.white);
      try {
        final initialURI = await getInitialUri();
        // Use the initialURI and warn the user if it is not correct,
        // but keep in mind it could be `null`.
        if (initialURI != null) {
          debugPrint("Initial URI received $initialURI");
          if (!mounted) {
            return;
          }
          setState(() {
            _initialURI = initialURI;
          });
        } else {
          debugPrint("Null Initial URI received");
        }
      } on PlatformException {
        // Platform messages may fail, so we use a try/catch PlatformException.
        // Handle exception by warning the user their action did not succeed
        debugPrint("Failed to receive initial uri");
      } on FormatException catch (err) {
        if (!mounted) {
          return;
        }
        debugPrint('Malformed Initial URI received');
        setState(() => _err = err);
      }
    }
  }

  /// Handle incoming links - the ones that the app will receive from the OS
  /// while already started.
  void _incomingLinkHandler() {
    if (!kIsWeb) {
      // It will handle app links while the app is already started - be it in
      // the foreground or in the background.
      _streamSubscription = uriLinkStream.listen((Uri? uri) {
        if (!mounted) {
          return;
        }
        debugPrint('Received URI: $uri');
        setState(() {
          _currentURI = uri;
          _err = null;
        });
      }, onError: (Object err) {
        if (!mounted) {
          return;
        }
        debugPrint('Error occurred: $err');
        setState(() {
          _currentURI = null;
          if (err is FormatException) {
            _err = err;
          } else {
            _err = null;
          }
        });
      });
    }
  }

  @override
  void dispose() {
    _streamSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
          child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ListTile(
              title: const Text("Initial Link"),
              subtitle: Text(_initialURI.toString()),
            ),
            if (!kIsWeb) ...[
              ListTile(
                title: const Text("Current Link Host"),
                subtitle: Text('${_currentURI?.host}'),
              ),
              ListTile(
                title: const Text("Current Link Scheme"),
                subtitle: Text('${_currentURI?.scheme}'),
              ),
              ListTile(
                title: const Text("Current Link"),
                subtitle: Text(_currentURI.toString()),
              ),
              ListTile(
                title: const Text("Current Link Path"),
                subtitle: Text('${_currentURI?.path}'),
              )
            ],
            if (_err != null)
              ListTile(
                title: const Text('Error', style: TextStyle(color: Colors.red)),
                subtitle: Text(_err.toString()),
              ),
            const SizedBox(
              height: 20,
            ),
            const Text("Check the blog for testing instructions")
          ],
        ),
      )));
}
