part of sloth_chat;

class ImageView extends StatelessWidget {
  final List<ChatMessage> imageMessages;
  final int initialPage;
  final Function(ChatMessage message)? onDefaultTapImageDownload;

  const ImageView({
    Key? key,
    required this.imageMessages,
    required this.initialPage,
    this.onDefaultTapImageDownload,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    imageMessages.forEach((element) {
      print(element.image);
    });
    print(initialPage);

    PageController _pageController = PageController(initialPage: initialPage);
    int _currentPage = initialPage;

    return GestureDetector(
      onTap: () {
        Navigator.pop(context);
      },
      child: Stack(
        alignment: Alignment.bottomRight,
        children: [
          PhotoViewGallery.builder(
            pageController: _pageController,
            onPageChanged: (currentPage) {
              _currentPage = currentPage;
            },
            itemCount: imageMessages.length,
            builder: (context, index) {
              ChatMessage message = imageMessages[index];
              if (message.imageLocation == MessageImageLocation.file) {
                return PhotoViewGalleryPageOptions(
                  imageProvider: FileImage(
                    File.fromUri(Uri.file(message.image!)),
                  ),
                );
              } else {
                return PhotoViewGalleryPageOptions(
                  imageProvider: NetworkImage(message.image!),
                );
              }
            },
          ),
          Positioned(
            bottom: 100 * rpx,
            right: 100 * rpx,
            child: GestureDetector(
              onTap: () {
                ChatMessage message = imageMessages[_currentPage];
                if (onDefaultTapImageDownload != null) {
                  onDefaultTapImageDownload!.call(message);
                }
              },
              child: Container(
                padding: EdgeInsets.all(10 * rpx),
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Color(0xFF999999),
                ),
                child: Icon(
                  Icons.download,
                  color: Colors.white,
                  size: 48 * rpx,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
