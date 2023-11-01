import 'package:bbblient/src/controller/all_providers/all_providers.dart';
import 'package:bbblient/src/firebase/chat_utils.dart';
import 'package:bbblient/src/models/chat_models/chat_model.dart';
import 'package:bbblient/src/theme/app_main_theme.dart';
import 'package:bbblient/src/utils/icons.dart';
import 'package:bbblient/src/utils/utils.dart';
import 'package:bbblient/src/views/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jiffy/jiffy.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'chat_screen.dart';

class ChatList extends ConsumerStatefulWidget {
  const ChatList({Key? key}) : super(key: key);

  @override
  _ChatListState createState() => _ChatListState();
}

class _ChatListState extends ConsumerState<ChatList> {
  @override
  Widget build(BuildContext context) {
    final _authProvider = ref.watch(authProvider);
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        title: Text(
          AppLocalizations.of(context)?.chat ?? "Chat",
          style: Theme.of(context).textTheme.bodyText1,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: _authProvider.currentCustomer == null
            ? Center(
                child: Text(
                  AppLocalizations.of(context)?.nochats ?? "No User!!",
                  textAlign: TextAlign.center,
                ),
              )
            : StreamBuilder(
                //todo
                stream: ChatApi().getAllChatsStream(
                    _authProvider.currentCustomer!.customerId),
                builder: (BuildContext context,
                    AsyncSnapshot<List<ChatModel>> snapshot) {
                  if (snapshot.connectionState == ConnectionState.active) {
                    // printIt(snapshot.data?.first.toJson());
                    if (snapshot.data != null && snapshot.data!.isNotEmpty) {
                      snapshot.data!.sort((a, b) {
                        return b.createdAt!.compareTo(a.createdAt!);
                      });
                      return ListView.builder(
                          itemCount: snapshot.data!.length,
                          shrinkWrap: true,
                          itemBuilder: (context, index) {
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 10),
                              child: GestureDetector(
                                onTap: () {
                                  printIt(snapshot.data![index].salonAvtar);
                                  printIt(
                                      snapshot.data![index].salonAvtar == "");
                                  printIt(snapshot.data![index].customerAvtar ==
                                      null);
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => Chat(
                                                appointmentId: "",
                                                peerAvatar: snapshot
                                                        .data?[index]
                                                        .salonAvtar ??
                                                    '',
                                                peerId: snapshot
                                                        .data?[index].salonId ??
                                                    '',
                                                peerName: snapshot.data?[index]
                                                        .salonName ??
                                                    '',
                                              )));
                                },
                                child: Card(
                                  color: Colors.white,
                                  elevation: 5,
                                  shadowColor: AppTheme.coolGrey,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12)),
                                  borderOnForeground: true,
                                  child: SizedBox(
                                    height: 88,
                                    width: double.infinity,
                                    child: Padding(
                                      padding: const EdgeInsets.all(12.0),
                                      child: Row(
                                        children: [
                                          CircleAvatar(
                                              radius: 30,
                                              backgroundColor: Colors.white,
                                              backgroundImage: ((snapshot
                                                              .data![index]
                                                              .salonAvtar ==
                                                          "" ||
                                                      snapshot.data![index]
                                                              .customerAvtar ==
                                                          null)
                                                  ? NetworkImage(snapshot
                                                      .data![index]
                                                      .customerAvtar!)
                                                  : const AssetImage(
                                                      AppIcons
                                                          .defaultUserAvtarPNG,
                                                    )) as ImageProvider<
                                                  Object>?),
                                          const SpaceHorizontal(
                                            factor: 1,
                                          ),
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceEvenly,
                                              children: [
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Text(
                                                      snapshot.data![index]
                                                          .salonName!,
                                                      style: Theme.of(context)
                                                          .textTheme
                                                          .bodyText1,
                                                      maxLines: 1,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                    ),
                                                    Text(
                                                      Jiffy(snapshot
                                                              .data![index]
                                                              .messages
                                                              .last['createdAt']
                                                              .toDate())
                                                          .yMd,
                                                      // DateFormat.yMd()
                                                      //     .format(),
                                                      style: Theme.of(context)
                                                          .textTheme
                                                          .bodyText2,
                                                    ),
                                                  ],
                                                ),
                                                Text(
                                                  snapshot.data![index].messages
                                                          .isNotEmpty
                                                      ? snapshot
                                                                      .data![index]
                                                                      .messages
                                                                      .last[
                                                                  'type'] ==
                                                              0
                                                          ? snapshot
                                                              .data![index]
                                                              .messages
                                                              .last['content']
                                                          : AppLocalizations.of(
                                                                      context)
                                                                  ?.sentAnImage ??
                                                              "sent an image"
                                                      : "",
                                                  maxLines: 2,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .bodyText2,
                                                ),
                                              ],
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            );
                          });
                    } else {
                      return Center(
                        child: Text(
                          AppLocalizations.of(context)?.nochats ?? "No chats!!",
                          textAlign: TextAlign.center,
                        ),
                      );
                    }
                  } else {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                },
              ),
      ),
    );
  }
}
