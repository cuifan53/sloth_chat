part of sloth_chat;

class MessageListProvider with ChangeNotifier {
  List<ChatMessage> messages = [];

  MessageListProvider({
    required this.messages,
  });

  List<ChatMessage> getImageMessages() {
    return messages
        .where((element) => element.messageType == MessageType.image)
        .toList();
  }
}
