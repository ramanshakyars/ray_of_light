import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rayoflite/core/theme/appcolors.dart';
import 'package:rayoflite/core/theme/themeProvider.dart';

class MediaCarousel extends StatefulWidget {
  final List<String> mediaUrls;

  const MediaCarousel({super.key, required this.mediaUrls});

  @override
  State<MediaCarousel> createState() => _MediaCarouselState();
}

class _MediaCarouselState extends State<MediaCarousel> {
  final PageController _controller = PageController();
  int index = 0;

  @override
  Widget build(BuildContext context) {
    final isDark = context.watch<ThemeProvider>().isDarkMode;

    return Column(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(18),
          child: AspectRatio(
            aspectRatio: 4 / 3,
            child: PageView.builder(
              controller: _controller,
              itemCount: widget.mediaUrls.length,
              onPageChanged: (i) => setState(() => index = i),
              itemBuilder: (_, i) {
                return CachedNetworkImage(
                  imageUrl: widget.mediaUrls[i],
                  fit: BoxFit.cover,
                  placeholder: (_, __) => Container(
                    color: AppColors.getMonoSurface(isDark),
                    child: const Center(child: CircularProgressIndicator()),
                  ),
                  errorWidget: (_, __, ___) =>
                      const Center(child: Icon(Icons.broken_image)),
                );
              },
            ),
          ),
        ),

        if (widget.mediaUrls.length > 1) ...[
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
              widget.mediaUrls.length,
              (i) => Container(
                margin: const EdgeInsets.symmetric(horizontal: 3),
                width: index == i ? 16 : 6,
                height: 6,
                decoration: BoxDecoration(
                  color: index == i ? Colors.black : Colors.grey,
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          ),
        ],
      ],
    );
  }
}