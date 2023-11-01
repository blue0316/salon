// import 'package:bbblient/src/controller/all_providers/all_providers.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import '../../../../utils/icons.dart';
// import 'permission.dart';
// import 'package:flutter_gen/gen_l10n/app_localizations.dart';

// class LinkCard extends ConsumerWidget {
//   const LinkCard({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context, ref) {
//     final _quizProvider = ref.watch(quizProvider);
//     return PermissionDialoug(
//       title: AppLocalizations.of(context)?.linkYourCard ?? "Link your card",
//       body: AppLocalizations.of(context)?.addYourCardAndGetBonus ?? "Add your card to pay online and get bonuses",
//       buttonText: AppLocalizations.of(context)?.link ?? "Link",
//       onApprove: _quizProvider.onNext,
//       skipText: AppLocalizations.of(context)?.notNow ?? 'not now',
//       onSkip: () {
//         Navigator.pop(context);
//       },
//       svg: AppIcons.linkCard,
//     );
//   }
// }
