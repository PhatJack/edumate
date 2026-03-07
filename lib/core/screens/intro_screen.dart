import 'package:edumate/core/constants/images.dart';
import 'package:edumate/core/extensions/theme_extension.dart';
import 'package:edumate/core/widgets/app_safearea.dart';
import 'package:flutter/material.dart';
import 'package:edumate/core/constants/sizes.dart';

class IntroSlide {
  const IntroSlide({
    required this.id,
    required this.title,
    required this.description,
    required this.image,
  });

  final int id;
  final String title;
  final String description;
  final String image;
}

class IntroScreen extends StatefulWidget {
  const IntroScreen({super.key});

  @override
  State<IntroScreen> createState() => _IntroScreenState();
}

class _IntroScreenState extends State<IntroScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  static const List<IntroSlide> _slides = [
    IntroSlide(
      id: 1,
      title: 'Học tiếng Anh qua trò chuyện',
      description:
          'Giúp trẻ làm quen với tiếng Anh thông qua các cuộc trò chuyện đơn giản và thú vị.',
      image: 'assets/images/intro_chat.png',
    ),
    IntroSlide(
      id: 2,
      title: 'Luyện tập mỗi ngày',
      description:
          'Trẻ có thể luyện từ vựng và câu tiếng Anh hằng ngày cùng chatbot.',
      image: 'assets/images/intro_practice.png',
    ),
    IntroSlide(
      id: 3,
      title: 'Hỗ trợ cho phụ huynh và giáo viên',
      description:
          'Cung cấp công cụ giúp theo dõi và hỗ trợ quá trình học tiếng Anh của trẻ.',
      image: 'assets/images/intro_teacher.jpg',
    ),
  ];

  bool get _isLastPage => _currentPage == _slides.length - 1;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      body: AppSafeArea(
        child: Column(
          children: [
            const SizedBox(height: 12),
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.asset(
                EImages.playStoreLogo,
                height: 70,
                fit: BoxFit.contain,
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                itemCount: _slides.length,
                onPageChanged: (index) {
                  setState(() {
                    _currentPage = index;
                  });
                },
                itemBuilder: (context, index) {
                  final slide = _slides[index];
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Column(
                      children: [
                        Expanded(
                          child: Image.asset(
                            slide.image,
                            fit: BoxFit.contain,
                            errorBuilder: (context, error, stackTrace) {
                              return Center(
                                child: Icon(
                                  Icons.image_outlined,
                                  size: 72,
                                  color: colorScheme.primary,
                                ),
                              );
                            },
                          ),
                        ),
                        const SizedBox(height: 20),
                        Text(
                          slide.title,
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.headlineSmall,
                        ),
                        const SizedBox(height: 12),
                        Text(
                          slide.description,
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.bodyLarge
                              ?.copyWith(color: colorScheme.onSurfaceVariant),
                        ),
                        const SizedBox(height: 40),
                      ],
                    ),
                  );
                },
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(_slides.length, (index) {
                final bool isActive = _currentPage == index;
                return AnimatedContainer(
                  duration: const Duration(milliseconds: 250),
                  width: isActive ? 24 : 8,
                  height: 8,
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  decoration: BoxDecoration(
                    color: isActive
                        ? colorScheme.primary
                        : colorScheme.outline.withValues(alpha: 0.4),
                    borderRadius: BorderRadius.circular(999),
                  ),
                );
              }),
            ),
            const SizedBox(height: 24),
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
              child: SizedBox(
                width: double.infinity,
                child: _isLastPage
                    ? FilledButton(
                        onPressed: () {
                          Navigator.pushReplacementNamed(context, '/login');
                        },
                        style: FilledButton.styleFrom(
                          backgroundColor: colorScheme.primary,
                          foregroundColor: colorScheme.onPrimary,
                          padding: const EdgeInsets.symmetric(
                            vertical: ESizes.sm,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(ESizes.radiusMd),
                          ),
                          textStyle: context.text.titleMedium,
                        ),
                        child: const Text('Bắt đầu'),
                      )
                    : ElevatedButton(
                        onPressed: () {
                          _pageController.nextPage(
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.easeInOut,
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(ESizes.radiusMd),
                          ),
                          padding: const EdgeInsets.symmetric(
                            vertical: ESizes.sm,
                          ),
                          textStyle: context.text.titleMedium,
                        ),
                        child: const Text('Tiếp tục'),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
