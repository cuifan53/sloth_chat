part of sloth_chat;

class InputBarOption {
  // 是否启用语音功能
  bool? enableVoice;

  // 是否启用表情功能
  bool? enableSticker;

  InputBarOption({
    this.enableVoice = true,
    this.enableSticker = true,
  });
}
