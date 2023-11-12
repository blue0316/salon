// ignore_for_file: avoid_web_libraries_in_flutter, unused_import, unused_local_variable, file_names

// import 'package:bbblient/src/firebase/collections.dart';
import 'dart:convert';

import 'package:bbblient/src/controller/all_providers/all_providers.dart';
import 'package:bbblient/src/controller/app_provider.dart';
import 'package:bbblient/src/firebase/collections.dart';
import 'package:bbblient/src/mongodb/db_service.dart';
import 'package:bbblient/src/routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'mongodb/collection.dart';
import 'views/salon/salon_home/salon_profile.dart';
import 'package:bbblient/src/models/salon_master/master.dart';
import 'dart:html' as html;
import 'package:bbblient/src/controller/bnb/bnb_provider.dart';
import 'package:bbblient/src/views/salon/salon_home/salon_profile_copy.dart';
import 'package:flutter_mongodb_realm/flutter_mongo_realm.dart';

class LoadingLink extends ConsumerStatefulWidget {
  final String myPath;
  const LoadingLink({Key? key, required this.myPath}) : super(key: key);

  @override
  ConsumerState<LoadingLink> createState() => _LoadingLinkState();
}

class _LoadingLinkState extends ConsumerState<LoadingLink> {
  bool loading = true;
  bool error = false;
  String? id;
  String? locale;
  bool back = true;
  @override
  void initState() {
    super.initState();

    fetchCustomLink();
  }

  fetchCustomLink() async {
    stylePrint('FETCHING CUSTOM LINK');
    final db = ref.read(dbProvider);

    try {
      var data = await db.db!.getCollection(CollectionMongo.customLinks).find(
        filter: {"name": widget.myPath.toLowerCase()},
      );

      if (data.isNotEmpty) {
        final mydata = json.decode(data[0].toJson()) as Map<String, dynamic>;

        final uri = Uri.parse(mydata["link"]);
        id = uri.queryParameters["id"]!;

        locale = uri.queryParameters['locale'] ?? "en";
        final String id2 = uri.queryParameters['id2'] ?? "";

        MasterModel? salonMaster;
        if (uri.queryParameters['back'] != null) {
          back = !(uri.queryParameters['back'] == 'false');
        }

        final bnbProvider = ChangeNotifierProvider<BnbProvider>((ref) => BnbProvider());

        final provider = Provider((ref) async {
          final repository = ref.watch(bnbProvider);
          repository.changeLocale(locale: Locale(uri.queryParameters['locale']!.toString()));

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
      }
    } catch (err) {
      setState(() {
        loading = false;
        error = true;
      });
    }
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
            :
            // Container(
            //     color: Colors.brown,
            //     width: double.infinity,
            //     height: double.infinity,
            //   );
            SalonPage(
                salonId: id!,
                showBackButton: back,
                locale: locale!,
              );
  }
}
