part of sloth_chat;

class MessageList extends StatefulWidget {
  final MessageListOption messageListOption;
  final MessageRowOption messageRowOption;

  const MessageList({
    Key? key,
    required this.messageListOption,
    required this.messageRowOption,
  }) : super(key: key);

  @override
  _MessageListState createState() => _MessageListState();
}

class _MessageListState extends State<MessageList> {
  StreamSubscription? _ss;
  final ScrollController _scrollController = ScrollController();

  @override
  initState() {
    super.initState();

    _ss = EventBusC().bus.on<MessageListScrollEvent>().listen((event) {
      if (event.toBottom) {
        _scrollController.animateTo(
          widget.messageListOption.reverse
              ? 0
              : _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  dispose() {
    if (_ss != null) {
      _ss!.cancel();
      _ss = null;
    }

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    MessageListProvider messageListProvider =
        Provider.of<MessageListProvider>(context);
    CurrentUserProvider currentUserProvider =
        Provider.of<CurrentUserProvider>(context);

    List<Widget> messageList = [];
    for (int i = 0; i < messageListProvider.messages.length; i++) {
      ChatMessage message = messageListProvider.messages[i];
      MessageRow messageRow = MessageRow(
        isCurrentUser: message.user.id == currentUserProvider.currentUser.id,
        message: message,
        messageRowOption: widget.messageRowOption,
      );
      if (i > 0 && widget.messageListOption.showGapTime!) {
        Duration timeGap = message.createdAt
            .difference(messageListProvider.messages[i - 1].createdAt);
        if (timeGap > widget.messageListOption.timeGap!) {
          messageList.add(_messageAt(message));
        }
      }
      messageList.add(messageRow);
    }
    return GestureDetector(
      onTap: () {
        hideKeyboard(context);
        hideActionSheet(context);
      },
      child: ListView.builder(
        shrinkWrap: true,
        reverse: widget.messageListOption.reverse,
        controller: _scrollController,
        itemCount: messageList.length,
        itemBuilder: (context, index) => messageList[index],
      ),
    );
  }

  Widget _messageAt(ChatMessage message) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 20 * rpx),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            widget.messageListOption.formatGapTime!(message.createdAt),
            style: TextStyle(
              color: const Color(0xFF999999),
              fontSize: 22 * rpx,
            ),
          )
        ],
      ),
    );
  }
}
