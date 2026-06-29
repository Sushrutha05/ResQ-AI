import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:resq_ai/features/authentication/presentation/providers/auth_provider.dart';
import 'package:resq_ai/features/profile/presentation/providers/settings_provider.dart';
import 'package:resq_ai/features/tasks/presentation/providers/task_providers.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authStateProvider);
    final userEmail = authState.value?.email ?? 'Developer';
    final displayName = userEmail.split('@')[0];
    final theme = Theme.of(context);

    final tasksAsync = ref.watch(userTasksStreamProvider);
    final tasks = tasksAsync.value ?? [];
    final completedCount = tasks.where((t) => t.status == 'Completed').length;
    final pendingCount = tasks.where((t) => t.status != 'Completed').length;

    final themeMode = ref.watch(themeModeProvider);
    final isStrict = ref.watch(coachStrictnessProvider);

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 220.0,
            floating: false,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      theme.colorScheme.primaryContainer,
                      theme.colorScheme.surface,
                    ],
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(height: 40),
                    CircleAvatar(
                      radius: 50,
                      backgroundColor: const Color(0xFF22C7F2),
                      child: Text(
                        displayName[0].toUpperCase(),
                        style: const TextStyle(
                          fontSize: 40,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ).animate().scale(
                      duration: 400.ms,
                      curve: Curves.easeOutBack,
                    ),
                    const SizedBox(height: 12),
                    Text(
                      displayName,
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ).animate().fade().slideY(begin: 0.2),
                    Text(
                      userEmail,
                      style: TextStyle(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ).animate().fade().slideY(begin: 0.2),
                  ],
                ),
              ),
            ),
          ),
          SliverList(
            delegate: SliverChildListDelegate([
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Stats Row
                    Row(
                      children: [
                        _buildStatCard(
                          context,
                          'Completed',
                          completedCount.toString(),
                          Icons.check_circle,
                          Colors.green,
                        ),
                        const SizedBox(width: 16),
                        _buildStatCard(
                          context,
                          'Pending',
                          pendingCount.toString(),
                          Icons.pending_actions,
                          Colors.orange,
                        ),
                      ],
                    ).animate().fade().slideY(begin: 0.1),
                    const SizedBox(height: 32),

                    // App Settings
                    const Text(
                      'App Settings',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ).animate().fade().slideX(begin: -0.1),
                    const SizedBox(height: 16),
                    _buildSettingsCard(
                      context,
                      children: [
                        ListTile(
                          leading: const Icon(
                            Icons.brightness_6,
                            color: Color(0xFF018ABE),
                          ),
                          title: const Text('Theme'),
                          trailing: DropdownButton<ThemeMode>(
                            value: themeMode,
                            underline: const SizedBox(),
                            items: const [
                              DropdownMenuItem(
                                value: ThemeMode.system,
                                child: Text('System'),
                              ),
                              DropdownMenuItem(
                                value: ThemeMode.light,
                                child: Text('Light'),
                              ),
                              DropdownMenuItem(
                                value: ThemeMode.dark,
                                child: Text('Dark'),
                              ),
                            ],
                            onChanged: (mode) {
                              if (mode != null) {
                                ref
                                    .read(themeModeProvider.notifier)
                                    .setThemeMode(mode);
                              }
                            },
                          ),
                        ),
                        const Divider(height: 1),
                        ListTile(
                          leading: const Icon(
                            Icons.psychology,
                            color: Colors.purple,
                          ),
                          title: const Text('AI Coach Personality'),
                          subtitle: Text(
                            isStrict
                                ? 'Strict & Direct'
                                : 'Gentle & Encouraging',
                          ),
                          trailing: Switch(
                            value: isStrict,
                            onChanged: (val) {
                              ref
                                  .read(coachStrictnessProvider.notifier)
                                  .setStrictness(val);
                            },
                            activeColor: Colors.purple,
                          ),
                        ),
                        const Divider(height: 1),
                        ListTile(
                          leading: const Icon(
                            Icons.sync,
                            color: Colors.indigo,
                          ),
                          title: const Text('Google Calendar Sync'),
                          subtitle: const Text('Connected'),
                          trailing: const Icon(
                            Icons.check_circle,
                            color: Colors.green,
                          ),
                          onTap: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text(
                                  'Calendar sync is active and managed automatically.',
                                ),
                              ),
                            );
                          },
                        ),
                      ],
                    ).animate().fade().slideY(begin: 0.1, delay: 100.ms),
                    const SizedBox(height: 32),

                    // Account Actions
                    const Text(
                      'Account',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ).animate().fade().slideX(begin: -0.1),
                    const SizedBox(height: 16),
                    _buildSettingsCard(
                      context,
                      children: [
                        ListTile(
                          leading: const Icon(
                            Icons.logout,
                            color: Colors.redAccent,
                          ),
                          title: const Text(
                            'Log Out',
                            style: TextStyle(color: Colors.redAccent),
                          ),
                          onTap: () {
                            ref.read(authControllerProvider.notifier).signOut();
                          },
                        ),
                      ],
                    ).animate().fade().slideY(begin: 0.1, delay: 200.ms),

                    const SizedBox(height: 60),
                  ],
                ),
              ),
            ]),
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(
    BuildContext context,
    String title,
    String count,
    IconData icon,
    Color color,
  ) {
    return Expanded(
      child: Card(
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(color: Theme.of(context).colorScheme.outlineVariant),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(icon, color: color, size: 28),
              const SizedBox(height: 12),
              Text(
                count,
                style: const TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                title,
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSettingsCard(
    BuildContext context, {
    required List<Widget> children,
  }) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: Theme.of(context).colorScheme.outlineVariant),
      ),
      child: Column(children: children),
    );
  }
}
