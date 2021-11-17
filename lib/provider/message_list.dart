part of sloth_chat;

class MessageListProvider with ChangeNotifier {
  List<ChatMessage> messages = [];
  bool reverse = true;

  MessageListProvider({
    required this.messages,
    required this.reverse,
  });

  List<ChatMessage> getImageMessages() {
    List<ChatMessage> imageMessages = messages
        .where((element) => element.messageType == MessageType.image)
        .toList();
    if (reverse) {
      imageMessages = imageMessages.reversed.toList();
    }
    return imageMessages;
  }
}
