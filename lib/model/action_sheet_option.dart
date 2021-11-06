part of sloth_chat;

// 动作面板配置
class ActionSheetOption {
  EdgeInsetsGeometry? padding;

  // 是否显示相册按钮
  bool showImageButton;

  // 点击相册按钮回调
  VoidCallback? onTapImageButton;

  // 默认相册最大选择数量
  int? defaultMaxImageCount;

  // 拍照默认方法结果回调
  Function(List<Media>? medias)? onDefaultImageCompleted;

  // 是否显示拍照按钮
  bool showCameraButton;

  // 点击拍照按钮回调
  VoidCallback? onTapCameraButton;

  // 拍照默认方法结果回调
  Function(List<Media>? medias)? onDefaultCameraCompleted;

  // 是否显示文件按钮
  bool showFileButton;

  // 点击文件按钮回调
  VoidCallback? onTapFileButton;

  // 是否显示位置按钮
  bool showLocationButton;

  // 点击位置按钮回调
  VoidCallback? onTapLocationButton;

  ActionSheetOption({
    this.padding,
    this.showImageButton = true,
    this.onTapImageButton,
    this.defaultMaxImageCount = 9,
    this.onDefaultImageCompleted,
    this.showCameraButton = true,
    this.onTapCameraButton,
    this.onDefaultCameraCompleted,
    this.showFileButton = false,
    this.onTapFileButton,
    this.showLocationButton = false,
    this.onTapLocationButton,
  });
}
