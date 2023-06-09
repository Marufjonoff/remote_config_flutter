import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/material.dart';

class RemoteConfigScreen extends StatefulWidget {
  const RemoteConfigScreen({Key? key}) : super(key: key);

  @override
  _RemoteConfigScreenState createState() => _RemoteConfigScreenState();
}

class _RemoteConfigScreenState extends State<RemoteConfigScreen> {
  //Define default values
  final String _defaultAppTitle = "App Title";
  final String _defaultBackgroundColor = "#000";

  final FirebaseRemoteConfig _remoteConfig = FirebaseRemoteConfig.instance;

  // Fetching, caching, and activating remote config
  void _initConfig() async {
    await _remoteConfig.setConfigSettings(RemoteConfigSettings(
      // cache refresh time
      fetchTimeout: const Duration(seconds: 1),
      // a fetch will wait up to 10 seconds before timing out
      minimumFetchInterval: const Duration(seconds: 10),
    ));
    await _remoteConfig.fetchAndActivate();
  }

  @override
  void initState() {
    _initConfig();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
          alignment: Alignment.bottomCenter,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: NetworkImage(
                _remoteConfig.getString('background_image'),
              ),
              fit: BoxFit.cover,
            ),
          ),
          child: Container(
            height: 400,
            width: double.infinity,
            decoration: BoxDecoration(
              color: Color.fromHex(
                  _remoteConfig.getString('background_color').isNotEmpty
                      ? _remoteConfig.getString('background_color')
                      : _defaultBackgroundColor),
            ),
            child: Center(
                child: Text(
                  _remoteConfig.getString('app_title').isNotEmpty
                      ? _remoteConfig.getString('app_title')
                      : _defaultAppTitle,
                  style: const TextStyle(
                      color: Colors.white, fontSize: 30, fontWeight: FontWeight.bold),
                )),
          ),
        ));
  }
}