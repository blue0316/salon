import 'package:flutter/material.dart';
import '../../../theme/app_main_theme.dart';
import 'language_preferences.dart';
import 'my_preferences.dart';
import 'widgets/settings_list_tile.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class Settings extends StatefulWidget {
  const Settings({Key? key}) : super(key: key);

  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  String appName = "";
  String packageName = "";
  String version = "";
  String buildNumber = "";

  void getAppInfo() {
    // PackageInfo.fromPlatform().then((PackageInfo packageInfo) {
    //   setState(() {
    //     appName = packageInfo.appName;
    //     packageName = packageInfo.packageName;
    //     version = packageInfo.version;
    //     buildNumber = packageInfo.buildNumber;
    //   });
    // });
  }

  @override
  void initState() {
    super.initState();
    getAppInfo();
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back),
        ),
        title: Text(
          AppLocalizations.of(context)?.settings ?? "Settings",
          style: const TextStyle(fontFamily: "Montserrat", fontSize: 16, fontWeight: FontWeight.w500, color: AppTheme.textBlack),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
      ),
      body: Column(
        children: [
          SettingsTile(
              title: AppLocalizations.of(context)?.language ?? "Language",
              iconUrl: "assets/icons/lang_translt.svg",
              onTapped: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const LanguagePreferences(),
                  ),
                );
              },
              size: size),
          // SettingsTile(
          //     title: AppLocalizations.of(context)?.notifications ?? "Notifications",
          //     iconUrl: "assets/icons/bell_active.svg",
          //     onTapped: () {
          //       Navigator.push(
          //         context,
          //         MaterialPageRoute(
          //           builder: (context) => const NotificationSettings(),
          //         ),
          //       );
          //     },
          //     size: size),
          // SettingsTile(
          //     title: AppLocalizations.of(context)?.privacyAndSecurity ?? "Privacy and Security",
          //     iconUrl: "assets/icons/security_filled.svg",
          //     onTapped: () {},
          //     size: size),
          // SettingsTile(title: "Password", iconUrl: "assets/icons/password_filled.svg", onTapped: () {}, size: size),
          SettingsTile(
              title: AppLocalizations.of(context)?.myPreferences ?? "My Preferences",
              iconUrl: "assets/icons/services_Filled.svg",
              onTapped: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const MyPreferences(),
                  ),
                );
              },
              size: size),
          // SettingsTile(title: "Help", iconUrl: "assets/icons/help.svg", onTapped: () {}, size: size),
          // SettingsTile(title: "About", iconUrl: "assets/icons/Info.svg", onTapped: () {}, size: size),
          Padding(
            padding: const EdgeInsets.only(top: 40.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [Text("$version+$buildNumber")],
            ),
          )
        ],
      ),
    );
  }
}
