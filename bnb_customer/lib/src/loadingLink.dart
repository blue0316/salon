import 'package:bbblient/src/firebase/collections.dart';
import 'package:bbblient/src/routes.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'views/salon/salon_home/salon_profile.dart';
import 'package:bbblient/src/models/salon_master/master.dart';
import 'dart:html' as html;
import 'package:bbblient/src/controller/bnb/bnb_provider.dart';

class LoadingLink extends StatefulWidget {
  final myPath;
  const LoadingLink({Key? key, this.myPath}) : super(key: key);

  @override
  State<LoadingLink> createState() => _LoadingLinkState();
}

class _LoadingLinkState extends State<LoadingLink> {
  bool loading = true;
  bool error = false;
  String? id;
  String? locale;
  bool back = true;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Collection.customLinks
        .where('name', isEqualTo: widget.myPath.toLowerCase())
        .get()
        .then((snapshot) {
      var openlink;
      if (snapshot.docs.isNotEmpty) {
        final mydata = snapshot.docs[0].data()! as Map<String, dynamic>;

        final uri = Uri.parse(mydata["link"]);
        id = uri.queryParameters["id"]!;
        print(id);
        locale = uri.queryParameters['locale'] ?? "en";
        final String id2 = uri.queryParameters['id2'] ?? "";
        // printIt('ideeeeeeeeeeeeeeeeee ' + id2);
        MasterModel? salonMaster;
        if (uri.queryParameters['back'] != null) {
          back = !(uri.queryParameters['back'] == 'false');
        }

        final bnbProvider = ChangeNotifierProvider<BnbProvider>(
          (ref) => BnbProvider(),
        );

        final provider = Provider((ref) async {
          // use ref to obtain other providers
          final repository = ref.watch(bnbProvider);
          repository.changeLocale(
              locale: Locale(uri.queryParameters['locale']!.toString()));

          // if (id2 != "") {
          //   repository.retrieveSalonMasterModel(
          //       state.queryParams['id2']!.toString());
          //   salonMaster = repository.getCurrenMaster;
          //   print(repository.getCurrenMaster);
          // }
          return repository;
        });
        setState(() {
          loading = false;
        });
      } else {
        setState(() {
          loading = false;
          error = true;
        });
        // html.window.open("https://bowandbeautiful.com/error", "_self");
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return loading
        ? const Center(
            child: CircularProgressIndicator(),
          )
        : error
            ? const ErrorScreen(
                error: "Invalid Link",
              )
            : SalonPage(
                salonId: id!,
                showBackButton: back,
                locale: locale!,
              );
  }
}
