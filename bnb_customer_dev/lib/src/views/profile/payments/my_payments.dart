import 'package:flutter/material.dart';
import '../settings/widgets/settings_list_tile.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../../../theme/app_main_theme.dart';

class MyPayments extends StatefulWidget {
  const MyPayments({Key? key}) : super(key: key);

  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<MyPayments> {
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
          AppLocalizations.of(context)?.myPayments ?? "My Payments",
          style: Theme.of(context).textTheme.bodyText1,
        ),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          IgnorePointer(
            ignoring: true,
            child: Opacity(
              opacity: 0.3,
              child: Column(
                children: [
                  SettingsTile(
                    title: AppLocalizations.of(context)?.myCards ?? "My Cards",
                    iconUrl: "assets/icons/credit_card.svg",
                    onTapped: () {
                      // Navigator.push(
                      //   context,
                      //   MaterialPageRoute(
                      //     builder: (context) => const MyCards(),
                      //   ),
                      // );
                    },
                    size: size,
                  ),
                  SettingsTile(
                      title: AppLocalizations.of(context)?.historyOfPayments ?? "History of Payments",
                      iconUrl: "assets/icons/payment_history.svg",
                      onTapped: () {},
                      size: size),
                ],
              ),
            ),
          ),
          Center(
            child: SizedBox(
              child: Text(AppLocalizations.of(context)?.comingSoon ?? "coming soon",
                  style: Theme.of(context).textTheme.bodyText1!.copyWith(fontSize: 22, color: AppTheme.redishPink)),
            ),
          ),
        ],
      ),
    );
  }
}
