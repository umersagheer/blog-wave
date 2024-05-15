import 'package:blog_wave/core/theme/app_pallete.dart';
import 'package:blog_wave/features/blog/presentation/pages/blog_page.dart';
import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class OnBoardingScreen extends StatefulWidget {
  const OnBoardingScreen({super.key});

  @override
  State<OnBoardingScreen> createState() => _OnBoardingScreenState();
}

class _OnBoardingScreenState extends State<OnBoardingScreen> {
  PageController _dotController = PageController();
  bool onLastPage = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(children: [
        PageView(
          controller: _dotController,
          onPageChanged: (index) {
            setState(() {
              onLastPage = (index == 2);
            });
          },
          children: [
            Container(
              color: AppPallete.backgroundColor,
            ),
            Container(
              color: AppPallete.backgroundColor,
            ),
            Container(
              color: AppPallete.backgroundColor,
            ),
          ],
        ),

        // Dots
        Container(
          alignment: const Alignment(0, 0.8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              // skip
              TextButton(
                onPressed: () {
                  _dotController.jumpToPage(2);
                },
                child: const Text(
                  'Skip',
                  style: TextStyle(color: AppPallete.whiteColor, fontSize: 15),
                ),
              ),

              // indicator
              SmoothPageIndicator(
                axisDirection: Axis.horizontal,
                controller: _dotController,
                count: 3,
                effect: const ExpandingDotsEffect(
                  dotHeight: 5,
                  dotWidth: 12,
                  expansionFactor: 3,
                  activeDotColor: AppPallete.gradient1,
                  dotColor: Colors.grey,
                ),
              ),

              // next
              TextButton(
                onPressed: () {
                  if (onLastPage) {
                    Navigator.push(context, BlogPage.route());
                  }
                  _dotController.nextPage(
                      duration: const Duration(milliseconds: 500),
                      curve: Curves.easeInSine);
                },
                child: Text(
                  onLastPage ? 'Start' : 'Next',
                  style: const TextStyle(
                      color: AppPallete.whiteColor, fontSize: 15),
                ),
              ),
            ],
          ),
        )
      ]),
    );
  }
}
