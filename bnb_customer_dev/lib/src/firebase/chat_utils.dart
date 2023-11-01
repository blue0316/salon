import 'package:bbblient/src/firebase/collections.dart';
import 'package:bbblient/src/models/chat_models/chat_model.dart';

class ChatApi {
  ChatApi._privateConstructor();
  static final ChatApi _instance = ChatApi._privateConstructor();
  factory ChatApi() {
    return _instance;
  }

  Stream<List<ChatModel>> getAllChatsStream(String customerId) {
    return Collection.chats
        .where('customerId', isEqualTo: customerId)
        .snapshots()
        .map((snapShot) => snapShot.docs.map<ChatModel>((chat) {
              Map _temp = chat.data() as Map<dynamic, dynamic>;
              // print("data = $chat");
              // print(chat.id);
              return ChatModel.fromJson(_temp as Map<String, dynamic>);
            }).toList());
  }
}
