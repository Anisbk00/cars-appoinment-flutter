// ignore_for_file: deprecated_member_use, library_private_types_in_public_api, file_names
import 'package:cars_appointments/Screens/nav.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

class OnboardingSignUpScreen extends StatefulWidget {
  const OnboardingSignUpScreen({super.key});

  @override
  State<OnboardingSignUpScreen> createState() => _OnboardingSignUpScreenState();
}

class OnboardingPageData {
  final String title;
  final String description;
  final String imageAsset;

  OnboardingPageData({
    required this.title,
    required this.description,
    required this.imageAsset,
  });
}

class _OnboardingSignUpScreenState extends State<OnboardingSignUpScreen> {
  final _formKey = GlobalKey<FormState>();
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<OnboardingPageData> onboardingPages = [
    OnboardingPageData(
      title: "Book Car Services Easily",
      description: "Schedule maintenance and repairs with certified technicians in just a few taps.",
      imageAsset: 'assets/carservice.svg',
    ),
    OnboardingPageData(
      title: "Real-Time Tracking",
      description: "Monitor your appointment status and get live updates instantly.",
      imageAsset: 'assets/realtime.svg',
    ),
    OnboardingPageData(
      title: "Expert Technicians",
      description: "Our professionals use state-of-the-art equipment for your vehicle.",
      imageAsset: 'assets/expert.svg',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF2A4B7C), Color(0xFF1A1A2F)],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              _buildSkipButton(),
              Expanded(child: _buildPageView()),
              _buildPageIndicator(),
              _buildNavControls(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSkipButton() {
    return Align(
      alignment: Alignment.topRight,
      child: TextButton(
        onPressed: () => _jumpToSignUp(),
        child: const Text('Skip', style: TextStyle(color: Colors.white70)),
      ),
    );
  }

  Widget _buildPageView() {
    return PageView.builder(
      controller: _pageController,
      itemCount: onboardingPages.length + 1,
      onPageChanged: (i) => setState(() => _currentPage = i),
      itemBuilder: (context, index) {
        if (index < onboardingPages.length) {
          return _onboardingContent(onboardingPages[index]);
        } else {
          return _signUpPage();
        }
      },
    );
  }

  Widget _onboardingContent(OnboardingPageData page) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SvgPicture.asset(page.imageAsset, height: 220),
          const SizedBox(height: 32),
          Text(page.title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                  fontSize: 26, fontWeight: FontWeight.bold, color: Colors.white)),
          const SizedBox(height: 16),
          Text(page.description,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 16, color: Colors.white70)),
        ],
      ),
    );
  }

  Widget _signUpPage() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          SvgPicture.asset('assets/car_illustration.svg', height: 220),
          const SizedBox(height: 24),
          _buildSignUpForm(),
          const SizedBox(height: 24),
          _buildSocialButtons(),
        ],
      ),
    );
  }

  Widget _buildSignUpForm() {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          TextFormField(
            decoration: InputDecoration(
                filled: true,
                fillColor: Colors.white,
                prefixIcon: const Icon(Icons.email),
                hintText: 'Email',
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none)),
            validator: (v) => (v?.isEmpty ?? true) ? 'Enter email' : null,
          ),
          const SizedBox(height: 16),
          TextFormField(
            obscureText: true,
            decoration: InputDecoration(
                filled: true,
                fillColor: Colors.white,
                prefixIcon: const Icon(Icons.lock),
                hintText: 'Password',
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none)),
            validator: (v) => (v?.isEmpty ?? true) ? 'Enter password' : null,
          ),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _handleSignUp,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              child: const Text('Sign Up', style: TextStyle(fontSize: 16)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSocialButtons() {
    return Column(
      children: [
        const Text('Or continue with', style: TextStyle(color: Colors.white70)),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _socialButton('assets/google_logo.svg'),
            const SizedBox(width: 16),
            _socialButton('assets/apple_logo.svg'),
          ],
        )
      ],
    );
  }

  Widget _socialButton(String asset) {
    return InkWell(
      onTap: () {},
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white10,
          borderRadius: BorderRadius.circular(8),
        ),
        child: SvgPicture.asset(asset, height: 24),
      ),
    );
  }

  Widget _buildPageIndicator() {
    int total = onboardingPages.length + 1;
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(total, (i) {
        bool active = i == _currentPage;
        return AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          margin: const EdgeInsets.symmetric(horizontal: 4, vertical: 16),
          width: active ? 20 : 8,
          height: 8,
          decoration: BoxDecoration(
            color: active ? Colors.white : Colors.white38,
            borderRadius: BorderRadius.circular(4),
          ),
        );
      }),
    );
  }

  Widget _buildNavControls() {
    bool isLast = _currentPage == onboardingPages.length;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          if (_currentPage > 0)
            IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () => _pageController.previousPage(
                  duration: const Duration(milliseconds: 300), curve: Curves.easeInOut),
            )
          else
            const SizedBox(width: 48),
          ElevatedButton(
            onPressed: () {
              if (!isLast) {
                _pageController.nextPage(
                    duration: const Duration(milliseconds: 300), curve: Curves.easeInOut);
              } else {
                _handleSignUp();
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF00C853),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
            ),
            child: Text(isLast ? 'Sign Up' : 'Next', style: const TextStyle(fontSize: 16)),
          ),
        ],
      ),
    );
  }

  void _jumpToSignUp() {
    _pageController.animateToPage(onboardingPages.length,
        duration: const Duration(milliseconds: 500), curve: Curves.easeInOut);
  }

  void _handleSignUp() {
    if (_formKey.currentState?.validate() ?? false) {
      Get.off(
        () => const navHome(),
        transition: Transition.fadeIn,
        duration: const Duration(milliseconds: 500),
      );
    } else if (_currentPage < onboardingPages.length) {
      _jumpToSignUp();
    }
  }
}
