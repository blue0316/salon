// ignore_for_file: avoid_function_literals_in_foreach_calls, unused_field

import 'dart:async';
import 'dart:io';
import 'package:bbblient/src/controller/all_providers/all_providers.dart';
import 'package:bbblient/src/controller/authentication/auth_provider.dart';
import 'package:bbblient/src/models/chat_models/chat_messages.dart';
import 'package:bbblient/src/models/chat_models/chat_model.dart';
import 'package:bbblient/src/theme/app_main_theme.dart';
import 'package:bbblient/src/utils/icons.dart';
import 'package:bbblient/src/utils/utils.dart';
import 'package:bbblient/src/views/widgets/image.dart';
import 'package:bbblient/src/views/widgets/widgets.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'image_preview.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class Chat extends StatelessWidget {
  final String peerId;
  final String peerAvatar;
  final String peerName;
  final String appointmentId;

  const Chat({
    Key? key,
    required this.peerId,
    required this.peerAvatar,
    required this.peerName,
    required this.appointmentId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.4,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(Icons.arrow_back_ios),
        ),
        title: Row(
          children: [
            CircleAvatar(
              backgroundColor: Colors.white,
              radius: 20,
              backgroundImage: (peerAvatar != ""
                  ? NetworkImage(peerAvatar)
                  : const AssetImage(
                      AppIcons.defaultUserAvtarPNG,
                    )) as ImageProvider<Object>?,
            ),
            const SizedBox(
              width: 16,
            ),
            Text(
              peerName,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          ],
        ),
        centerTitle: false,
      ),
      body: ChatScreen(
        peerId: peerId,
        peerAvatar: peerId,
        peerName: peerName,
        appointmentId: appointmentId,
      ),
    );
  }
}

class ChatScreen extends ConsumerStatefulWidget {
  final String peerId;
  final String peerAvatar;
  final String peerName;
  final String appointmentId;

  const ChatScreen({Key? key, required this.peerId, required this.peerAvatar, required this.peerName, required this.appointmentId}) : super(key: key);

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends ConsumerState<ChatScreen> {
  late AuthProviderController _authProvider;
  late String userUId = '';
  List<ChatMessages> listMessage = [];
  final int _limit = 20;
  final int _limitIncrement = 20;
  String chatId = "";
  String lastMessage = "";
  SharedPreferences? prefs;
  var chatRef = FirebaseFirestore.instance.collection('chats');

  File? imageFile;
  bool isLoading = false;
  String imageUrl = "";

  bool imagepickerTapped = false;
  final Utils utils = Utils();
  // final ChatNotification notification = ChatNotification();
  final TextEditingController textEditingController = TextEditingController();
  final ScrollController listScrollController = ScrollController();
  final FocusNode focusNode = FocusNode();

  _scrollListener() {
    // if (listScrollController.offset >= listScrollController.position.maxScrollExtent &&
    //     !listScrollController.position.outOfRange) {
    //   setState(() {
    //     _limit += _limitIncrement;
    //   });
    // }
  }

  @override
  void initState() {
    super.initState();
    listScrollController.addListener(_scrollListener);
    initialiseChat();
  }

  initialiseChat() async {
    _authProvider = ref.read(authProvider);
    userUId = _authProvider.currentCustomer!.customerId;
    QuerySnapshot list = await chatRef.where("customerId", isEqualTo: _authProvider.currentCustomer!.customerId).where("salonId", isEqualTo: widget.peerId).get();
    printIt(list.docs);

    if (list.docs.isNotEmpty) {
      setState(() {
        chatId = list.docs.first.id;
      });

      printIt("Chat Found");
    } else {
      printIt("chat not found");
      var data = ChatModel(
        customerId: _authProvider.currentCustomer!.customerId,
        customerAvtar: "",
        salonId: widget.peerId,
        salonAvtar: widget.peerAvatar,
        createdAt: Timestamp.fromDate(DateTime.now()),
        messages: [],
        appointmentId: widget.appointmentId,
        customerDeleted: false,
        // todo
        // customerName: NamingConventions.getName()
        customerName: '',
        lastMessage: "",
        lastSeenCustomer: Timestamp.now(),
        lastSeenSalon: Timestamp.fromDate(
          DateTime.now().subtract(const Duration(days: 7)),
        ),
        salonDeleted: false,
        // todo get salon_home name also
        salonName: widget.peerName,
      );
      chatRef.add(data.toJson()).then((value) {
        setState(() {
          chatId = value.id;
        });
      });
    }
  }

  Future getImage({required BuildContext context}) async {
    ImagePicker imagePicker = ImagePicker();
    XFile? pickedFile;
    try {
      pickedFile = await imagePicker.pickImage(source: ImageSource.gallery, imageQuality: 50);
      if (pickedFile != null) {
        imageFile = File(pickedFile.path);
        if (imageFile != null) {
          setState(() {
            isLoading = true;
            imagepickerTapped = false;
          });
          uploadFile(context: context);
        }
      } else {
        setState(() {
          imagepickerTapped = false;
        });
      }
    } catch (e) {
      printIt(e);
    }
  }

  double _progress = 0.0;

  Future uploadFile({required BuildContext context}) async {
    showToast(AppLocalizations.of(context)?.uploading ?? "uploading");
    String fileName = "$userUId-${DateTime.now().millisecondsSinceEpoch.toString()}";
    Reference reference = FirebaseStorage.instance.ref().child("chatAssets").child(chatId).child(fileName);
    UploadTask uploadTask = reference.putFile(imageFile!);

    uploadTask.snapshotEvents.listen((event) {
      setState(() {
        printIt(event.bytesTransferred.toDouble());
        _progress = event.bytesTransferred.toDouble() / event.totalBytes.toDouble();
      });
    }).onError((error) {
      showToast(AppLocalizations.of(context)?.errorOccurred ?? "Network error");
    });
    // printIt(_progress);
    // showToast('Uploading ${(_progress * 100).toStringAsFixed(2)} %');
    // ScaffoldMessenger.of(context)
    //     .showSnackBar(SnackBar(content: Text('Uploading ${(_progress * 100).toStringAsFixed(2)} %')));

    try {
      TaskSnapshot snapshot = await uploadTask;

      imageUrl = await snapshot.ref.getDownloadURL();
      setState(() {
        isLoading = false;
        onSendMessage(imageUrl, 1);
      });
    } on FirebaseException catch (e) {
      setState(() {
        isLoading = false;
      });
      printIt(e);
      showToast(AppLocalizations.of(context)?.errorOccurred ?? "Network error");
    }
  }

  void onSendMessage(String content, int type) async {
    // type: 0 = text, 1 = image, 2 = audio
    if (content.trim() != '') {
      textEditingController.clear();
      await chatRef.doc(chatId).update({
        "messages": FieldValue.arrayUnion([ChatMessages(uid: userUId, createdAt: Timestamp.fromDate(DateTime.now()), type: type, content: content).toJson()])
      });
      // notification.sendNotificationToSalon(utils.getName(_authProvider.currentCustomer?.personalInfo), content, widget.peerId, type: type);
      listScrollController.animateTo(0.0, duration: const Duration(milliseconds: 300), curve: Curves.easeOut);
      setState(() {
        lastMessage = content;
      });
    } else {
      showToast("no message !");
    }
  }

  Widget buildItem(int index, ChatMessages chatMessages) {
    // ignore: unnecessary_null_comparison
    if (chatMessages != null) {
      if (chatMessages.uid == userUId) {
        // Right (my message)
        return const Row(
          children: <Widget>[
            // chatMessages.type == 0
            //     // Text
            //     ? TranslationWidget(
            //         // fromString: chatMessages.content,
            //         toLanguageCode: _authProvider.currentCustomer?.locale,
            //         message: chatMessages.content,
            //         builder: (stringg) {
            //           return Container(
            //             child: Column(
            //               crossAxisAlignment: CrossAxisAlignment.start,
            //               children: [
            //                 Text(
            //                   stringg,
            //                   style: Theme.of(context).textTheme.bodyMedium!.copyWith(color: AppTheme.textBlack),
            //                   textAlign: TextAlign.start,
            //                 ),
            //                 Row(
            //                   mainAxisAlignment: MainAxisAlignment.end,
            //                   children: [
            //                     Text(
            //                       DateFormat('EE kk:mm').format(DateTime.fromMillisecondsSinceEpoch(chatMessages.createdAt!.millisecondsSinceEpoch)),

            //                       // "${chatMessages.createdAt.toDate().hour}:${chatMessages.createdAt.toDate().minute}",
            //                       style: Theme.of(context).textTheme.bodyMedium!.copyWith(
            //                             fontSize: 12,
            //                             fontStyle: FontStyle.italic,
            //                           ),
            //                     )
            //                   ],
            //                 )
            //               ],
            //             ),
            //             padding: const EdgeInsets.fromLTRB(12.0, 12.0, 12.0, 10.0),
            //             width: .7.sw,
            //             decoration: BoxDecoration(
            //                 color: AppTheme.oliveLight.withOpacity(0.3),
            //                 borderRadius: const BorderRadius.only(
            //                   topLeft: Radius.circular(12),
            //                   bottomLeft: Radius.circular(12),
            //                   bottomRight: Radius.circular(12),
            //                 )),
            //             margin: const EdgeInsets.only(bottom: 10.0, right: 10.0),
            //           );
            //         })
            //     : chatMessages.type == 1
            //         // Image
            //         ? GestureDetector(
            //             onTap: () {
            //               Navigator.push(
            //                   context,
            //                   MaterialPageRoute(
            //                       builder: (context) => ImagePreview(
            //                             index: 0,
            //                             imageUrls: [chatMessages.content],
            //                           )));
            //             },
            //             child: imageUrl != ""
            //                 ? Container(
            //                     child: ClipRRect(
            //                       borderRadius: BorderRadius.circular(12),
            //                       child: CachedImage(url: imageUrl, height: 200.w, width: 200.w),
            //                     ),
            //                     margin: const EdgeInsets.only(bottom: 10.0, right: 10.0),
            //                   )
            //                 : Container(
            //                     child: ClipRRect(
            //                       borderRadius: BorderRadius.circular(12),
            //                       child: CachedNetworkImage(
            //                         memCacheHeight: 200,
            //                         imageUrl: chatMessages.content!,
            //                         width: 200.0.w,
            //                         height: 200.0.h,
            //                         fit: BoxFit.cover,
            //                         progressIndicatorBuilder: (context, url, progress) {
            //                           return Center(
            //                               child: SizedBox(
            //                                   height: 30,
            //                                   width: 30,
            //                                   child: CircularProgressIndicator(
            //                                     value: progress.progress,
            //                                   )));
            //                         },
            //                       ),
            //                     ),
            //                     margin: const EdgeInsets.only(bottom: 10.0, right: 10.0),
            //                   ),
            //           )
            //         : Container(
            //             margin: const EdgeInsets.only(bottom: 10.0, right: 10.0),
            //           ),
          ],
          mainAxisAlignment: MainAxisAlignment.end,
        );
      } else {
        // Left (peer message)
        return Container(
          child: Column(
            children: <Widget>[
              Row(
                children: <Widget>[
                  chatMessages.type == 0
                      ? Container(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                chatMessages.content!,
                                style: Theme.of(context).textTheme.bodyMedium!.copyWith(color: AppTheme.textBlack),
                                textAlign: TextAlign.start,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Text(
                                    DateFormat('dd EE kk:mm').format(DateTime.fromMillisecondsSinceEpoch(chatMessages.createdAt!.millisecondsSinceEpoch)),
                                    style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                                          fontSize: 12,
                                          fontStyle: FontStyle.italic,
                                        ),
                                  )
                                ],
                              )
                            ],
                          ),
                          padding: const EdgeInsets.fromLTRB(12.0, 12.0, 12.0, 10.0),
                          width: .7.sw,
                          decoration: const BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(12),
                                bottomLeft: Radius.circular(12),
                                bottomRight: Radius.circular(12),
                              )),
                          margin: const EdgeInsets.only(bottom: 10.0, right: 10.0),
                        )
                      : chatMessages.type == 1
                          ? GestureDetector(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => ImagePreview(
                                              index: 0,
                                              imageUrls: [chatMessages.content],
                                            )));
                              },
                              child: Container(
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(12),
                                  child: CachedNetworkImage(
                                    memCacheHeight: 200,
                                    imageUrl: chatMessages.content!,
                                    width: 200.0.w,
                                    height: 200.0.h,
                                    fit: BoxFit.cover,
                                    progressIndicatorBuilder: (context, url, progress) {
                                      return Center(
                                          child: SizedBox(
                                              height: 30,
                                              width: 30,
                                              child: CircularProgressIndicator(
                                                value: progress.progress,
                                              )));
                                    },
                                  ),
                                ),
                                margin: const EdgeInsets.only(bottom: 10.0, right: 10.0),
                              ),
                            )
                          : Container(
                              margin: const EdgeInsets.only(bottom: 10.0, right: 10.0),
                            ),
                ],
              ),
            ],
            crossAxisAlignment: CrossAxisAlignment.start,
          ),
          margin: const EdgeInsets.only(bottom: 10.0),
        );
      }
    } else {
      return const SizedBox.shrink();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Column(
          children: <Widget>[
            // List of messages
            buildListMessage(),

            // Input content
            buildInput(),
          ],
        ),

        // Loading
        buildLoading()
      ],
    );
  }

  Widget buildLoading() {
    return Positioned(
      child: isLoading ? const LinearProgressIndicator() : Container(),
    );
  }

  Widget buildInput() {
    return SafeArea(
      child: Container(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: <Widget>[
            // Button send image
            Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: IconButton(
                icon: SizedBox(height: 22, width: 22, child: SvgPicture.asset(AppIcons.attachSVG)),
                onPressed: () {
                  if (!imagepickerTapped) {
                    setState(() {
                      imagepickerTapped = true;
                    });
                    getImage(context: context);
                  }
                },
              ),
            ),

            Flexible(
              child: Padding(
                padding: const EdgeInsets.only(top: 12.0, bottom: 8.0),
                child: TextField(
                  onSubmitted: (value) {
                    onSendMessage(textEditingController.text, 0);
                  },
                  style: Theme.of(context).textTheme.bodyMedium!.copyWith(color: AppTheme.textBlack),
                  controller: textEditingController,
                  decoration: InputDecoration(
                    hintText: AppLocalizations.of(context)?.typeYourMessage ?? 'Type your message...',
                    hintStyle: Theme.of(context).textTheme.bodyMedium!.copyWith(color: AppTheme.lightGrey),
                    fillColor: AppTheme.milkeyGrey,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                    filled: true,
                  ),
                  expands: false,
                  maxLines: null,
                  keyboardType: TextInputType.multiline,
                  focusNode: focusNode,
                ),
              ),
            ),
            // Button send message
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: IconButton(
                icon: const Icon(Icons.send),
                onPressed: () => onSendMessage(textEditingController.text, 0),
                color: Colors.black,
                splashColor: Colors.transparent,
                highlightColor: Colors.transparent,
              ),
            ),
          ],
        ),
        width: double.infinity,
        constraints: const BoxConstraints(maxHeight: 200),
        decoration: const BoxDecoration(color: Colors.white),
      ),
    );
  }

  Widget buildListMessage() {
    return Expanded(
      child: chatId.isNotEmpty
          ? StreamBuilder(
              stream: FirebaseFirestore.instance.collection('chats').doc(chatId).snapshots(),
              builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot<Map>> snapshot) {
                if (snapshot.connectionState == ConnectionState.active) {
                  List<dynamic> rawMessages = snapshot.data!.data()!['messages'];

                  // if (rawMessages.isNotEmpty) {
                  //   for ()
                  // }
                  List<ChatMessages> processedMessages = rawMessages.map((e) => ChatMessages.fromJson(e)).toList().reversed.toList();

                  printIt(processedMessages);

                  printIt(processedMessages);

                  processedMessages.sort((a, b) {
                    return b.createdAt!.compareTo(a.createdAt!);
                  });

                  if (processedMessages.isNotEmpty) {
                    // printIt(snapshot.data.data());
                    listMessage.addAll(processedMessages);
                    return ListView.builder(
                      padding: const EdgeInsets.all(10.0),
                      itemBuilder: (context, index) {
                        // debugPrint(processedMessages[index].content);

                        return buildItem(index, processedMessages[index]);
                      },
                      itemCount: processedMessages.length,
                      reverse: true,
                      controller: listScrollController,
                    );
                  } else {
                    return const SizedBox();
                  }
                } else {
                  return const Center(
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(AppTheme.creamBrownLight),
                    ),
                  );
                }
              },
            )
          : const Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(AppTheme.creamBrownLight),
              ),
            ),
    );
  }
}
