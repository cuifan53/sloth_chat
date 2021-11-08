part of sloth_chat;

class MessageListOption {
  // 是否反转消息列表
  bool reverse;

  // 是否在两条消息之间显示下一条消息时间
  bool? showGapTime;

  // 两条消息之间显示时间所需要的时间间隔
  Duration? timeGap;

  // 格式化时间间隔
  String Function(DateTime time)? formatGapTime;

  MessageListOption({
    this.reverse = true,
    this.showGapTime = true,
    this.timeGap = const Duration(hours: 1),
    this.formatGapTime,
  }) {
    formatGapTime = formatGapTime ?? defaultFormatGapTime;
  }
}

String defaultFormatGapTime(DateTime time) {
  DateTime now = DateTime.now();
  DateTime startOfToday = DateTime(now.year, now.month, now.day);
  String at;
  if (time.isAfter(startOfToday)) {
    at = DateFormat("HH:mm").format(time);
  } else if (time.isAfter(startOfToday.subtract(const Duration(days: 1)))) {
    at = '昨天 ${DateFormat("HH:mm").format(time)}';
  } else {
    at = DateFormat("MM月dd日 HH:mm").format(time);
  }
  return at;
}
