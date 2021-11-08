import 'package:flutter/material.dart';
import 'package:flutter_parsed_text/flutter_parsed_text.dart';
import 'package:sloth_chat/sloth_chat.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SlothChat Demo',
      home: Scaffold(
        backgroundColor: const Color(0xFFF0F0F0),
        appBar: AppBar(
          elevation: 0,
          backgroundColor: const Color(0xFFF0F0F0),
          title: const Text(
            'DEMO',
            style: TextStyle(
              color: Colors.black,
            ),
          ),
          centerTitle: true,
          leading: const BackButton(
            color: Colors.black,
          ),
          actions: [
            IconButton(
              onPressed: () {},
              icon: const Icon(
                Icons.more_horiz_rounded,
                color: Colors.black,
              ),
            )
          ],
        ),
        body: SlothChat(
          currentUser: ChatUser(id: '1', name: 'user1'),
          messages: const <ChatMessage>[],
          inputBarOption: InputBarOption(),
          actionSheetOption: ActionSheetOption(
            onDefaultImageCompleted: (medias) {},
            onDefaultCameraCompleted: (media) {},
          ),
          messageRowOption: MessageRowOption(
            parsePatterns: [
              MatchText(
                type: ParsedType.PHONE,
                onTap: (text) async {},
              ),
            ],
            onTapUserAvatar: (user) {},
          ),
        ),
      ),
    );
  }
}
