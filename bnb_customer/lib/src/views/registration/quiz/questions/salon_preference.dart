import 'package:flutter/material.dart';
import '../../../../theme/app_main_theme.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class SalonPreference extends StatelessWidget {
  const SalonPreference({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 60.0, bottom: 44),
          child: Text(
            AppLocalizations.of(context)?.whichStatementIsTruerForYou ?? "Which statement is truer for you ?",
            style: Theme.of(context).textTheme.headline4,
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(12.0),
          child: Container(
            decoration: BoxDecoration(border: Border.all(color: AppTheme.creamBrown, width: 2.5), borderRadius: BorderRadius.circular(16)),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  const SizedBox(
                    width: 6,
                  ),
                  SizedBox(
                      width: 40,
                      height: 40,
                      child: Card(
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                          elevation: 3,
                          child: Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: Image.asset('assets/images/top_saloons.png'),
                          ))),
                  const SizedBox(
                    width: 10,
                  ),
                  SizedBox(
                    width: size.width - 120,
                    child: Text(
                      AppLocalizations.of(context)?.ipreferTopServices ?? "I prefer services from top\nsaloons and top masters only",
                      style: Theme.of(context).textTheme.displaySmall,
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(12.0),
          child: Container(
            decoration: BoxDecoration(border: Border.all(color: AppTheme.creamBrownLight, width: 1.5), borderRadius: BorderRadius.circular(16)),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  const SizedBox(
                    width: 6,
                  ),
                  SizedBox(
                      width: 40,
                      height: 40,
                      child: Card(
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                          elevation: 3,
                          child: Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: Image.asset('assets/images/trainee.png'),
                          ))),
                  const SizedBox(
                    width: 10,
                  ),
                  SizedBox(
                    width: size.width - 120,
                    child: Text(
                      AppLocalizations.of(context)?.iPreferTraineeServicews ?? "I will gladly receive a service\nfrom a trainee too",
                      style: Theme.of(context).textTheme.displaySmall,
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(12.0),
          child: Container(
            decoration: BoxDecoration(border: Border.all(color: AppTheme.creamBrownLight, width: 1.5), borderRadius: BorderRadius.circular(16)),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  const SizedBox(
                    width: 6,
                  ),
                  SizedBox(
                    width: 40,
                    height: 40,
                    child: Card(
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                      elevation: 3,
                      child: Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: Image.asset('assets/images/Union.png'),
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  SizedBox(
                    width: size.width - 120,
                    child: Text(
                      AppLocalizations.of(context)?.idontCareGiveMeGoodService ?? "I don't care about master's salon_home lavel if they provide good service",
                      style: Theme.of(context).textTheme.displaySmall,
                    ),
                  )
                ],
              ),
            ),
          ),
        )
      ],
    );
  }
}
