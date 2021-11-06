part of sloth_chat;

// 聊天用户
class ChatUser {
  // 唯一标识
  final String id;
  // 名称
  final String name;
  // 头像
  final String? avatar;
  // 自定义数据
  final Map<String, dynamic>? customProperties;

  ChatUser({
    required this.id,
    required this.name,
    this.avatar,
    this.customProperties,
  });
}
