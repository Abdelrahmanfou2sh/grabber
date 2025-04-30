import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

class HomeSlider extends StatelessWidget {
  const HomeSlider({
    super.key,
    required this.slider,
  });

  final List<String> slider;

  @override
  Widget build(BuildContext context) {
    return CarouselSlider.builder(
      itemCount: slider.length,
      itemBuilder:
          (BuildContext context, int itemIndex, int pageViewIndex) =>
          Image.asset(slider[itemIndex]),
      options: CarouselOptions(
        height: 170,
        autoPlay: true,
        aspectRatio: 3,
        viewportFraction: 0.8,
        autoPlayInterval: const Duration(seconds: 2),
        autoPlayAnimationDuration: const Duration(seconds: 3),
        autoPlayCurve: Curves.fastOutSlowIn,
        enlargeCenterPage: true,
      ),
    );
  }
}
