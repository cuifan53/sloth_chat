part of sloth_chat;

class MessageRowOption {
  // 当前用户颜色
  final Color? currentUserColor;

  // 对方用户颜色
  final Color? userColor;

  // 文字消息解析器
  final List<MatchText> parsePatterns;

  // 点击头像回调
  final Function(ChatUser user)? onTapUserAvatar;

  // 长按文字消息回调
  final Function(ChatMessage message)? onLongPressTextMessage;

  // 双击文字消息回调
  final Function(ChatMessage message)? onDoubleTapTextMessage;

  // 点击图片消息回调
  final Function(ChatMessage message)? onTapImageMessage;

  // 点击图片消息回调
  final Function(ChatMessage message)? onDefaultTapImageDownload;

  // 长按图片消息回调
  final Function(ChatMessage message)? onLongPressImageMessage;

  MessageRowOption({
    this.currentUserColor = const Color(0xFF86EC56),
    this.userColor = Colors.white,
    this.parsePatterns = const [],
    this.onTapUserAvatar,
    this.onLongPressTextMessage,
    this.onDoubleTapTextMessage,
    this.onTapImageMessage,
    this.onDefaultTapImageDownload,
    this.onLongPressImageMessage,
  });
}
