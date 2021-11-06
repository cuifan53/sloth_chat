part of sloth_chat;

class CurrentUserProvider with ChangeNotifier {
  final ChatUser currentUser;

  CurrentUserProvider({
    required this.currentUser,
  });
}
