import 'package:blog_wave/core/theme/app_pallete.dart';
import 'package:blog_wave/features/blog/presentation/pages/blog_page.dart';
import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:lordicon/lordicon.dart';

class OnBoardingScreen extends StatefulWidget {
  static route() =>
      MaterialPageRoute(builder: ((context) => const OnBoardingScreen()));
  const OnBoardingScreen({super.key});

  @override
  State<OnBoardingScreen> createState() => _OnBoardingScreenState();
}

class _OnBoardingScreenState extends State<OnBoardingScreen> {
  PageController _dotController = PageController();
  bool onLastPage = false;

  @override
  Widget build(BuildContext context) {
    var doc = IconController.assets('/doc.json');
    var profile = IconController.assets('/profile.json');
    var share = IconController.assets('/share.json');

    doc.addStatusListener((status) {
      if (status == ControllerStatus.ready) {
        doc.playFromBeginning();
      }
    });
    profile.addStatusListener((status) {
      if (status == ControllerStatus.ready) {
        profile.playFromBeginning();
      }
    });
    share.addStatusListener((status) {
      if (status == ControllerStatus.ready) {
        share.playFromBeginning();
      }
    });

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
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconViewer(
                  controller: doc,
                  width: 200,
                  height: 200,
                ),
                const SizedBox(height: 50),
                Text.rich(
                    textAlign: TextAlign.center,
                    createContent("Write what you love",
                        "Start your blogging journey on the go with stunning visuals.")),
              ],
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconViewer(
                  controller: profile,
                  width: 200,
                  height: 200,
                ),
                const SizedBox(height: 50),
                Text.rich(
                    textAlign: TextAlign.center,
                    createContent("Showcase Your Style",
                        "Add personality to your profile and let your images tell a story.")),
              ],
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconViewer(
                  controller: share,
                  width: 200,
                  height: 200,
                ),
                const SizedBox(height: 50),
                Text.rich(
                    textAlign: TextAlign.center,
                    createContent("Publish Your Masterpiece",
                        "Craft your blog post with captivating words and stunning visuals. Hit publish and share your voice with the world! ")),
              ],
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
                    Navigator.pushAndRemoveUntil(
                        context, BlogPage.route(false), (route) => false);
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

TextSpan createContent(String title, String description) {
  return TextSpan(
    children: [
      TextSpan(
        text: '$title\n',
        style: const TextStyle(fontSize: 35, fontWeight: FontWeight.w700),
      ),
      TextSpan(
        text: description,
        style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w400),
      ),
    ],
  );
}
