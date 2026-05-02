import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:webview_flutter/webview_flutter.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: WebViewScreen(),
    );
  }
}

class WebViewScreen extends StatefulWidget {
  const WebViewScreen({super.key});

  @override
  State<WebViewScreen> createState() => _WebViewScreenState();
}

class _WebViewScreenState extends State<WebViewScreen> {
  late final WebViewController controller;
  bool isLoading = true;

  int currentIndex = 0;

  final List<String> urls = [
    "https://majidalbana.com",
    "https://majidalbana.com/#lectures",
    "https://majidalbana.com/#pdfposts",
    "https://majidalbana.com/#posts",
    "https://majidalbana.com/#sitting",
  ];

  @override
  void initState() {
    super.initState();

    controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageStarted: (url) {
            setState(() => isLoading = true);
          },
          onPageFinished: (url) {
            setState(() => isLoading = false);
          },
        ),
      )
      ..loadRequest(Uri.parse(urls[0]));
  }

  void changePage(int index) {
    setState(() {
      currentIndex = index;
      isLoading = true;
    });

    controller.loadRequest(Uri.parse(urls[index]));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Stack(
          children: [
            SizedBox.expand(
              child: WebViewWidget(controller: controller),
            ),

            // 🔥 Loading
            if (isLoading)
              Container(
                color: const Color.fromARGB(255, 0, 2, 10),
                child: const Center(
                  child: CircularProgressIndicator(
                    color: Color.fromARGB(255, 204, 134, 30),
                  ),
                ),
              ),

            // 🔥 البار الزجاجي
            glassNavBar(),
          ],
        ),
      ),
    );
  }

  // ===== Glass NavBar =====
  Widget glassNavBar() {
    return Positioned(
      bottom: 15,
      left: 16,
      right: 16,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(25),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
          child: Container(
            height: 85,
            padding: const EdgeInsets.symmetric(horizontal: 10),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.08),
              borderRadius: BorderRadius.circular(25),
              border: Border.all(
                color: Colors.white.withOpacity(0.2),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                navItem(Icons.settings, "الإعدادات", 4),
                divider(),
                navItem(Icons.category, "الدورات", 1),
                divider(),
                navItem(Icons.grid_view, "الملفات", 2),
                divider(),
                navItem(Icons.image, "المنشورات", 3),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ===== عنصر الفاصل =====
  Widget divider() {
    return Container(
      width: 1,
      height: 30,
      color: Colors.white24,
    );
  }

  // ===== عنصر الأيقونة =====
  Widget navItem(IconData icon, String label, int index) {
    bool isActive = currentIndex == index;

    return GestureDetector(
      onTap: () => changePage(index),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          color: isActive
              ? Colors.white.withOpacity(0.15)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(15),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 26,
              color: isActive ? Colors.white : Colors.grey,
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 11,
                color: isActive ? Colors.white : Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }
}