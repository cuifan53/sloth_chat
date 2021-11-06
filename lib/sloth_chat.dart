library sloth_chat;

import 'dart:async';
import 'dart:io';
import 'dart:math';
import 'dart:ui' as ui show window;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_parsed_text/flutter_parsed_text.dart';
import 'package:images_picker/images_picker.dart';
import 'package:intl/intl.dart';
import 'package:photo_view/photo_view_gallery.dart';
import 'package:provider/provider.dart';

part './model/action_sheet_option.dart';
part './model/chat_message.dart';
part './model/chat_user.dart';
part './model/input_bar_option.dart';
part './model/message_list_option.dart';
part './model/message_row_option.dart';
part './provider/action_sheet.dart';
part './provider/current_user.dart';
part './provider/message_list.dart';
part './widget/action_sheet.dart';
part './widget/image_view.dart';
part './widget/input_bar.dart';
part './widget/message_list.dart';
part './widget/message_row.dart';

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

class SlothChat extends StatefulWidget {
  // 当前用户
  final ChatUser currentUser;

  // 聊天信息列表
  final List<ChatMessage> messages;

  // 背景颜色
  final Color? backgroundColor;

  // 动作面板高度 建议取键盘高度
  final double? actionSheetMaxHeight;

  // 聊天界面相关配置
  final MessageListOption? messageListOption;

  // 聊天框相关配置
  final MessageRowOption? messageRowOption;

  // 输入栏相关配置
  final InputBarOption? inputBarOption;

  // 动作面板相关配置
  final ActionSheetOption? actionSheetOption;

  const SlothChat({
    Key? key,
    required this.currentUser,
    required this.messages,
    this.backgroundColor = const Color(0xFFF0F0F0),
    this.actionSheetMaxHeight,
    this.messageListOption,
    this.messageRowOption,
    this.inputBarOption,
    this.actionSheetOption,
  }) : super(key: key);

  @override
  _SlothChatState createState() => _SlothChatState();
}

class _SlothChatState extends State<SlothChat> {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => CurrentUserProvider(currentUser: widget.currentUser),
        ),
        ChangeNotifierProvider(
          create: (_) => MessageListProvider(messages: widget.messages),
        ),
        ChangeNotifierProvider(
          create: (_) => ActionSheetProvider(
            context,
            maxHeight: widget.actionSheetMaxHeight ?? 480 * rpx,
          ),
        ),
      ],
      child: Container(
        color: widget.backgroundColor,
        child: Column(
          children: [
            Expanded(
              child: MessageList(
                messageListOption:
                    widget.messageListOption ?? MessageListOption(),
                messageRowOption: widget.messageRowOption ?? MessageRowOption(),
              ),
            ),
            InputBar(
              inputBarOption: widget.inputBarOption ?? InputBarOption(),
              actionSheetOption:
                  widget.actionSheetOption ?? ActionSheetOption(),
            ),
          ],
        ),
      ),
    );
  }
}
