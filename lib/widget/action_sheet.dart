part of sloth_chat;

class ActionSheet extends StatelessWidget {
  final ActionSheetOption actionSheetOption;

  const ActionSheet({
    Key? key,
    required this.actionSheetOption,
  }) : super(key: key);

  List<Widget> getActions(BuildContext context) {
    List<Widget> actions = [];
    if (actionSheetOption.showImageButton) {
      actions.add(_buildActionButton(
        name: '相册',
        iconData: Icons.image,
        onTap: actionSheetOption.onTapImageButton ?? _defaultOnTapImageButton,
      ));
    }
    if (actionSheetOption.showCameraButton) {
      actions.add(_buildActionButton(
        name: '拍照',
        iconData: Icons.camera_alt,
        onTap: actionSheetOption.onTapCameraButton ?? _defaultOnTapCameraButton,
      ));
    }
    if (actionSheetOption.showFileButton) {
      actions.add(_buildActionButton(
        name: '文件',
        iconData: Icons.folder,
        onTap: actionSheetOption.onTapFileButton,
      ));
    }
    if (actionSheetOption.showLocationButton) {
      actions.add(_buildActionButton(
        name: '位置',
        iconData: Icons.location_on,
        onTap: actionSheetOption.onTapLocationButton,
      ));
    }
    return actions;
  }

  @override
  Widget build(BuildContext context) {
    ActionSheetProvider actionSheetProvider =
        Provider.of<ActionSheetProvider>(context);

    return Container(
      padding: EdgeInsets.only(left: 60 * rpx, top: 40 * rpx, right: 60 * rpx),
      height: actionSheetProvider.height,
      decoration: const BoxDecoration(
        color: Color(0xFFF0F0F0),
        border: Border(
          top: BorderSide(color: Color(0xFF999999), width: 0.1),
        ),
      ),
      child: GridView(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 4,
          mainAxisSpacing: 40 * rpx,
          crossAxisSpacing: 20 * rpx,
        ),
        children: getActions(context),
      ),
    );
  }

  Widget _buildActionButton({
    required String name,
    required IconData iconData,
    VoidCallback? onTap,
  }) {
    return GestureDetector(
      onTap: onTap ?? () {},
      child: Column(
        children: [
          Container(
            width: 100 * rpx,
            height: 100 * rpx,
            margin: EdgeInsets.all(4 * rpx),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(30 * rpx),
            ),
            child: Center(
              child: Icon(
                iconData,
                size: 60 * rpx,
              ),
            ),
          ),
          Text(
            name,
            style: TextStyle(
              fontSize: 24 * rpx,
            ),
          ),
        ],
      ),
    );
  }

  _defaultOnTapImageButton() async {
    List<Media>? res = await ImagesPicker.pick(
      count: actionSheetOption.defaultMaxImageCount!,
      pickType: PickType.image,
    );
    if (actionSheetOption.onDefaultImageCompleted != null) {
      actionSheetOption.onDefaultImageCompleted!.call(res);
    }
  }

  _defaultOnTapCameraButton() async {
    List<Media>? res = await ImagesPicker.openCamera();
    if (actionSheetOption.onDefaultCameraCompleted != null) {
      actionSheetOption.onDefaultCameraCompleted!.call(res);
    }
  }
}
