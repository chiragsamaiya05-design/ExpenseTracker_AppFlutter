import 'package:flutter/material.dart';

import 'home_screen.dart';
import 'summary_screen.dart';
import 'charts_screen.dart';
import 'budget_screen.dart';

class MainNavigationScreen extends StatefulWidget {
  const MainNavigationScreen({super.key});

  @override
  State<MainNavigationScreen> createState() =>
      _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  int currentIndex = 0;

  final PageController pageController = PageController();

  final List<Widget> screens = [
    HomeScreen(),
    const SummaryScreen(),
    const ChartsScreen(),
    const BudgetScreen(),
  ];


  void onTabChanged(int index) {
    setState(() {
      currentIndex = index;
    });

    pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 3500),
      curve: Curves.easeOutCubic,
    );
  }


  void onPageChanged(int index) {
    setState(() {
      currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: pageController,
        onPageChanged: onPageChanged,
        physics: const PageScrollPhysics(),
        children: screens,
      ),

      bottomNavigationBar: NavigationBar(
        height: 72,
        backgroundColor: Colors.white,
        elevation: 3,
        shadowColor: Colors.black12,

        indicatorColor: const Color(0xFFE8E7FF),

        selectedIndex: currentIndex,
        onDestinationSelected: onTabChanged,

        labelBehavior:
        NavigationDestinationLabelBehavior.alwaysShow,

        destinations: const [
          NavigationDestination(
            icon: Icon(
              Icons.home_outlined,
              color: Color(0xFF77758A),
            ),
            selectedIcon: Icon(
              Icons.home_rounded,
              color: Color(0xFF4F46A5),
            ),
            label: 'Home',
          ),

          NavigationDestination(
            icon: Icon(
              Icons.summarize_outlined,
              color: Color(0xFF77758A),
            ),
            selectedIcon: Icon(
              Icons.summarize_rounded,
              color: Color(0xFF4F46A5),
            ),
            label: 'Summary',
          ),

          NavigationDestination(
            icon: Icon(
              Icons.bar_chart_outlined,
              color: Color(0xFF77758A),
            ),
            selectedIcon: Icon(
              Icons.bar_chart_rounded,
              color: Color(0xFF4F46A5),
            ),
            label: 'Charts',
          ),

          NavigationDestination(
            icon: Icon(
              Icons.account_balance_wallet_outlined,
              color: Color(0xFF77758A),
            ),
            selectedIcon: Icon(
              Icons.account_balance_wallet_rounded,
              color: Color(0xFF4F46A5),
            ),
            label: 'Budget',
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }
}
class SmallSwipePhysics extends PageScrollPhysics {
  const SmallSwipePhysics({super.parent});

  @override
  SmallSwipePhysics applyTo(ScrollPhysics? ancestor) {
    return SmallSwipePhysics(parent: buildParent(ancestor));
  }

  @override
  double get minFlingDistance => 20.0;

  @override
  double get minFlingVelocity => 300.0;
}