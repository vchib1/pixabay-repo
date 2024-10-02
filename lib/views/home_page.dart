import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:pixabay/model/photo.dart';
import 'package:pixabay/utils/extension/int_extension.dart';
import 'package:pixabay/views/provider/home_provider.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // Controller for GridView
  late ScrollController _scrollController;

  // HomeProvider instance
  late HomeProvider _homeProvider;

  @override
  void initState() {
    // Initializing variables
    _homeProvider = context.read<HomeProvider>();
    _scrollController = ScrollController();

    // Adding listener to scroll controller
    _scrollController.addListener(fetchMore);
    super.initState();
  }

  @override
  void dispose() {
    // dispose and remove listener
    _scrollController.removeListener(fetchMore);
    _scrollController.dispose();
    super.dispose();
  }

  // Fetch more images when scroll reaches end
  Future<void> fetchMore() async {
    bool scrollReachedEnd = _scrollController.hasClients &&
        (_scrollController.position.pixels ==
            _scrollController.position.maxScrollExtent);

    // If not reached end, return
    if (!scrollReachedEnd) return;

    // If reached end, fetch more images
    await _homeProvider.getImages();

    // If error, show error dialog
    if (_homeProvider.error != null) {
      await errorHandlerDialog();
    }
  }

  // Error dialog
  Future<void> errorHandlerDialog() async {
    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Error'),
        content: Text(_homeProvider.error ?? "Unknown error"),
        actions: [
          TextButton(
            onPressed: () async {
              _homeProvider.clearError();

              Navigator.of(context).pop();

              await _homeProvider.getImages();

              if (_homeProvider.error != null) {
                await errorHandlerDialog();
              }
            },
            child: const Text('Retry'),
          ),
          TextButton(
            onPressed: () {
              _homeProvider.clearError();
              Navigator.of(context).pop();
            },
            child: const Text('Cancel'),
          ),
        ],
      ),
    );
  }

  // View image dialog
  Future<void> viewImageDialog(Photo photo) async {
    await showDialog(
      context: context,
      builder: (context) => SizedBox(
        width: MediaQuery.of(context).size.width * 0.5,
        child: Dialog(
          child: CachedNetworkImage(
            imageUrl: photo.largeImageURL,
            progressIndicatorBuilder: (context, url, progress) {
              return Center(
                child: CircularProgressIndicator(
                  value: progress.progress ?? 1 / 100,
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // CrossAxisCount for MasonryGridView
    // if screen width is greater than 600, crossAxisCount = 3 else 2
    int crossAxisCount = (MediaQuery.of(context).size.width > 600) ? 3 : 2;

    return Scaffold(
      appBar: AppBar(title: const Text("Pixabay")),
      body: Consumer<HomeProvider>(
        builder: (context, provider, child) {
          // Loading Widget
          if (provider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          // show error message and retry button, on page 1
          if (provider.error != null && provider.photos.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(provider.error!),
                  const SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: () async {
                      provider.clearError();
                      await provider.getImages();
                    },
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }

          // MasonryGridView to display images
          return MasonryGridView.count(
            controller: _scrollController,
            itemCount: provider.photos.length,
            crossAxisCount: crossAxisCount,
            shrinkWrap: true,
            itemBuilder: (context, index) {
              Photo photo = provider.photos[index];
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: GestureDetector(
                  key: Key(photo.id.toString()),
                  onTap: () => viewImageDialog(photo),
                  child: CachedNetworkImage(
                    imageUrl: photo.webformatURL,
                    imageBuilder: (context, imageProvider) {
                      return Stack(
                        alignment: Alignment.bottomLeft,
                        fit: StackFit.loose,
                        children: [
                          CachedNetworkImage(imageUrl: photo.webformatURL),
                          Align(
                            alignment: Alignment.bottomLeft,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                children: [
                                  const Icon(Icons.thumb_up,
                                      color: Colors.white),
                                  const SizedBox(width: 4),
                                  Text(
                                    photo.likes.formatToK(),
                                    // Replace with actual likes data
                                    style: const TextStyle(color: Colors.white),
                                  ),
                                  const SizedBox(width: 16),
                                  const Icon(Icons.visibility,
                                      color: Colors.white),
                                  const SizedBox(width: 4),
                                  Text(
                                    photo.views.formatToK(),
                                    // Replace with actual views data
                                    style: const TextStyle(color: Colors.white),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
