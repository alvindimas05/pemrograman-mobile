import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'home_screen.dart';
import 'explore_screen.dart';
import 'saved_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = const [
    HomeScreen(),
    ExploreScreen(),
    SavedScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF3F4F6),
      body: Center(
        child: Container(
          width: 375,
          height: 812,
          decoration: const BoxDecoration(
            color: Colors.white,
          ),
          clipBehavior: Clip.none,
          child: Column(
            children: [
              // Status Bar Mock
              Container(
                height: 44,
                color: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      '9:41',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF1F2937),
                      ),
                    ),
                    Row(
                      children: [
                        Container(
                          width: 16,
                          height: 12,
                          decoration: BoxDecoration(
                            color: const Color(0xFFD1D5DB),
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Container(
                          width: 16,
                          height: 12,
                          decoration: BoxDecoration(
                            color: const Color(0xFFD1D5DB),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Container(
                          width: 24,
                          height: 12,
                          decoration: BoxDecoration(
                            color: const Color(0xFFD1D5DB),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // Screen Content
              Expanded(
                child: _screens[_currentIndex],
              ),

              // Bottom Nav
              Container(
                height: 64,
                decoration: const BoxDecoration(
                  color: Colors.white,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _NavItem(
                      icon: LucideIcons.home,
                      label: 'Home',
                      isActive: _currentIndex == 0,
                      onTap: () => setState(() => _currentIndex = 0),
                    ),
                    _NavItem(
                      icon: LucideIcons.compass,
                      label: 'Explore',
                      isActive: _currentIndex == 1,
                      onTap: () => setState(() => _currentIndex = 1),
                    ),
                    _NavItem(
                      icon: LucideIcons.bookmark,
                      label: 'Saved',
                      isActive: _currentIndex == 2,
                      onTap: () => setState(() => _currentIndex = 2),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isActive;
  final VoidCallback onTap;

  const _NavItem({
    required this.icon,
    required this.label,
    required this.isActive,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final color = isActive ? const Color(0xFF111827) : const Color(0xFF9CA3AF);
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: SizedBox(
        width: 64,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 24, color: color),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 10,
                color: color,
                fontWeight: isActive ? FontWeight.w600 : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
