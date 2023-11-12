import 'dart:io';
import 'package:bbblient/src/controller/all_providers/all_providers.dart';
import 'package:bbblient/src/controller/authentication/auth_provider.dart';
import 'package:bbblient/src/controller/image/image_utils.dart';
import 'package:bbblient/src/controller/user/user_provider.dart';
import 'package:bbblient/src/utils/icons.dart';
import 'package:bbblient/src/views/widgets/buttons.dart';
import 'package:bbblient/src/views/widgets/profile_pic.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../models/enums/gender.dart';
import '../../theme/app_main_theme.dart';
import '../../utils/time.dart';
import '../widgets/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

const double height = 52;

class PersonalInformation extends ConsumerStatefulWidget {
  const PersonalInformation({Key? key}) : super(key: key);

  @override
  _PersonalInformationState createState() => _PersonalInformationState();
}

class _PersonalInformationState extends ConsumerState<PersonalInformation> {
  final TextEditingController _dobController = TextEditingController();
  late AuthProviderController _authProvider;
  late UserProfileProvider _userProfileProvider;
  File? pickedImage;

  @override
  void initState() {
    super.initState();
    setUpUserProfile();
  }

  setUpUserProfile() {
    _authProvider = ref.read(authProvider);
    _userProfileProvider = ref.read(userProfileProvider);
    Future.delayed(const Duration(milliseconds: 100), () {
      _userProfileProvider.setCustomerModer(_authProvider.currentCustomer!);
    });
  }

  @override
  void dispose() {
    _dobController.dispose();
    super.dispose();
  }

  Widget _header(String text) => Padding(
        padding: const EdgeInsets.only(bottom: 4),
        child: Text(
          text,
          style: Theme.of(context).textTheme.bodyMedium,
        ),
      );

  final double _margin = AppTheme.margin;

  final InputDecoration textFieldDecoration = InputDecoration(
    filled: true,
    fillColor: Colors.white,
    contentPadding: const EdgeInsets.symmetric(horizontal: AppTheme.margin, vertical: AppTheme.margin),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide.none,
    ),
    hintStyle: const TextStyle(fontFamily: "Montserrat", fontSize: 14, fontWeight: FontWeight.w400, color: AppTheme.textBlack),
    labelStyle: const TextStyle(fontFamily: "Montserrat", fontSize: 14, fontWeight: FontWeight.w400, color: AppTheme.textBlack),
  );

  @override
  Widget build(BuildContext context) {
    final _userProfileProvider = ref.watch(userProfileProvider);
    final _authProvider = ref.watch(authProvider);
    return WillPopScope(
      onWillPop: () async {
        if (_userProfileProvider.detailsChanged) {
          bool? ret = await showSaveDialogue(userProfileProvider: _userProfileProvider, authProvider: _authProvider);
          return ret ?? true;
        } else {
          return true;
        }
      },
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.transparent,
          leading: IconButton(
            onPressed: () => Navigator.of(context).maybePop(),
            icon: const Icon(
              Icons.arrow_back,
              color: AppTheme.textBlack,
            ),
          ),
          title: Text(
            AppLocalizations.of(context)?.personalInformation ?? "Personal Information",
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          centerTitle: true,
          actions: [
            _userProfileProvider.detailsChanged
                ? TextButton(
                    onPressed: () async {
                      await _userProfileProvider.saveInfo(context: context);
                      await _authProvider.getUserInfo(context: context);
                    },
                    child: Text(AppLocalizations.of(context)?.doneOnly ?? 'done'),
                  )
                : const SizedBox(),
          ],
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 40, bottom: 16),
                child: GestureDetector(
                  onTap: () {
                    showDialog(
                        context: context,
                        builder: (context) => Dialog(
                              child: SizedBox(
                                height: 200.h,
                                width: 200.w,
                                child: Padding(
                                  padding: const EdgeInsets.all(24.0),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.all(16.0),
                                        child: Text(
                                          AppLocalizations.of(context)?.pickImageFrom ?? 'Pick image from',
                                          style: AppTheme.headLine3,
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          BnbMaterialButton(
                                            onTap: () async {
                                              Navigator.pop(context);
                                              File? pickedFile = await ImageUtilities().getImage(gallery: false);
                                              if (pickedFile != null) {
                                                setState(() {
                                                  pickedImage = pickedFile;
                                                  _userProfileProvider.onImagePick(pickedFile);
                                                });
                                              } else {
                                                showToast(AppLocalizations.of(context)?.cancel ?? 'cant get image');
                                              }
                                            },
                                            minWidth: 50,
                                            title: AppLocalizations.of(context)?.camera ?? "Camera",
                                          ),
                                          BnbMaterialButton(
                                            onTap: () async {
                                              Navigator.pop(context);
                                              File? pickedFile = await ImageUtilities().getImage(gallery: true);
                                              if (pickedFile != null) {
                                                setState(() {
                                                  pickedImage = pickedFile;
                                                  _userProfileProvider.onImagePick(pickedFile);
                                                });
                                              } else {
                                                showToast(AppLocalizations.of(context)?.cancel ?? 'cant get image');
                                              }
                                            },
                                            minWidth: 50,
                                            title: AppLocalizations.of(context)?.gallery ?? "gallery",
                                          ),
                                        ],
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ));
                  },
                  child: SizedBox(
                    height: 100,
                    width: 100,
                    child: Stack(
                      clipBehavior: Clip.none,
                      children: [
                        if (pickedImage != null) ...[
                          CircleAvatar(
                            radius: (100 / 2) + 2,
                            backgroundColor: AppTheme.white,
                            child: ClipRRect(borderRadius: BorderRadius.circular(1000), child: SizedBox(height: 100, width: 100, child: Image.file(pickedImage!))),
                          )
                        ],
                        if (pickedImage == null) ...[
                          ProfilePic(
                            pic: _userProfileProvider.profilePic ?? '',
                            backgroundColor: AppTheme.white,
                          ),
                        ],
                        const Positioned(
                          right: -2,
                          top: -2,
                          child: CircleAvatar(
                            backgroundColor: Colors.white,
                            radius: 16,
                            child: CircleAvatar(
                              backgroundColor: AppTheme.textBlack,
                              radius: 14,
                              child: Padding(
                                padding: EdgeInsets.all(4.0),
                                child: Icon(
                                  Icons.camera_alt,
                                  size: 18,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
              Form(
                  child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _header(AppLocalizations.of(context)?.firstName ?? 'First name'),
                    SizedBox(
                      height: height,
                      child: TextFormField(
                          controller: _userProfileProvider.firstNameController,
                          decoration: textFieldDecoration,
                          onChanged: (val) {
                            _userProfileProvider.checkForChange();
                          }),
                    ),
                    SizedBox(
                      height: _margin,
                    ),
                    _header(AppLocalizations.of(context)?.lastName ?? 'Last name'),
                    TextFormField(
                        controller: _userProfileProvider.lastNameController,
                        decoration: textFieldDecoration,
                        onChanged: (val) {
                          _userProfileProvider.checkForChange();
                        }),
                    SizedBox(
                      height: _margin,
                    ),
                    SizedBox(
                      height: _margin,
                    ),
                    // _header(AppLocalizations.of(context)?.gender ?? 'Gender'),
                    // const SelectGender(),
                    // SizedBox(
                    //   height: _margin,
                    // ),
                    _header(AppLocalizations.of(context)?.dateOfBirth ?? 'Date of birth'),
                    SelectDOB(
                      date: _userProfileProvider.dob ?? DateTime(1994),
                      onChange: (val) => _userProfileProvider.onDOBChange(val),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                  ],
                ),
              ))
            ],
          ),
        ),
      ),
    );
  }

  Future<bool?> showSaveDialogue({required UserProfileProvider userProfileProvider, required AuthProviderController authProvider}) {
    return showDialog(
        context: context,
        builder: (context) {
          return Dialog(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: Container(
              width: 340,
              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 20.0, right: 20),
                        child: GestureDetector(
                          onTap: () => Navigator.of(context).pop(false),
                          child: SizedBox(
                            height: 10,
                            width: 10,
                            child: SvgPicture.asset(AppIcons.cancelGreySVG),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 40.0),
                    child: Text(
                      AppLocalizations.of(context)?.saveChanges ?? "Save Changes ?",
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.displaySmall,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        MaterialButton(
                          onPressed: () {
                            Navigator.of(context).pop(true);
                          },
                          color: Colors.white,
                          height: 52.h,
                          minWidth: 140.w,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                          elevation: 0,
                          child: Text(
                            AppLocalizations.of(context)?.cancel ?? "cancel",
                            style: Theme.of(context).textTheme.displaySmall!.copyWith(color: AppTheme.textBlack),
                          ),
                        ),
                        MaterialButton(
                          onPressed: () async {
                            Navigator.of(context).pop(true);
                            await userProfileProvider.saveInfo(context: context);
                            await authProvider.getUserInfo(context: context);
                          },
                          color: AppTheme.creamBrown,
                          height: 52.h,
                          minWidth: 140.w,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                          child: Text(
                            AppLocalizations.of(context)?.save ?? "save",
                            style: Theme.of(context).textTheme.displaySmall!.copyWith(color: Colors.white),
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          );
        });
  }
}

class SelectDOB extends ConsumerWidget {
  final DateTime date;
  final Function onChange;
  SelectDOB({Key? key, required this.date, required this.onChange}) : super(key: key);

  final DateTime startDate = DateTime(1900, 1, 1);
  final DateTime endDate = DateTime.now();
  final DateTime initialDate = DateTime(2000, 1, 1);

  onTap(context) {
    DateTime _tempDate = date;
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
                                  AppLocalizations.of(context)?.cancel ?? 'Cancel',
                                  style: Theme.of(context).textTheme.titleMedium!.copyWith(color: AppTheme.lightGrey),
                                ),
                              ),
                            )),
                        Expanded(
                            flex: 1,
                            child: Container(
                                alignment: Alignment.center,
                                child: Text(
                                  AppLocalizations.of(context)?.pickAdate ?? 'Pick a date',
                                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500, color: AppTheme.textBlack),
                                ))),
                        Expanded(
                          flex: 1,
                          child: Container(
                            alignment: Alignment.centerRight,
                            child: GestureDetector(
                              onTap: () {
                                onChange(_tempDate);
                                Navigator.of(context).pop();
                              },
                              child: Text(
                                AppLocalizations.of(context)?.select ?? 'Select',
                                style: Theme.of(context).textTheme.titleMedium!.copyWith(color: CupertinoColors.activeBlue),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: CupertinoDatePicker(
                      backgroundColor: AppTheme.milkeyGrey,
                      onDateTimeChanged: (DateTime newDate) => _tempDate = newDate,
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
  Widget build(BuildContext context, ref) {
    final _profile = ref.watch(userProfileProvider);
    final String _date = Time().getLocaleDate(_profile.dob, AppLocalizations.of(context)?.localeName ?? 'en');
    return InkWell(
      customBorder: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      onTap: () => onTap(context),
      child: Ink(
        width: double.infinity,
        height: height,
        decoration: BoxDecoration(color: AppTheme.white, borderRadius: BorderRadius.circular(12)),
        child: Align(
            alignment: Alignment.centerLeft,
            child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: AppTheme.margin),
                child: Text(
                  _date,
                  style: Theme.of(context).textTheme.bodyLarge,
                ))),
      ),
    );
  }
}

class SelectGender extends ConsumerWidget {
  const SelectGender({Key? key}) : super(key: key);

  Widget _genderTile(String gender, String label, UserProfileProvider userProfileProvider) => Container(
        height: 52,
        width: 0.4.sw,
        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)),
        child: Row(
          children: [
            Radio(
              value: gender,
              activeColor: AppTheme.textBlack,
              groupValue: userProfileProvider.sex,
              onChanged: (val) => userProfileProvider.onSexChange(val.toString()),
            ),
            Text(
              label,
              // style: textFieldStyle,
            ),
            const SpaceHorizontal()
          ],
        ),
      );
  @override
  Widget build(BuildContext context, ref) {
    final _userProfileProvider = ref.watch(userProfileProvider);
    return Wrap(
      spacing: 12.sp,
      runSpacing: 12.sp,
      alignment: WrapAlignment.center,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        _genderTile(Sex.male, AppLocalizations.of(context)?.men ?? "Male", _userProfileProvider),
        _genderTile(Sex.female, AppLocalizations.of(context)?.women ?? "Female", _userProfileProvider),
        _genderTile(Sex.other, AppLocalizations.of(context)?.iDontCare ?? "Other", _userProfileProvider),
      ],
    );
  }
}
