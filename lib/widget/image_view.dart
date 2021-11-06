part of sloth_chat;

class ImageView extends StatelessWidget {
  final List<ChatMessage> imageMessages;
  final int initialPage;
  const ImageView({
    Key? key,
    required this.imageMessages,
    required this.initialPage,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
              onTap: () async {
                ChatMessage message = imageMessages[_currentPage];
                if (message.imageLocation == MessageImageLocation.file) {
                  await ImagesPicker.saveImageToAlbum(
                    File.fromUri(Uri.file(message.image!)),
                  );
                }
                // todo 网络图片先下载再保存到相册
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
