part of sloth_chat;

class InputBar extends StatefulWidget {
  final InputBarOption inputBarOption;
  final ActionSheetOption actionSheetOption;

  const InputBar({
    Key? key,
    required this.inputBarOption,
    required this.actionSheetOption,
  }) : super(key: key);

  @override
  _InputBarState createState() => _InputBarState();
}

class _InputBarState extends State<InputBar> {
  bool _voiceMode = false; // 是否是语音模式
  final TextEditingController _textController = TextEditingController();
  bool _hasText = false; // 输入框是否有内容
  final FocusNode _textFocusNode = FocusNode();
  bool _recording = false; // 是否正在录制声音
  late ActionSheetProvider actionSheetProvider;

  @override
  initState() {
    super.initState();

    _textController.addListener(() {
      setState(() {
        _hasText = _textController.text.trim().isNotEmpty;
      });
    });

    _textFocusNode.addListener(() {
      // 点击输入框时先隐藏actionSheet
      if (_textFocusNode.hasFocus) {
        actionSheetProvider.animationReverse();
        EventBusC().bus.fire(MessageListScrollEvent(toBottom: true));
      }
    });
  }

  @override
  void dispose() {
    _textController.dispose();
    _textFocusNode.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    actionSheetProvider = Provider.of<ActionSheetProvider>(context);

    return SafeArea(
      child: Column(
        children: [
          Container(
            decoration: const BoxDecoration(
              color: Color(0xFFF0F0F0),
              border: Border(
                top: BorderSide(color: Color(0xFF999999), width: 0.1),
              ),
            ),
            width: MediaQueryData.fromWindow(ui.window).size.width,
            padding: EdgeInsets.symmetric(horizontal: 20 * rpx),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                widget.inputBarOption.enableVoice!
                    ? Container(
                        margin: EdgeInsets.only(bottom: 4 * rpx),
                        child: _voiceMode
                            ? _buildTextIconButton()
                            : _buildVoiceIconButton(),
                      )
                    : Container(
                        margin: EdgeInsets.only(bottom: 4 * rpx),
                        child: _buildTextIconButton(),
                      ),
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20 * rpx),
                    child: _voiceMode ? _buildVoiceButton() : _buildTextField(),
                  ),
                ),
                widget.inputBarOption.enableSticker!
                    ? Container(
                        margin: EdgeInsets.only(bottom: 4 * rpx),
                        child: _buildFaceIconButton(),
                      )
                    : Container(),
                Container(
                  margin: EdgeInsets.only(bottom: 4 * rpx),
                  child: _hasText ? _buildSendButton() : _buildAddIconButton(),
                ),
              ],
            ),
          ),
          ActionSheet(
            actionSheetOption: widget.actionSheetOption,
          ),
        ],
      ),
    );
  }

  // 左侧文字图标
  Widget _buildTextIconButton() {
    return OutlinedIconButton(
      onPressed: () {
        if (widget.inputBarOption.enableVoice!) {
          setState(() {
            _voiceMode = !_voiceMode;
          });
        }
        _textFocusNode.requestFocus();
      },
      icon: const Icon(Icons.keyboard),
    );
  }

  // 左侧语音图标
  Widget _buildVoiceIconButton() {
    return Transform.rotate(
      angle: pi / 2,
      child: OutlinedIconButton(
        onPressed: () {
          setState(() {
            _voiceMode = !_voiceMode;
          });
          // 点击语音图标时 隐藏actionSheet
          actionSheetProvider.animationReverse();
        },
        icon: const Icon(Icons.wifi),
      ),
    );
  }

  // 文字输入框
  Widget _buildTextField() {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 15 * rpx),
      padding: EdgeInsets.all(20 * rpx),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10 * rpx),
      ),
      child: TextField(
        controller: _textController,
        focusNode: _textFocusNode,
        maxLines: null,
        keyboardType: TextInputType.multiline,
        cursorColor: const Color(0xFF19B94D),
        decoration: const InputDecoration(
          border: InputBorder.none,
          contentPadding: EdgeInsets.zero,
          isDense: true,
        ),
      ),
    );
  }

  // 录制声音框
  Widget _buildVoiceButton() {
    return GestureDetector(
      onTapDown: (TapDownDetails details) {
        setState(() {
          _recording = true;
        });
      },
      onTapUp: (TapUpDetails details) {
        setState(() {
          _recording = false;
        });
      },
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 15 * rpx),
        height: 76.5 * rpx,
        decoration: BoxDecoration(
          color: _recording ? const Color(0xFFDCDCDC) : Colors.white,
          borderRadius: BorderRadius.circular(10 * rpx),
        ),
        child: Center(
          child: Text(
            _recording ? '松开 发送' : '按住 说话',
            style: TextStyle(
              fontSize: 30 * rpx,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }

  // 右侧表情图标
  Widget _buildFaceIconButton() {
    return Container(
      margin: EdgeInsets.only(right: 25 * rpx),
      child: OutlinedIconButton(
        onPressed: () {},
        icon: const Icon(Icons.face),
      ),
    );
  }

  // 右侧加号图标
  Widget _buildAddIconButton() {
    return OutlinedIconButton(
      onPressed: () {
        hideKeyboard(context);
        // 点击+号时 如果是声音模式 先切换到文字模式
        if (_voiceMode) {
          _voiceMode = !_voiceMode;
        }
        // 如果当前actionSheet已展开 先关闭 再让输入框获取焦点
        if (actionSheetProvider.isExpanded) {
          actionSheetProvider.animationReverse();
          _textFocusNode.requestFocus();
        } else {
          if (_textFocusNode.hasFocus) {
            // 这延时的150ms是为了视觉效果 给收起键盘预留的时间
            Timer(const Duration(milliseconds: 150), () {
              actionSheetProvider.animationForward();
            });
          } else {
            actionSheetProvider.animationForward();
          }
        }
      },
      icon: const Icon(Icons.add),
    );
  }

  // 右侧发送按钮
  Widget _buildSendButton() {
    return Container(
      margin: EdgeInsets.only(bottom: 3 * rpx),
      child: ElevatedButton(
        onPressed: () {},
        style: ButtonStyle(
            elevation: MaterialStateProperty.all(0),
            backgroundColor: MaterialStateProperty.all(const Color(0xFF19B94D)),
            shape: MaterialStateProperty.all(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10 * rpx),
              ),
            ),
            padding: MaterialStateProperty.all(
              EdgeInsets.symmetric(
                horizontal: 30 * rpx,
                vertical: 10 * rpx,
              ),
            ),
            minimumSize: MaterialStateProperty.all(Size(rpx, rpx))),
        child: Text(
          '发送',
          style: TextStyle(
            color: Colors.white,
            fontSize: 28 * rpx,
          ),
        ),
      ),
    );
  }
}

class OutlinedIconButton extends StatelessWidget {
  final Icon icon;
  final VoidCallback onPressed;
  final Color _color = const Color(0xFF333333);

  const OutlinedIconButton({
    Key? key,
    required this.icon,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 50 * rpx,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          width: 3 * rpx,
          color: _color,
        ),
      ),
      child: IconButton(
        splashColor: Colors.transparent,
        color: _color,
        icon: icon,
        iconSize: 36 * rpx,
        padding: const EdgeInsets.all(0),
        onPressed: onPressed,
      ),
    );
  }
}
