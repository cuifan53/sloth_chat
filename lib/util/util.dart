part of sloth_chat;

// rpx宽高比例适配
double rpx = MediaQueryData.fromWindow(ui.window).size.width / 750;

// 隐藏键盘
hideKeyboard(BuildContext context) {
  FocusScope.of(context).requestFocus(FocusNode());
}

// 隐藏动作面板
hideActionSheet(BuildContext context) {
  ActionSheetProvider actionSheetProvider =
      Provider.of<ActionSheetProvider>(context, listen: false);
  actionSheetProvider.animationReverse();
}
