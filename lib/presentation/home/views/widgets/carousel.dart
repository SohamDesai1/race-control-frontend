import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class Carousel extends StatelessWidget {
  const Carousel({super.key});

  @override
  Widget build(BuildContext context) {
    final List<String> imgList = [
      'https://placehold.co/600x400/FF0000/FFFFFF.png?text=News+1',
      'https://placehold.co/600x400/00FF00/FFFFFF.png?text=News+2',
      'https://placehold.co/600x400/0000FF/FFFFFF.png?text=News+3',
    ];

    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: CarouselSlider(
        carouselController: CarouselSliderController(),
        options: CarouselOptions(
          height: 22.h,
          autoPlay: true,
          viewportFraction: 0.9,
          enlargeCenterPage: true,
          autoPlayCurve: Curves.easeInOut,
          autoPlayAnimationDuration: const Duration(seconds: 1),
        ),
        items: imgList.map((imageUrl) {
          return Builder(
            builder: (BuildContext context) {
              return Container(
                width: 100.w,
                margin: const EdgeInsets.symmetric(horizontal: 5),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(50),
                  color: Colors.grey[900],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(50),
                  child: Image.network(
                    imageUrl,
                    fit: BoxFit.cover,
                    loadingBuilder: (context, child, progress) {
                      if (progress == null) return child;
                      return Center(
                        child: CircularProgressIndicator(
                          value: progress.expectedTotalBytes != null
                              ? progress.cumulativeBytesLoaded /
                                  (progress.expectedTotalBytes ?? 1)
                              : null,
                          color: Colors.redAccent,
                        ),
                      );
                    },
                  ),
                ),
              );
            },
          );
        }).toList(),
      ),
    );
  }
}
