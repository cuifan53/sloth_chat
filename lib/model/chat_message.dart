part of sloth_chat;

enum MessageType {
  // 文字
  text,
  // 图片
  image,
  // 文件
  file,
  // 语音
  voice,
  // 表情
  sticker,
}

enum MessageImageLocation {
  // 文件
  file,
  // 网络
  network,
}

// 聊天信息
class ChatMessage {
  // 唯一标识
  final String id;

  // 聊天用户
  final ChatUser user;

  // 创建时间
  final DateTime createdAt;

  // 消息类型
  final MessageType messageType;

  // 文字
  final String? text;

  // 图片
  final String? image;

  // 图片
  final MessageImageLocation? imageLocation;

  // 自定义数据
  Map<String, dynamic>? customProperties;

  ChatMessage({
    required this.id,
    required this.user,
    required this.createdAt,
    this.messageType = MessageType.text,
    this.text,
    this.image,
    this.imageLocation,
    this.customProperties,
  });
}
