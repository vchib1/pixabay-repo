import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:pixabay/model/photo.dart';
import 'package:pixabay/utils/extension/int_extension.dart';
import 'package:pixabay/views/provider/home_provider.dart';
import 'package:provider/provider.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  // Fetch more images when scroll reaches end
  Future<void> fetchMore(
      BuildContext context, ScrollNotification notification) async {
    final homeProvider = context.read<HomeProvider>();

    bool scrollReachedEnd =
        (notification.metrics.pixels == notification.metrics.maxScrollExtent);

    // If not reached end, return
    if (!scrollReachedEnd || homeProvider.isFetchingMore) return;

    // If reached end, fetch more images
    debugPrint("Fetching more images");
    await homeProvider.getImages();

    // If error, show error dialog
    if (homeProvider.error != null && context.mounted) {
      await errorHandlerDialog(context);
    }
  }

  // Error dialog
  Future<void> errorHandlerDialog(BuildContext context) async {
    final homeProvider = Provider.of<HomeProvider>(context, listen: false);

    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Error'),
        content: Text(homeProvider.error ?? "Unknown error"),
        actions: [
          TextButton(
            onPressed: () async {
              homeProvider.clearError();

              Navigator.of(context).pop();

              await homeProvider.getImages();

              if (homeProvider.error != null && context.mounted) {
                await errorHandlerDialog(context);
              }
            },
            child: const Text('Retry'),
          ),
          TextButton(
            onPressed: () {
              homeProvider.clearError();
              Navigator.of(context).pop();
            },
            child: const Text('Cancel'),
          ),
        ],
      ),
    );
  }

  // View image dialog
  Future<void> viewImageDialog(BuildContext context, Photo photo) async {
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

  int getCrossAxisCountBasedOnWidth(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    if (width > 1200) {
      return 4;
    } else if (width > 800) {
      return 3;
    } else {
      return 2;
    }
  }

  @override
  Widget build(BuildContext context) {
    // CrossAxisCount for MasonryGridView
    // if screen width is greater than 600, crossAxisCount = 3 else 2
    int crossAxisCount = getCrossAxisCountBasedOnWidth(context);

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

          int itemCount =
              provider.photos.length + (provider.isFetchingMore ? 1 : 0);

          return NotificationListener<ScrollNotification>(
            onNotification: (notification) {
              fetchMore(context, notification);
              return true;
            },
            child: MasonryGridView.count(
              itemCount: itemCount,
              crossAxisCount: crossAxisCount,
              shrinkWrap: true,
              itemBuilder: (context, index) {
                if ((index == provider.photos.length) &&
                    provider.isFetchingMore) {
                  return const SizedBox(
                    height: 150,
                    width: double.infinity,
                    child: Center(
                      child: CircularProgressIndicator(),
                    ),
                  );
                }

                Photo photo = provider.photos[index];
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: GestureDetector(
                    key: Key(photo.id.toString()),
                    onTap: () => viewImageDialog(context, photo),
                    child: CachedNetworkImage(
                      imageUrl: photo.webFormatUrl,
                      imageBuilder: (context, imageProvider) {
                        return Stack(
                          alignment: Alignment.bottomLeft,
                          fit: StackFit.loose,
                          children: [
                            CachedNetworkImage(imageUrl: photo.webFormatUrl),
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
                                      style:
                                          const TextStyle(color: Colors.white),
                                    ),
                                    const SizedBox(width: 16),
                                    const Icon(Icons.visibility,
                                        color: Colors.white),
                                    const SizedBox(width: 4),
                                    Text(
                                      photo.views.formatToK(),
                                      // Replace with actual views data
                                      style:
                                          const TextStyle(color: Colors.white),
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
            ),
          );
        },
      ),
    );
  }
}
