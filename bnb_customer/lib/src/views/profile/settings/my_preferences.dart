import 'package:bbblient/src/controller/all_providers/all_providers.dart';
import 'package:bbblient/src/firebase/customer.dart';
import 'package:bbblient/src/models/enums/gender.dart';
import 'package:bbblient/src/models/enums/status.dart';
import 'package:bbblient/src/utils/utils.dart';
import 'package:bbblient/src/views/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class MyPreferences extends ConsumerStatefulWidget {
  const MyPreferences({Key? key}) : super(key: key);

  @override
  _MyPreferencesState createState() => _MyPreferencesState();
}

class _MyPreferencesState extends ConsumerState<MyPreferences> {
  @override
  void initState() {
    super.initState();
    initialisePreferences();
  }

  initialisePreferences() {
    final _bnbProvider = ref.read(bnbProvider);
    _preferredCategories = _bnbProvider.customer!.preferredCategories;
    printIt("Hi");
    printIt(_preferredCategories.toString());
    _preferredGender = _bnbProvider.customer!.preferredGender;
    printIt(_preferredGender);
    setState(() {});
  }

  String _preferredGender = PreferredGender.women;
  List<String> _preferredCategories = [];
   Status status = Status.success;

  @override
  Widget build(BuildContext context) {
    final searchProvider = ref.watch(salonSearchProvider);
    final _bnbProvider = ref.watch(bnbProvider);
   
    return Loader(
      status: status,
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          leading: IconButton(
            onPressed: () async {
              setState(() {
                status = Status.loading;
              });
              showToast(
                 
              AppLocalizations.of(context)?.saving ?? 'Saving...');
              await CustomerApi().updatePreferences(
                  customerId: _bnbProvider.customer!.customerId,
                  preferredGender: _preferredGender,
                  preferredCategories: _preferredCategories);
              var _customerModel = await CustomerApi().getCustomer();
              _bnbProvider.customer = _customerModel;
              // status = Status.success; 

              Navigator.pop(context);
            },
            icon: const Icon(Icons.arrow_back),
          ),
          title: Text(
            AppLocalizations.of(context)?.myPreferences ?? "My Preferences",
            style: Theme.of(context).textTheme.bodyText1,
          ),
          centerTitle: true,
          backgroundColor: Colors.transparent,
        ),
        body: 
        SingleChildScrollView(
          child: Column(
            children: [
              ExpansionTile(
                initiallyExpanded: true,
                title: Text(
                  AppLocalizations.of(context)?.byGender ?? "by Gender",
                  style: const TextStyle(
                    fontFamily: "Montserrat",
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                  // style: Theme.of(context).textTheme.bodyText1.copyWith(fontWeight: FontWeight.w600, color: lightGrey),
                ),
                children: [
                  Column(
                    children: [
                      RadioListTile(
                        value: PreferredGender.men,
                        groupValue: _preferredGender,
                        activeColor: Theme.of(context).primaryColor,
                        //  Theme.of(context).primaryColor,
                        onChanged: (val) {
                          setState(() {
                            _preferredGender = PreferredGender.men;
                          });
                        },
                        title: Text(
                          AppLocalizations.of(context)?.forMan ?? "For Man",
                          style: Theme.of(context)
                              .textTheme
                              .bodyText1!
                              .copyWith(fontWeight: FontWeight.w400),
                        ),
                      ),
                      RadioListTile(
                        value: PreferredGender.women,
                        groupValue: _preferredGender,
                        activeColor: Theme.of(context).primaryColor,
                        onChanged: (val) {
                          setState(() {
                            _preferredGender = PreferredGender.women;
                          });
                        },
                        title: Text(
                          AppLocalizations.of(context)?.forWoman ?? "For Woman",
                          style: Theme.of(context)
                              .textTheme
                              .bodyText1!
                              .copyWith(fontWeight: FontWeight.w400),
                        ),
                      ),
                      RadioListTile(
                        value: PreferredGender.all,
                        groupValue: _preferredGender,
                        activeColor: Theme.of(context).primaryColor,
                        onChanged: (val) {
                          setState(() {
                            _preferredGender = PreferredGender.all;
                          });
                        },
                        title: Text(
                          AppLocalizations.of(context)?.iDontCare ??
                              "I Don't Care",
                          style: Theme.of(context)
                              .textTheme
                              .bodyText1!
                              .copyWith(fontWeight: FontWeight.w400),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              ExpansionTile(
                initiallyExpanded: true,
                title: Text(
                  AppLocalizations.of(context)?.byService ?? "by Service",
                  style: const TextStyle(
                    fontFamily: "Montserrat",
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                  // style: Theme.of(context).textTheme.bodyText1.copyWith(fontWeight: FontWeight.w600, color: lightGrey),
                ),
                children: [
                  ListView.builder(
                    shrinkWrap: true,
                    primary: false,
                    itemCount: searchProvider.categories.length,
                    itemBuilder: (context, index) {
                      return InkWell(
                        onTap: () {
                          if (_preferredCategories.contains(
                              searchProvider.categories[index].categoryId)) {
                            setState(() {
                              _preferredCategories.remove(
                                  searchProvider.categories[index].categoryId);
                            });
                          } else {
                            setState(() {
                              _preferredCategories.add(
                                  searchProvider.categories[index].categoryId);
                            });
                          }
                        },
                        child: Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 12.0, vertical: 4),
                              child: Checkbox(
                                value: _preferredCategories.contains(
                                    searchProvider
                                        .categories[index].categoryId),
                                activeColor: Theme.of(context).primaryColor,
                                onChanged: (val) {
                                  if (val == true) {
                                    setState(() {
                                      _preferredCategories.add(searchProvider
                                          .categories[index].categoryId);
                                    });
                                  } else {
                                    setState(() {
                                      _preferredCategories.remove(searchProvider
                                          .categories[index].categoryId);
                                    });
                                  }
                                },
                              ),
                            ),
                            Text(
                              searchProvider.categories[index].translations[
                                  AppLocalizations.of(context)?.localeName],
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyText1!
                                  .copyWith(fontWeight: FontWeight.w400),
                            ),
                          ],
                        ),
                      );
                    },
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
