import 'package:bbblient/src/utils/icons.dart';
import 'package:bbblient/src/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:bbblient/src/views/profile/settings/widgets/settings_list_tile.dart';

class SupportOptions extends StatefulWidget {
  const SupportOptions({Key? key}) : super(key: key);

  @override
  _SupportOptionsState createState() => _SupportOptionsState();
}

class _SupportOptionsState extends State<SupportOptions> {
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
          AppLocalizations.of(context)?.supportChat ?? "Support Chat",
          style: Theme.of(context).textTheme.bodyText1,
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
      ),
      body: Column(
        children: [
          SettingsTile(
            title: "Telegram",
            iconUrl: AppIcons.telegramSVG,
            onTapped: () {
              Utils().launchUrl(url: "https://t.me/bowandbeautiful_bot");
            },
            size: size,
          ),
        ],
      ),
    );
  }
}
