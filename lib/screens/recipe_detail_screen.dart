import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import '../models/meal.dart';
import '../providers/recipe_provider.dart';

class RecipeDetailScreen extends StatelessWidget {
  final Meal meal;

  const RecipeDetailScreen({super.key, required this.meal});

  @override
  Widget build(BuildContext context) {
    return Consumer<RecipeProvider>(
      builder: (context, provider, _) {
        final saved = provider.isSaved(meal.idMeal);

        return Scaffold(
          backgroundColor: Colors.white,
          body: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Image + header overlays
                Stack(
                  children: [
                    Image.network(
                      meal.strMealThumb,
                      width: double.infinity,
                      height: 320,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => Container(
                        width: double.infinity, height: 320, color: Colors.grey,
                      ),
                    ),

                    // Back + Bookmark buttons
                    Positioned(
                      top: 48,
                      left: 16,
                      right: 16,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          _CircleButton(
                            onTap: () => Navigator.of(context).pop(),
                            child: const Icon(
                              LucideIcons.chevronLeft,
                              size: 24,
                              color: Color(0xFF1F2937),
                            ),
                          ),
                          _CircleButton(
                            onTap: () => provider.toggleSaveRecipe(meal),
                            child: Icon(
                              LucideIcons.bookmark,
                              size: 24,
                              color: const Color(0xFF1F2937),
                              fill: saved ? 1.0 : 0.0,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                // Content card
                Transform.translate(
                  offset: const Offset(0, -24),
                  child: Container(
                    decoration: const BoxDecoration(
                      color: Colors.white,
                    ),
                    padding: const EdgeInsets.fromLTRB(20, 24, 20, 32),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          meal.strMeal,
                          style: const TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF111827),
                            height: 1.2,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            _Badge(meal.strCategory),
                            const SizedBox(width: 8),
                            _Badge(meal.strArea),
                          ],
                        ),

                        const SizedBox(height: 24),

                        // Bahan-Bahan
                        const Text(
                          'Bahan-Bahan',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF111827),
                          ),
                        ),
                        const SizedBox(height: 12),
                        SizedBox(
                          height: 96,
                          child: ListView.separated(
                            scrollDirection: Axis.horizontal,
                            itemCount: meal.ingredients.length,
                            separatorBuilder: (_, __) => const SizedBox(width: 16),
                            itemBuilder: (context, i) {
                              final ingredient = meal.ingredients[i];
                              final measure = meal.measures.length > i ? meal.measures[i] : '';
                              return SizedBox(
                                width: 72,
                                child: Column(
                                  children: [
                                    ClipOval(
                                      child: Image.network(
                                        'https://www.themealdb.com/images/ingredients/$ingredient-Small.png',
                                        width: 64,
                                        height: 64,
                                        fit: BoxFit.contain,
                                        errorBuilder: (_, __, ___) => Container(
                                          width: 64, height: 64, color: Colors.grey,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      '$measure $ingredient',
                                      textAlign: TextAlign.center,
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 2,
                                      style: const TextStyle(
                                        fontSize: 10,
                                        fontWeight: FontWeight.w500,
                                        color: Color(0xFF4B5563),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                        ),

                        const SizedBox(height: 24),

                        // Cara Memasak
                        const Text(
                          'Cara Memasak',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF111827),
                          ),
                        ),
                        const SizedBox(height: 12),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: meal.strInstructions
                              .split(RegExp(r'\r?\n'))
                              .where((step) {
                                final s = step.trim();
                                return s.isNotEmpty && !RegExp(r'^(Step\s*\d+:?|\d+[\.\)]?)$', caseSensitive: false).hasMatch(s);
                              })
                              .toList()
                              .asMap()
                              .entries
                              .map((entry) {
                                final index = entry.key + 1;
                                var stepText = entry.value.trim();
                                stepText = stepText.replaceAll(RegExp(r'^(Step\s*\d+:?|\d+[\.\)]?)\s*', caseSensitive: false), '');

                                return Padding(
                                  padding: const EdgeInsets.only(bottom: 8.0),
                                  child: Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        '$index. ',
                                        style: const TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold,
                                          color: Color(0xFF374151),
                                          height: 1.6,
                                        ),
                                      ),
                                      Expanded(
                                        child: Text(
                                          stepText,
                                          style: const TextStyle(
                                            fontSize: 14,
                                            color: Color(0xFF374151),
                                            height: 1.6,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              })
                              .toList(),
                        ),

                        const SizedBox(height: 24),

                        // YouTube Button
                        if (meal.strYoutube.isNotEmpty)
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton.icon(
                              onPressed: () async {
                                final uri = Uri.parse(meal.strYoutube);
                                if (await canLaunchUrl(uri)) {
                                  await launchUrl(uri, mode: LaunchMode.externalApplication);
                                }
                              },
                              icon: const Icon(LucideIcons.youtube, size: 20),
                              label: const Text(
                                'Watch Tutorial',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15,
                                ),
                              ),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFFDC2626),
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(vertical: 14),
                                shape: const RoundedRectangleBorder(),
                                elevation: 3,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _CircleButton extends StatelessWidget {
  final VoidCallback onTap;
  final Widget child;

  const _CircleButton({required this.onTap, required this.child});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.92),
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 6,
            ),
          ],
        ),
        child: Center(child: child),
      ),
    );
  }
}

class _Badge extends StatelessWidget {
  final String text;
  const _Badge(this.text);

  @override
  Widget build(BuildContext context) {
    if (text.isEmpty) return const SizedBox.shrink();
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color: const Color(0xFFF3F4F6),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: Color(0xFF374151),
        ),
      ),
    );
  }
}
