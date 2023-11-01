import 'package:bbblient/src/controller/all_providers/all_providers.dart';
import 'package:bbblient/src/controller/quiz/quiz_provider.dart';
import 'package:bbblient/src/models/enums/gender.dart';
import 'package:bbblient/src/theme/app_main_theme.dart';
import 'package:bbblient/src/utils/time.dart';
import 'package:bbblient/src/views/profile/personal_info.dart';
import 'package:bbblient/src/views/widgets/widgets.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ProfileDetalis extends ConsumerWidget {
  const ProfileDetalis({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context, ref) {
    final _quizProvider = ref.watch(quizProvider);
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 30.0, bottom: 8),
          child: Text(
            AppLocalizations.of(context)?.tellUsAboutYourself ??
                "Tell us about yourself",
            style: Theme.of(context).textTheme.headline4,
            textAlign: TextAlign.center,
          ),
        ),
        Form(
            child: Padding(
          padding: EdgeInsets.all(18.0.sp),
          child: Column(
            children: [
              // todo focus here if name is empty
              TextFormField(
                controller: _quizProvider.firstNameController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  labelText:
                      AppLocalizations.of(context)?.firstName ?? 'First Name',
                ),
              ),
              SizedBox(
                height: 16.h,
              ),
              TextFormField(
                controller: _quizProvider.lastNameController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  labelText:
                      AppLocalizations.of(context)?.lastName ?? 'Last Name',
                ),
              ),
              SizedBox(
                height: 16.h,
              ),
              TextFormField(
                controller: _quizProvider.emailController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  labelText: AppLocalizations.of(context)?.email ?? 'Email',
                ),
                keyboardType: TextInputType.emailAddress,
              ),
              SizedBox(
                height: 16.h,
              ),
              // TextFormField(
              //   controller: _quizProvider.bioController,
              //   decoration: InputDecoration(
              //     border: OutlineInputBorder(
              //       borderRadius: BorderRadius.circular(12),
              //     ),
              //     labelText: 'Bio',
              //   ),
              //   maxLines: 3,
              // ),
              // SizedBox(
              //   height: 16.h,
              // ),
              // const SelectGender(),
              SizedBox(
                height: 16.h,
              ),
              Align(
                alignment: Alignment.topLeft,
                child: Text(
                  AppLocalizations.of(context)?.dateOfBirth ?? "Date of birth",
                  style: Theme.of(context).textTheme.headline4,
                  textAlign: TextAlign.center,
                ),
              ),
              SizedBox(
                height: 8.h,
              ),
              SelectDOB(
                date: _quizProvider.dob,
                onChange: (val) {
                  _quizProvider.setDob(val);
                },
              )
            ],
          ),
        ))
      ],
    );
  }
}

class SelectGender extends ConsumerWidget {
  const SelectGender({Key? key}) : super(key: key);
  Widget _genderTile(String gender, String label, QuizProvider quizProvider) =>
      Container(
        height: 52,
        width: 0.35.sw,
        decoration: BoxDecoration(
            color: Colors.white, borderRadius: BorderRadius.circular(12)),
        child: Row(
          children: [
            Radio(
              value: gender,
              activeColor: AppTheme.creamBrownLight,
              groupValue: quizProvider.usersSex,
              onChanged: (val) {
                quizProvider.setUsersGender(val.toString());
              },
            ),
            Text(
              label,
              style: AppTheme.bodyText1,
            ),
            const SpaceHorizontal()
          ],
        ),
      );
  @override
  Widget build(BuildContext context, ref) {
    final _quizProvider = ref.watch(quizProvider);
    return Wrap(
      spacing: 12,
      runSpacing: 12,
      alignment: WrapAlignment.center,
      children: [
        _genderTile(
          Sex.male,
          AppLocalizations.of(context)?.men ?? "Male",
          _quizProvider,
        ),
        _genderTile(
          Sex.female,
          AppLocalizations.of(context)?.women ?? "Female",
          _quizProvider,
        ),
        _genderTile(
          Sex.other,
          AppLocalizations.of(context)?.iDontCare ?? "Other",
          _quizProvider,
        )
      ],
    );
  }
}

class SelectDOB extends StatelessWidget {
  final DateTime? date;
  final Function? onChange;
  SelectDOB({Key? key, this.date, this.onChange}) : super(key: key);

  final DateTime startDate = DateTime(1900, 1, 1);
  final DateTime endDate = DateTime.now();
  final DateTime initialDate = DateTime(1994, 1, 1);

  onTap(context) {
    DateTime _tempDate = date ?? initialDate;
    showModalBottomSheet(
        context: context,
        isDismissible: true,
        builder: (BuildContext builder) {
          return Container(
              color: AppTheme.milkeyGrey,
              constraints: const BoxConstraints(minHeight: 300),
              height: MediaQuery.of(context).copyWith().size.height / 3,
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(
                      left: AppTheme.margin,
                      right: AppTheme.margin,
                      top: AppTheme.margin,
                    ),
                    child: Row(
                      children: [
                        Expanded(
                            flex: 1,
                            child: Container(
                              alignment: Alignment.centerLeft,
                              child: GestureDetector(
                                onTap: () => Navigator.of(context).pop(),
                                child: Text(
                                  AppLocalizations.of(context)?.cancel ??
                                      'Cancel',
                                  style: Theme.of(context)
                                      .textTheme
                                      .subtitle1!
                                      .copyWith(color: AppTheme.lightGrey),
                                ),
                              ),
                            )),
                        Expanded(
                            flex: 1,
                            child: Container(
                                alignment: Alignment.center,
                                child: Text(
                                  AppLocalizations.of(context)?.pickAdate ??
                                      'Pick a date',
                                  style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w500,
                                      color: AppTheme.textBlack),
                                ))),
                        Expanded(
                            flex: 1,
                            child: Container(
                                alignment: Alignment.centerRight,
                                child: GestureDetector(
                                  onTap: () {
                                    onChange!(_tempDate);
                                    Navigator.of(context).pop();
                                  },
                                  child: Text(
                                    AppLocalizations.of(context)?.select ??
                                        'Select',
                                    style: Theme.of(context)
                                        .textTheme
                                        .subtitle1!
                                        .copyWith(
                                            color: CupertinoColors.activeBlue),
                                  ),
                                ))),
                      ],
                    ),
                  ),
                  Expanded(
                    child: CupertinoDatePicker(
                      backgroundColor: AppTheme.milkeyGrey,
                      onDateTimeChanged: (DateTime newDate) =>
                          _tempDate = newDate,
                      initialDateTime: _tempDate,
                      minimumDate: startDate,
                      maximumDate: endDate,
                      mode: CupertinoDatePickerMode.date,
                    ),
                  ),
                ],
              ));
        });
  }

  @override
  Widget build(BuildContext context) {
    final bool _dateIsEmpty = date != null;
    final String _date = _dateIsEmpty
        ? Time().getLocaleDate(
            date,
            AppLocalizations.of(context)?.localeName ?? 'en',
          )
        : AppLocalizations.of(context)?.pickAdate ?? "Select a date";

    return InkWell(
      customBorder:
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      onTap: () => onTap(context),
      child: Ink(
        width: double.infinity,
        height: height,
        decoration: BoxDecoration(
            color: AppTheme.white, borderRadius: BorderRadius.circular(12)),
        child: Align(
            alignment: Alignment.centerLeft,
            child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: AppTheme.margin),
                child: Text(
                  _date,
                  style: _dateIsEmpty
                      ? Theme.of(context).textTheme.bodyText1
                      : Theme.of(context)
                          .textTheme
                          .bodyText2!
                          .copyWith(fontSize: 16),
                ))),
      ),
    );
  }
}
