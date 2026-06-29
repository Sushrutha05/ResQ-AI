import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:resq_ai/features/tasks/presentation/screens/tasks_screen.dart';
import 'package:resq_ai/features/schedule/presentation/screens/schedule_screen.dart';
import 'dashboard_screen.dart';
import 'placeholder_screens.dart';
import 'coach_screen.dart';

class NavigationIndexNotifier extends Notifier<int> {
  @override
  int build() => 0;

  void setIndex(int index) {
    state = index;
  }
}

final navigationIndexProvider = NotifierProvider<NavigationIndexNotifier, int>(NavigationIndexNotifier.new);

class NavigationShell extends ConsumerStatefulWidget {
  const NavigationShell({super.key});

  @override
  ConsumerState<NavigationShell> createState() => _NavigationShellState();
}

class _NavigationShellState extends ConsumerState<NavigationShell> {

  final List<Widget> _screens = [
    const DashboardScreen(),
    const TasksScreen(),
    const ScheduleScreen(),
    const CoachScreen(),
    const ProfileScreen(),
  ];

  final List<NavigationDestination> _destinations = const [
    NavigationDestination(
      icon: Icon(Icons.dashboard_outlined),
      selectedIcon: Icon(Icons.dashboard),
      label: 'Dashboard',
    ),
    NavigationDestination(
      icon: Icon(Icons.task_alt_outlined),
      selectedIcon: Icon(Icons.task_alt),
      label: 'Tasks',
    ),
    NavigationDestination(
      icon: Icon(Icons.calendar_today_outlined),
      selectedIcon: Icon(Icons.calendar_today),
      label: 'Calendar',
    ),
    NavigationDestination(
      icon: Icon(Icons.psychology_outlined),
      selectedIcon: Icon(Icons.psychology),
      label: 'AI Coach',
    ),
    NavigationDestination(
      icon: Icon(Icons.person_outline),
      selectedIcon: Icon(Icons.person),
      label: 'Profile',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final width = MediaQuery.of(context).size.width;
    final isLargeScreen = width >= 600;
    
    final selectedIndex = ref.watch(navigationIndexProvider);

    return Scaffold(
      body: Row(
        children: [
          if (isLargeScreen)
            NavigationRail(
              selectedIndex: selectedIndex,
              onDestinationSelected: (index) {
                ref.read(navigationIndexProvider.notifier).setIndex(index);
              },
              labelType: NavigationRailLabelType.all,
              backgroundColor: theme.colorScheme.surfaceContainerLow,
              indicatorColor: theme.colorScheme.primaryContainer,
              selectedIconTheme: IconThemeData(
                color: theme.colorScheme.onPrimaryContainer,
              ),
              unselectedIconTheme: IconThemeData(
                color: theme.colorScheme.onSurfaceVariant,
              ),
              selectedLabelTextStyle: TextStyle(
                color: theme.colorScheme.primary,
                fontWeight: FontWeight.bold,
                fontSize: 12,
              ),
              unselectedLabelTextStyle: TextStyle(
                color: theme.colorScheme.onSurfaceVariant,
                fontSize: 12,
              ),
              destinations:
                  _destinations
                      .map(
                        (d) => NavigationRailDestination(
                          icon: d.icon,
                          selectedIcon: d.selectedIcon,
                          label: Text(d.label),
                        ),
                      )
                      .toList(),
            ),
          Expanded(
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 200),
              child: KeyedSubtree(
                key: ValueKey<int>(selectedIndex),
                child: _screens[selectedIndex],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar:
          !isLargeScreen
              ? NavigationBar(
                selectedIndex: selectedIndex,
                onDestinationSelected: (index) {
                  ref.read(navigationIndexProvider.notifier).setIndex(index);
                },
                backgroundColor: theme.colorScheme.surfaceContainerLow,
                indicatorColor: theme.colorScheme.primaryContainer,
                destinations: _destinations,
              )
              : null,
    );
  }
}
