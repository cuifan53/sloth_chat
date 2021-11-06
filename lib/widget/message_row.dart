part of sloth_chat;

class MessageRow extends StatelessWidget {
  final bool isCurrentUser;
  final ChatMessage message;
  final MessageRowOption messageRowOption;

  final double _userAvatarSize = 80 * rpx;
  final double _triangleWidth = 12 * rpx;
  final double _triangleHeight = 20 * rpx;

  MessageRow({
    Key? key,
    required this.isCurrentUser,
    required this.message,
    required this.messageRowOption,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        left: isCurrentUser ? 120 * rpx : 20 * rpx,
        top: 20 * rpx,
        right: isCurrentUser ? 20 * rpx : 120 * rpx,
        bottom: 20 * rpx,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment:
            isCurrentUser ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: isCurrentUser
            ? [
                _buildMessageBox(context),
                _buildTriangle(),
                _buildUserAvatar(context),
              ]
            : [
                _buildUserAvatar(context),
                _buildTriangle(),
                _buildMessageBox(context),
              ],
      ),
    );
  }

  // 用户头像
  Widget _buildUserAvatar(BuildContext context) {
    return GestureDetector(
      onTap: () {
        hideKeyboard(context);
        hideActionSheet(context);
        if (messageRowOption.onTapUserAvatar != null) {
          messageRowOption.onTapUserAvatar!.call(message.user);
        }
      },
      child: Container(
        width: _userAvatarSize,
        height: _userAvatarSize,
        decoration: BoxDecoration(
          shape: BoxShape.rectangle,
          borderRadius: BorderRadius.circular(10 * rpx),
          image: DecorationImage(
            image: NetworkImage(message.user.avatar!),
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }

  // 消息框三角
  Widget _buildTriangle() {
    return Container(
      padding: EdgeInsets.only(
        left: isCurrentUser ? 0 : 10 * rpx,
        right: isCurrentUser ? 10 * rpx : 0,
        top: _userAvatarSize / 2 - _triangleHeight / 2,
      ),
      child: CustomPaint(
        painter: MessageTrianglePainter(
          reverse: isCurrentUser,
          color: isCurrentUser
              ? messageRowOption.currentUserColor!
              : messageRowOption.userColor!,
          width: _triangleWidth,
          height: _triangleHeight,
        ),
      ),
    );
  }

  // 消息框
  Widget _buildMessageBox(BuildContext context) {
    return Flexible(
      child: GestureDetector(
        onTap: () {
          _onTapMessageBox(context);
        },
        onDoubleTap: () {
          _onDoubleTapMessageBox(context);
        },
        onLongPress: () {
          _onLongPressMessageBox(context);
        },
        child: Container(
          margin: isCurrentUser
              ? EdgeInsets.only(right: 10 * rpx)
              : EdgeInsets.only(left: 10 * rpx),
          padding: EdgeInsets.all(20 * rpx),
          decoration: BoxDecoration(
            color: isCurrentUser
                ? messageRowOption.currentUserColor!
                : messageRowOption.userColor!,
            borderRadius: BorderRadius.circular(10 * rpx),
          ),
          child: _switchMessageBox(),
        ),
      ),
    );
  }

  Widget _switchMessageBox() {
    switch (message.messageType) {
      case MessageType.image:
        return _buildImageMessageBox();
      default:
        return _buildTextMessageBox();
    }
  }

  // 文字消息
  Widget _buildTextMessageBox() {
    return ParsedText(
      text: message.text ?? '',
      parse: messageRowOption.parsePatterns,
      style: TextStyle(
        fontSize: 30 * rpx,
        color: Colors.black,
      ),
    );
  }

  // 图片消息
  Widget _buildImageMessageBox() {
    return Container(
      child: message.imageLocation == MessageImageLocation.file
          ? Image.file(
              File.fromUri(Uri.file(message.image!)),
              fit: BoxFit.contain,
            )
          : Image.network(
              message.image!,
              fit: BoxFit.contain,
            ),
    );
  }

  _onTapMessageBox(BuildContext context) {
    switch (message.messageType) {
      case MessageType.image:
        if (messageRowOption.onTapImageMessage != null) {
          messageRowOption.onTapImageMessage!.call(message);
        } else {
          _defaultOnTapImageMessage(context);
        }
        break;
      default:
    }
  }

  _onDoubleTapMessageBox(BuildContext context) {
    switch (message.messageType) {
      case MessageType.text:
        if (messageRowOption.onDoubleTapTextMessage != null) {
          messageRowOption.onDoubleTapTextMessage!.call(message);
        } else {
          _defaultOnDoubleTapTextMessage(context);
        }
        break;
      default:
    }
  }

  _onLongPressMessageBox(BuildContext context) {
    switch (message.messageType) {
      case MessageType.text:
        if (messageRowOption.onLongPressTextMessage != null) {
          messageRowOption.onLongPressTextMessage!.call(message);
        } else {
          _defaultOnLongPressTextMessage(context);
        }
        break;
      case MessageType.image:
        if (messageRowOption.onLongPressImageMessage != null) {
          messageRowOption.onLongPressImageMessage!.call(message);
        } else {
          _defaultOnLongPressImageMessage(context);
        }
        break;
      default:
    }
  }

  // 默认长按文字消息回调
  _defaultOnLongPressTextMessage(BuildContext context) {}

  // 默认双击文字消息回调
  _defaultOnDoubleTapTextMessage(BuildContext context) {}

  // 默认点击图片消息回调
  _defaultOnTapImageMessage(BuildContext context) {
    MessageListProvider messageListProvider =
        Provider.of<MessageListProvider>(context, listen: false);
    List<ChatMessage> imageMessages = messageListProvider.getImageMessages();
    int initialPage =
        imageMessages.indexWhere((element) => element.id == message.id);
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ImageView(
          imageMessages: imageMessages,
          initialPage: initialPage,
        ),
      ),
    );
  }

  // 默认长按图片消息回调
  _defaultOnLongPressImageMessage(BuildContext context) {}
}

// 消息框三角绘制
class MessageTrianglePainter extends CustomPainter {
  final bool reverse;
  final Color color;
  final double width;
  final double height;

  MessageTrianglePainter({
    this.reverse = false,
    required this.color,
    required this.width,
    required this.height,
  });

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..style = PaintingStyle.fill
      ..strokeWidth = 1
      ..color = color;

    Path path = Path()
      ..moveTo(0, height / 2)
      ..lineTo(reverse ? -width : width, height)
      ..lineTo(reverse ? -width : width, 0)
      ..lineTo(0, height / 2);

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
