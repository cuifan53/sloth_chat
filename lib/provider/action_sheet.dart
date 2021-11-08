part of sloth_chat;

class ActionSheetProvider extends State<StatefulWidget>
    with ChangeNotifier, SingleTickerProviderStateMixin {
  final double maxHeight;
  double height = 0;
  bool isExpanded = false;
  late AnimationController animationController;
  late Animation<double> animation;

  ActionSheetProvider(context, {required this.maxHeight}) {
    animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 150),
      reverseDuration: const Duration(milliseconds: 150),
    );
    animation = Tween<double>(begin: 0, end: maxHeight).animate(
      CurvedAnimation(
        parent: animationController,
        curve: Curves.easeIn,
      ),
    )
      ..addListener(() {
        height = animation.value;
        notifyListeners();
      })
      ..addStatusListener((status) {
        if (status == AnimationStatus.forward) {
          isExpanded = true;
        } else if (status == AnimationStatus.reverse) {
          isExpanded = false;
        }
      });
  }

  animationForward() {
    if (!isExpanded) {
      EventBusC().bus.fire(MessageListScrollEvent(toBottom: true));
      animationController.forward();
    }
  }

  animationReverse() {
    if (isExpanded) {
      animationController.reverse();
    }
  }

  @override
  Widget build(BuildContext context) => Container();
}
