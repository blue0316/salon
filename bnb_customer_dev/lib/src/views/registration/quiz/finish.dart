import 'package:bbblient/src/controller/all_providers/all_providers.dart';
import 'package:bbblient/src/models/enums/status.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../theme/app_main_theme.dart';
import '../../../utils/icons.dart';
import '../../widgets/widgets.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class Finish extends ConsumerWidget {
  final String svg = AppIcons.quizDone;

  const Finish({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, ref) {
    final _quizProvider = ref.watch(quizProvider);
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Space(
            factor: 2,
          ),
          SizedBox(height: 270.h, width: 290.w, child: Image.asset(AppIcons.quizFinish)),
          const Space(
            factor: 2,
          ),
          Padding(
            padding: const EdgeInsets.only(top: 24.0),
            child: Text(
              AppLocalizations.of(context)?.done ?? "Done !",
              style: Theme.of(context).textTheme.displaySmall,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 72.0, vertical: 24),
            child: Text(
              AppLocalizations.of(context)?.makeAppointmentDontForgetBonus ?? "Now you can make your first bnb appointment. Enjoy it and don't forget to use your bonuses!",
              style: Theme.of(context).textTheme.headline4!.copyWith(fontSize: 14),
              textAlign: TextAlign.center,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 24.0),
            child: MaterialButton(
              onPressed: () async {
                if (_quizProvider.saveInfoStatus != Status.loading) {
                  await _quizProvider.saveUserDetails(context: context, ref: ref);
                } else {
                  showToast(AppLocalizations.of(context)?.pleaseWait ?? "Please wait");
                }
              },
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              color: AppTheme.creamBrown,
              minWidth: 240,
              height: 60,
              child: (_quizProvider.saveInfoStatus != Status.loading)
                  ? Text(
                      AppLocalizations.of(context)?.continue_word ?? "Continue",
                      style: Theme.of(context).textTheme.headline2,
                    )
                  : const SizedBox(
                      height: 20,
                      width: 20,
                      child: Center(
                        child: CircularProgressIndicator(strokeWidth: 2, valueColor: AlwaysStoppedAnimation<Color>(Colors.white)),
                      ),
                    ),
            ),
          ),
        ],
      ),
    );
  }
}
