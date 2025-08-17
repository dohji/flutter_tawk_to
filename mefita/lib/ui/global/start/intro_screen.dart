import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:mefita/routes/app_routes.dart';
import 'package:mefita/services/helpers/storage_service.dart';

class IntroScreen extends StatefulWidget {
  const IntroScreen({super.key});

  @override
  State<IntroScreen> createState() => _IntroScreenState();
}

class _IntroScreenState extends State<IntroScreen> {
  final PageController _pageController = PageController();
  final _currentPage = 0.obs;
  final _storage = const FlutterSecureStorage();

  final List<OnboardingPage> _pages = [
    // 1
    OnboardingPage(
      title: 'Get Reliable ',
      highlightedText: 'Roadside Assistance',
      description: 'Quickly get help when your vehicle breaks down anytime and anywhere.',
      imagePath: 'assets/images/onboarding1.webp',
    ),

// 2
    OnboardingPage(
      title: 'Find Nearby ',
      highlightedText: 'Auto Service Providers',
      description: 'Easily discover local mechanics and garages using the interactive map.',
      imagePath: 'assets/images/onboarding2.webp',
    ),

// 3
    OnboardingPage(
      title: 'Request Towing Services ',
      highlightedText: 'In Seconds',
      description: 'Get matched with the closest tow truck and track its live arrival.',
      imagePath: 'assets/images/onboarding3.webp',
    ),

// 4
    OnboardingPage(
      title: 'Trusted And Verified ',
      highlightedText: 'Automotive Experts',
      description: 'Connect with top-rated professionals reviewed by real drivers on the platform.',
      imagePath: 'assets/images/onboarding4.webp',
    ),
  ];

  Future<void> _completeIntro() async {
    await StorageService.instance.markSeenIntroScreen();
    Get.offNamed(AppRoutes.login);
  }

  void _nextPage() {
    if (_currentPage.value < _pages.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      _completeIntro();
    }
  }

  void _previousPage() {
    if (_currentPage.value > 0) {
      _pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Colors.transparent,
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: Column(
        children: [
          // Skip button
          // Padding(
          //   padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          //   child: Row(
          //     mainAxisAlignment: MainAxisAlignment.end,
          //     children: [
          //       TextButton(
          //         onPressed: _completeIntro,
          //         child: Text(
          //           'Skip',
          //           style: Theme.of(context).textTheme.titleMedium?.copyWith(
          //             color: Theme.of(context).colorScheme.primary,
          //           ),
          //         ),
          //       ),
          //     ],
          //   ),
          // ),
          // Page view
          Expanded(
            child: PageView.builder(
              controller: _pageController,
              onPageChanged: (index) => _currentPage.value = index,
              itemCount: _pages.length,
              itemBuilder: (context, index) => _buildPage(_pages[index]),
            ),
          ),
          // Navigation and indicators
          Padding(
            padding: const EdgeInsets.all(24),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Back button
                Obx(() => _currentPage.value > 0
                  ? _buildNavButton(
                      icon: Icons.arrow_back,
                      onPressed: _previousPage,
                      isOutlined: true,
                    )
                  : const SizedBox(width: 56)),
                // Page indicators
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(
                    _pages.length,
                    (index) => Obx(() => Container(
                      width: 8,
                      height: 8,
                      margin: const EdgeInsets.symmetric(horizontal: 4),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: _currentPage.value == index
                            ? Theme.of(context).colorScheme.primary
                            : Theme.of(context).colorScheme.primary.withOpacity(0.3),
                      ),
                    )),
                  ),
                ),
                // Next/Done button
                _buildNavButton(
                  icon: Icons.arrow_forward,
                  onPressed: _nextPage,
                  isOutlined: false,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPage(OnboardingPage page) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Expanded(
          flex: 3,
          child: ClipPath(
            clipper: ArcClipper(),
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Theme.of(context).colorScheme.onSurface.withOpacity(0.0),
                    Theme.of(context).colorScheme.onSurface.withOpacity(0.07),
                  ],
                ),
              ),
              child: FractionallySizedBox(
                // heightFactor: 1.4,
                alignment: Alignment.topCenter,
                child: Image.asset(
                  page.imagePath,
                  fit: BoxFit.fitHeight,
                  alignment: Alignment.topCenter,
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 20),
        // Title
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Text.rich(
            TextSpan(
              children: [
                TextSpan(
                  text: page.title.replaceAll(page.highlightedText, ''),
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    color: Theme.of(context).colorScheme.onBackground,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                TextSpan(
                  text: page.highlightedText,
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    color: Theme.of(context).colorScheme.primary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            textAlign: TextAlign.center,
          ),
        ),
        const SizedBox(height: 16),
        // Description
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Text(
            page.description,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              color: Theme.of(context).colorScheme.onBackground.withOpacity(0.7),
            ),
            textAlign: TextAlign.center,
          ),
        ),
        const SizedBox(height: 40),
      ],
    );
  }

  Widget _buildNavButton({
    required IconData icon,
    required VoidCallback onPressed,
    required bool isOutlined,
  }) {
    return Container(
      width: 56,
      height: 56,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: isOutlined ? Colors.transparent : Theme.of(context).colorScheme.primary,
        border: isOutlined ? Border.all(
          color: Theme.of(context).colorScheme.primary,
          width: 1,
        ) : null,
      ),
      child: IconButton(
        icon: Icon(icon),
        color: isOutlined 
          ? Theme.of(context).colorScheme.primary
          : Theme.of(context).colorScheme.onPrimary,
        onPressed: onPressed,
      ),
    );
  }
}

class OnboardingPage {
  final String title;
  final String highlightedText;
  final String description;
  final String imagePath;

  OnboardingPage({
    required this.title,
    required this.highlightedText,
    required this.description,
    required this.imagePath,
  });
}

class ArcClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    path.lineTo(0, size.height - 40);
    path.quadraticBezierTo(
      size.width / 2, size.height,
      size.width, size.height - 40,
    );
    path.lineTo(size.width, 0);
    path.lineTo(0, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}