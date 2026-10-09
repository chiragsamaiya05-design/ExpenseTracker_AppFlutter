import 'package:expense_tracker/Screens/settings/settings_screen.dart';
import 'package:flutter/material.dart';

import 'home_screen.dart';
import '../summary/summary_screen.dart';
import '../summary/charts_screen.dart';
import '../budget/budget_screen.dart';

class MainNavigationScreen extends StatefulWidget {
  const MainNavigationScreen({super.key});

  @override
  State<MainNavigationScreen> createState() =>
      _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  int currentIndex = 0;

  late final PageController pageController;

  late final List<Widget> screens;

  @override
  void initState() {
    super.initState();

    pageController = PageController();

    screens = [
      HomeScreen(),
      const SummaryScreen(),
      const ChartsScreen(),
      const BudgetScreen(),
      const SettingsScreen(),
    ];
  }

  void onTabChanged(int index) {
    if (index == currentIndex) return;

    setState(() {
      currentIndex = index;
    });

    pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOutCubic,
    );
  }

  void onPageChanged(int index) {
    if (currentIndex == index) return;

    setState(() {
      currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: PageView(
        controller: pageController,
        onPageChanged: onPageChanged,
        physics: const PageScrollPhysics(),
        children: screens,
      ),

      bottomNavigationBar: NavigationBarTheme(
        data: NavigationBarThemeData(
          backgroundColor: colorScheme.surface,
          indicatorColor: colorScheme.primaryContainer,
          elevation: 3,
          shadowColor: Colors.black.withValues(
            alpha: theme.brightness == Brightness.dark ? 0.25 : 0.08,
          ),
          surfaceTintColor: Colors.transparent,

          iconTheme: WidgetStateProperty.resolveWith<IconThemeData>(
                (states) {
              if (states.contains(WidgetState.selected)) {
                return IconThemeData(
                  color: colorScheme.onPrimaryContainer,
                  size: 24,
                );
              }

              return IconThemeData(
                color: colorScheme.onSurfaceVariant,
                size: 22,
              );
            },
          ),

          labelTextStyle: WidgetStateProperty.resolveWith<TextStyle>(
                (states) {
              final selected = states.contains(WidgetState.selected);

              return TextStyle(
                fontSize: 11,
                fontWeight:
                selected ? FontWeight.w700 : FontWeight.w500,
                color: selected
                    ? colorScheme.onSurface
                    : colorScheme.onSurfaceVariant,
              );
            },
          ),
        ),
        child: NavigationBar(
          height: 72,
          selectedIndex: currentIndex,
          onDestinationSelected: onTabChanged,
          labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
          destinations: const [
            NavigationDestination(
              icon: Icon(Icons.home_outlined),
              selectedIcon: Icon(Icons.home_rounded),
              label: 'Home',
            ),
            NavigationDestination(
              icon: Icon(Icons.summarize_outlined),
              selectedIcon: Icon(Icons.summarize_rounded),
              label: 'Summary',
            ),
            NavigationDestination(
              icon: Icon(Icons.bar_chart_outlined),
              selectedIcon: Icon(Icons.bar_chart_rounded),
              label: 'Charts',
            ),
            NavigationDestination(
              icon: Icon(Icons.account_balance_wallet_outlined),
              selectedIcon: Icon(Icons.account_balance_wallet_rounded),
              label: 'Budget',
            ),
            NavigationDestination(
              icon: Icon(Icons.settings_outlined),
              selectedIcon: Icon(Icons.settings_rounded),
              label: 'Settings',
            ),
          ],
        ),
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